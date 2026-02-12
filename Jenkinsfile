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

        stage('Build Image') {
            steps {
                sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
            }
        }

        stage('Deploy New Version') {
            steps {
                script {
                    try {
                        sh "docker stop flask-container || true"
                        sh "docker rm flask-container || true"

                        sh """
                        docker run -d --name flask-container \
                        -p ${APP_PORT}:5000 \
                        ${IMAGE_NAME}:${IMAGE_TAG}
                        """

                        sleep 20

                        sh "curl -f http://localhost:${APP_PORT}/health"

                        echo "New version is healthy ✅"

                    } catch (err) {

                        echo "New version failed ❌ Rolling back..."

                        sh "docker stop flask-container || true"
                        sh "docker rm flask-container || true"

                        def previousImage = sh(
                            script: "docker images ${IMAGE_NAME} --format '{{.Tag}}' | sort -nr | sed -n '2p'",
                            returnStdout: true
                        ).trim()

                        sh """
                        docker run -d --name flask-container \
                        -p ${APP_PORT}:5000 \
                        ${IMAGE_NAME}:${previousImage}
                        """

                        error("Deployment Failed. Rolled back to ${previousImage}")
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
