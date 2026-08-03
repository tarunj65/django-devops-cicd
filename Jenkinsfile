pipeline {
	
	agent any

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
				   docker build -t tarunjuneja06/devops-repo:latest .
				'''			

			}
		
		}
	
	}
}
