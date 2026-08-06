pipeline {
	
	agent any
	
	environment {
	
		IMAGE_NAME = "tarunjuneja06/devops-repo"
		IMAGE_TAG = "latest"
		VERSION_TAG = "${BUILD_NUMBER}"
		
		DOCKER_SERVER = "15.0.2.4"
	
	}

	stages {
	
		stage('Checkout source') {

			steps {
				checkout scm
			}
		
		}
		
		stage('Build docker image') {
		
			steps {

				sh '''
				   docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .
				'''			

			}
		
		}
		stage('Tag Docker Image') {
		
			steps {
				sh '''
				   docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${IMAGE_NAME}:${VERSION_TAG}
				'''
		}
		}
		stage('Login to Docker Hub') {
		
			steps {
				withCredentials([usernamePassword(
					credentialsId: 'docke-hub-creds',
					usernameVariable: 'DOCKER_USERNAME',
					passwordVariable: 'DOCKER_PASSWORD')])
				{
				sh '''
				   echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
				'''
				}
			}
		}
		stage('Push Docker Image') {
			
			steps {
				sh '''
				   docker push ${IMAGE_NAME}:${IMAGE_TAG}
				   docker push ${IMAGE_NAME}:${VERSION_TAG}
				'''
			}
		}
		stage('Copy Deployment Files') {
		
			steps {
			
				sshagent(credentials: ['docker-server-ssh']) {

					sh '''
						ssh -o StrictHostKeyChecking=no ubuntu@$DOCKER_SERVER "mkdir -p ~/django-deployment/deployment"
						
						scp -o StrictHostKeyChecking=no docker-compose.yml \
						ubuntu@$DOCKER_SERVER:~/django-deployment/

						scp -o StrictHostKeyChecking=no deployment/nginx.conf \
						ubuntu@$DOCKER_SERVER:~/django-deployment/deployment
					'''

				}

			}

		}
		stage('Deploy Application') {

			steps {
				withCredentials([usernamePassword(
				       credentialsId: 'docke-hub-creds',
                                        usernameVariable: 'DOCKER_USERNAME',
                                        passwordVariable: 'DOCKER_PASSWORD')])
                                {


				sshagent(credentials: ['docker-server-ssh']) {

					sh '''
						ssh -o StrictHostKeyChecking=no ubuntu@$DOCKER_SERVER '
						echo "${DOCKER_PASSWORD}" | docker login \
						-u "${DOCKER_USERNAME}" \
						--password-stdin
						
						cd ~/django-deployment
						docker compose pull
						docker compose up -d
						docker image prune -f
						docker logout
						'
					'''

				}

			}

		}
	
	}
}
