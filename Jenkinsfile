pipeline {
    agent any

    stages {

        stage('Clean Workspace') {
            steps {
                cleanWs()
            }
        }

        stage('Clone Repo') {
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

        stage('Build & Deploy') {
            steps {
                sh 'docker compose up -d --build --force-recreate'
            }
        }
    }
}
