pipeline {
    agent any

    environment {
        IMAGE_NAME = "flask-app"
        IMAGE_TAG = "${BUILD_NUMBER}"
        APP_PORT = "5000"
    }

    options {
        timestamps()
    }

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

        stage('Deploy Application') {
            steps {
                script {
                    try {

                        // Stop old containers
                        sh "docker compose down --remove-orphans || true"

                        // Build & start new containers
                        sh "docker compose up -d --build"

                        // Wait for containers to be ready
                        sleep 40

                        // Health check
                        sh "curl -f http://localhost:${APP_PORT}/health"

                        echo "New version is healthy ✅"

                    } catch (err) {

                        echo "Deployment Failed ❌"
                        sh "docker compose logs"

                        error("Deployment Failed")
                    }
                }
            }
        }

        stage('Cleanup Old Images (Keep Last 3)') {
            steps {
                sh """
                docker images ${IMAGE_NAME} --format '{{.Tag}}' | \
                sort -nr | tail -n +4 | \
                xargs -I {} docker rmi ${IMAGE_NAME}:{}
                """
            }
        }
    }

    post {
        success {
            echo "Deployment Successful 🚀"
        }
        failure {
            echo "Deployment Failed ❌"
        }
        always {
            echo "Pipeline Finished"
        }
    }
}
