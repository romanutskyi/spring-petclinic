pipeline {
    agent any
    stages {
        stage('BUILD') {
            steps {
                echo '=== Building Petclinic Application ==='
                sh './mvnw package'
            }
        }
        stage('CREATE ARTIFACT') {
            steps {
                echo '=== Building Petclinic Docker Image ==='
                script {
                    app = docker.build("romanutskyi/petclinic-eft")
                }
            }
        }
        stage('PUBLISH ARTIFACT') {
            steps {
                echo '=== Pushing Petclinic Docker Image ==='
                script {
                    docker.withRegistry('https://registry.hub.docker.com', '${DOCKER_CREDS}') {
                        app.push("$BUILD_NUMBER")
                        app.push("latest")
                    }
                }
            }
        }
        stage('REMOVE LOCAL IMAGES') {
            steps {
                echo '=== Delete the local docker images ==='
                sh("docker rmi -f romanutskyi/petclinic-spinnaker-jenkins:latest || :")
                sh("docker rmi -f romanutskyi/petclinic-spinnaker-jenkins:$BUILD_NUMBER || :")
            }
        }
        stage('CI DEPLOY') {
            steps {
               ansiblePlaybook(
                    vaultCredentialsId: 'AnsibleVault',
                    inventory: 'ansible/hosts.txt',
                    playbook: 'ansible/petclinic_playbook.yml',
                    disableHostKeyChecking: true
                )
            }
        }
        stage ('DAST') {
          steps {
              sh ("docker run -v /home/ubuntu/:/zap/wrk/:rw -t owasp/zap2docker-stable zap-baseline.py -t http://54.159.130.13 -g gen.conf -r testreport.html 2> /dev/null; ((\$? == 2)) && echo 'Done' >&2 --hook=/zap/wrk/my-hooks.py ")
          }
        }
    }
}
