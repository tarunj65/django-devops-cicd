pipeline {
	
	agent any
	
	environment {
	
		IMAGE_NAME = "tarunjuneja06/devops-repo"
		IMAGE_TAG = "latest"
		VERSION_TAG = "${BUILD_NUMBER}"
	
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
	
	}
}
