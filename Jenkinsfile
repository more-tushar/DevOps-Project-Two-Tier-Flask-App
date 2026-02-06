pipeline {
    agent any

    stages {

        stage('Clone repo') {
            steps {
                git branch: 'main',
                url: 'https://github.com/more-tushar/DevOps-Project-Two-Tier-Flask-App.git'
            }
        }

        stage('Stop & Remove Old Containers') {
            steps {
                sh '''
                docker compose down || true
                docker ps -aq | xargs -r docker rm -f
                '''
            }
        }

        stage('Remove Old Image') {
            steps {
                sh '''
                docker images flask-app -q | xargs -r docker rmi -f
                '''
            }
        }

        stage('Build New Image') {
            steps {
                sh 'docker build -t flask-app .'
            }
        }

        stage('Deploy New Container') {
            steps {
                sh 'docker compose up -d'
            }
        }
    }
}
