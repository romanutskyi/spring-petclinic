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
  #                  GIT_COMMIT_HASH = sh (script: "git log -n 1 --pretty=format:'%H'", returnStdout: true)
 #                   SHORT_COMMIT = "${GIT_COMMIT_HASH[0..7]}"
                    docker.withRegistry('https://registry.hub.docker.com', '${DOCKER_CREDS}') {
                        app.push("$BUILD_NUMBER")
#                        app.push("$SHORT_COMMIT")
                        app.push("latest")
                    }
                }
            }
        }
        stage('REMOVE LOCAL IMAGES') {
            steps {
                echo '=== Delete the local docker images ==='
                sh("docker rmi -f romanutskyi/petclinic-spinnaker-jenkins:latest || :")
                sh("docker rmi -f romanutskyi/petclinic-spinnaker-jenkins:$SHORT_COMMIT || :")
            }
        }
        
    }
}
