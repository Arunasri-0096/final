pipeline {
    agent any

    tools {
        maven 'maven3'
        jdk 'jdk17'
    }

    environment {
        IMAGE = "arunasri@0096/color:latest"
    }

    stages {

        stage('Clone') {
            steps {
                git branch: 'main', url: 'https://github.com/Arunasri-0096/final.git'
            }
        }

        stage('Build') {
            steps {
                sh 'mvn clean package'
            }
        }
      stage('SonarQube') {
    steps {
        withSonarQubeEnv('sonar-server') {
            sh '''
            mvn sonar:sonar \
            -Dsonar.projectKey=color \
            -Dsonar.projectName=color \
            -Dsonar.host.url=http://13.234.114.219:8081 \
            '''
        }
    }
}

        stage('Nexus Upload') {
            steps {
                sh 'mvn deploy'
            }
        }

        stage('Docker Pull') {
            steps {
                sh 'docker pull $color'
            }
        }

        stage('K8s Deploy') {
            steps {
                sh 'kubectl apply -f deployment.yaml'
                sh 'kubectl apply -f service.yaml'
            }
        }
    }
}
