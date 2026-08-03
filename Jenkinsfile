pipeline {
	
	agent any
	
	environment {
	
		IMAGE_NAME = "tarunjuneja06/devops-repo"
		IMAGE_TAG = "latest"
	
	}

	stages {
	
		stage('Checkout source') {

			steps {
				checkout scm
			}
		
		}
		
		stage('Verify workspace') {
			
			steps {
			
				sh '''
				   pwd
				   ls -la
				'''

			}

		}
		stage('Build docker image') {
		
			steps {

				sh '''
				   docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .
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
				   docker push ${IMAGE_NAME}:${IMAGE_TAG} .
				'''
			}
		}
	
	}
}
