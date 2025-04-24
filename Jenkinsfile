pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'mi-app:latest'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Install & Test') {
            steps {
                sh 'npm ci'
                sh 'npm test'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $DOCKER_IMAGE .'
            }
        }

        stage('Run Container') {
            steps {
                sh 'docker run -d -p 5000:5000 --name mi-app-test $DOCKER_IMAGE'
            }
        }
    }

    post {
        always {
            sh 'docker stop mi-app-test || true'
            sh 'docker rm mi-app-test || true'
        }
    }
}
