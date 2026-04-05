pipeline {
    agent any

    tools {
        maven 'maven3'
        jdk 'jdk17'
    }

    environment {
        IMAGE = "yourname/custom-image:latest"
    }

    stages {

        stage('Clone') {
            steps {
                git 'https://github.com/your-repo/devops-java-project.git'
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
                    sh 'mvn sonar:sonar'
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
                sh 'docker pull $IMAGE'
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
