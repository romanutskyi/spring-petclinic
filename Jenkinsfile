pipeline {
    agent any
    stages {
        stage('Build Application') { 
            steps {
                echo '=== Building Petclinic Application ==='
                  sh 'mvn clean package'

            }
        }
        stage('TEST') {
            steps {
                echo '=== Testing Petclinic Application ==='
                sh 'mvn test'
            }
        }
        stage('CREATE ARTIFACT') {
            when {
                branch 'main'
            }
            steps {
                echo '=== Building Petclinic Docker Image ==='
                script {
                    app = docker.build("romanutskyi/petclinic-from-jenkins")
                }
            }
        }
        stage('PUSH') {
            steps {
                script {
                    docker.withRegistry('https://registry.hub.docker.com', '${DOCKER_CREDS}') {
                        app.push("${COMMIT_ID}")
        sh 'docker rm $(docker ps -a -q)'
        sh 'docker rmi $(docker images -q) -f'
                    }
                }
            }
        }
    }
}
