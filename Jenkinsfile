pipeline {
    agent any
    
    options {
        timestamps()
        ansiColor('xterm')
    }
    
    stages {
        stage('Jacoco test'){
            steps{
                sh './gradlew test JacocoTestReport'
                jacoco(
                    execPattern: 'build/jacoco/*.exec'
                )
            }
        }
        
        stage('Trivy scan'){
            steps{
                sh "trivy fs --security-checks vuln,secret,config -f json -o build/reports/trivy-report.json ."
                recordIssues(tools: [
			        trivy(pattern: 'build/reports/*.json')
		        ])
            }
        }
        
        stage('Gradle test') {
            steps {
                sh './gradlew check'
                recordIssues(tools: [
			        pmdParser(pattern: 'build/reports/pmd/*.xml')
		        ])
            }
        }
        
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
			            sh 'eb deploy'
                    }
	        }
            }
        }
    }
}
