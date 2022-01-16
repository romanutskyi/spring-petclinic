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
                sh 'ansible-playbook --ask-vault-pass ${ANSIBLE_VAULT} /ansible/petclinic_playbook.yml'
            }

        }

    }
}
