pipeline {
    agent any
       triggers {
        pollSCM "* * * * *"
       }
    stages {
        stage('BUILD') { 
            steps {
                echo '=== Building Petclinic Application ==='
                sh 'mvn -B -DskipTests clean package' 
            }
        }
        stage('TEST') {
            steps {
                echo '=== Testing Petclinic Application ==='
                sh 'mvn test'
            }
            post {
                always {
                    junit 'target/surefire-reports/*.xml'
                }
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
