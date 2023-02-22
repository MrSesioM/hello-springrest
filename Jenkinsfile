pipeline {
    agent any

    stages {

        stage('Docker-login and tags') {
            steps {
                withCredentials([string(credentialsId: 'docker-login', variable: 'CR_PAT')]) {
                    sh 'echo $CR_PAT | docker login ghcr.io -u mrsesiom --password-stdin'
                }
                    sh 'git tag 1.0.${BUILD_NUMBER}'
                    sshagent(['git-login']) {
                        sh 'git push git@github.com:MrSesioM/hello-springrest.git --tags'
                    }
                }
        }
        
        stage('Building image and Pushing it') {
            steps {
                sh 'VERSION=1.0.${BUILD_NUMBER} docker-compose build'
		sh 'docker-compose build'
	        sh 'VERSION=1.0.${BUILD_NUMBER} docker-compose push'
		sh 'docker-compose push'
            }
        }
	stage('Deploy application') {
            steps {
                withAWS(credentials: 'AWS Credentials') {
                    dir("eb-springrest") {
			sh 'eb create jenkins-lucatic'
                    }
		}
            }
        }
    }
}
