pipeline {
    agent any

    stages {

        stage('Clone repo') {
            steps {
                git branch: 'main',
                url: 'https://github.com/more-tushar/DevOps-Project-Two-Tier-Flask-App.git'
            }
        }

        stage('Stop Containers') {
            steps {
                sh 'docker compose down || true'
            }
        }

        stage('Remove Old Image') {
            steps {
                sh 'docker rmi -f flask-app:latest || true'
            }
        }

        stage('Build New Image') {
            steps {
                sh 'docker build -t flask-app:latest .'
            }
        }

        stage('Deploy New Containers') {
            steps {
                sh 'docker compose up -d'
            }
        }
    }
}
