pipeline {
    agent any
    stages {
        stage('Build Application') { 
            steps {
                echo '=== Building Petclinic Application ==='
                sh 'mvn install -DskipTests' 
            }
        }
        stage('Test Application') {
            steps {
                echo '=== Testing Petclinic Application ==='
                sh 'mvn test'
            }
        }
        stage('Build Docker Image') {
            steps {
                echo '=== Building Petclinic Docker Image ==='
                script {
                    app = docker.build("romanutskyi/petclinic-spinnaker-jenkins")
                }
            }
        }
        stage('Push Docker Image') {
            steps {
                echo '=== Pushing Petclinic Docker Image ==='
                script {
                    GIT_COMMIT_HASH = sh (script: "git log -n 1 --pretty=format:'%H'", returnStdout: true)
                    SHORT_COMMIT = "${GIT_COMMIT_HASH[0..7]}"
                    docker.withRegistry('https://registry.hub.docker.com', '${DOCKER_CREDS}') {
                        app.push("$SHORT_COMMIT")
                        app.push("latest")
                    }
                }
            }
        }
        stage('Remove local images') {
            steps {
                echo '=== Delete the local docker images ==='
                sh("docker rmi -f romanutskyi/petclinic-spinnaker-jenkins:latest || :")
                sh("docker rmi -f romanutskyi/petclinic-spinnaker-jenkins:$SHORT_COMMIT || :")
            }
        }
    }
}
