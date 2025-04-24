pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'mi-app:latest'
        WORKSPACE = "${env.WORKSPACE}"
    }

    stages {
        stage('Checkout') {
            steps {
                dir(WORKSPACE){
                    checkout scm
                }                
            }
        }

        stage('Install & Test') {
            steps {
                dir(WORKSPACE){
                    sh 'npm ci'
                    sh 'npm test'
                }                
            }
        }

        stage('Build Docker Image') {
            steps {
                dir(WORKSPACE){
                    sh 'docker build -t $DOCKER_IMAGE .'
                }
            }
        }

        stage('Run Container') {
            steps {
                dir(WORKSPACE){
                    sh 'docker run -d -p 5000:5000 --name mi-app-test $DOCKER_IMAGE'
                }
            }
        }
    }

    post {
        always {
            dir(WORKSPACE){
                sh 'docker stop mi-app-test || true'
                sh 'docker rm mi-app-test || true'
            }
        }
    }
}
