pipeline {

    agent any

    environment {
        IMAGE_NAME = 'tarunjuneja06/devops-repo'
        IMAGE_TAG = "${BUILD_NUMBER}"

        DOCKER_SERVER = '10.0.1.159'
        DEPLOY_DIR = '/home/ubuntu/django-deployment'

        DEBUG = 'False'
        APP_NAME = 'django-dashboard'
        APP_ENVIRONMENT = 'production'

        ALLOWED_HOSTS = '43.205.232.51'
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/tarunj65/django-devops-cicd.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                    docker build \
                        -t ${IMAGE_NAME}:${IMAGE_TAG} \
                        -t ${IMAGE_NAME}:latest \
                        .
                '''
            }
        }

        stage('Docker Hub Login') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'dockerhub-creds',
                        usernameVariable: 'DOCKER_USERNAME',
                        passwordVariable: 'DOCKER_PASSWORD'
                    )
                ]) {
                    sh '''
                        printf '%s' "$DOCKER_PASSWORD" | \
                        docker login \
                            -u "$DOCKER_USERNAME" \
                            --password-stdin
                    '''
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                sh '''
                    docker push ${IMAGE_NAME}:${IMAGE_TAG}
                    docker push ${IMAGE_NAME}:latest
                '''
            }
        }

        stage('Deploy') {
            steps {

                sshagent(credentials: ['docker-server-ssh']) {

                    withCredentials([
                        string(
                            credentialsId: 'django-secret-key',
                            variable: 'DJANGO_SECRET_KEY'
                        ),
                        usernamePassword(
                            credentialsId: 'dockerhub-creds',
                            usernameVariable: 'DOCKER_USERNAME',
                            passwordVariable: 'DOCKER_PASSWORD'
                        )
                    ]) {

                        sh '''
                            set -e
                            
                            ssh -o StrictHostKeyChecking=no \
                                ubuntu@${DOCKER_SERVER} \
                                "mkdir -p ${DEPLOY_DIR}"

                            ssh -o StrictHostKeyChecking=no \
                                ubuntu@${DOCKER_SERVER} \
                                "cd ${DEPLOY_DIR} && \
                                 if [ ! -d .git ]; then \
                                     git clone https://github.com/tarunj65/django-devops-cicd.git .; \
                                 else \
                                     git pull origin main; \
                                 fi"

                            ENV_FILE=$(mktemp)

                            trap 'rm -f "$ENV_FILE"' EXIT

                            chmod 600 "$ENV_FILE"

                            printf '%s\\n' \
                                "SECRET_KEY=${DJANGO_SECRET_KEY}" \
                                "DEBUG=${DEBUG}" \
                                "APP_NAME=${APP_NAME}" \
                                "APP_VERSION=${IMAGE_TAG}" \
                                "APP_ENVIRONMENT=${APP_ENVIRONMENT}" \
                                "BUILD_NUMBER=${BUILD_NUMBER}" \
                                "ALLOWED_HOSTS=${ALLOWED_HOSTS}" \
                                > "$ENV_FILE"

                            scp -o StrictHostKeyChecking=no \
                                "$ENV_FILE" \
                                ubuntu@${DOCKER_SERVER}:${DEPLOY_DIR}/.env

                          
                            ssh -o StrictHostKeyChecking=no \
                                ubuntu@${DOCKER_SERVER} \
                                "chmod 600 ${DEPLOY_DIR}/.env"

                            printf '%s' "$DOCKER_PASSWORD" | \
                            ssh -o StrictHostKeyChecking=no \
                                ubuntu@${DOCKER_SERVER} \
                                "docker login \
                                    -u '${DOCKER_USERNAME}' \
                                    --password-stdin"

                            ssh -o StrictHostKeyChecking=no \
                                ubuntu@${DOCKER_SERVER} \
                                "cd ${DEPLOY_DIR} && \
                                 docker compose pull && \
                                 docker compose up -d"
                        '''
                    }
                }
            }
        }
    }
}
