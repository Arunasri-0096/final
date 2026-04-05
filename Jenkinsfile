pipeline {
    agent any

    tools {
        maven 'maven3'   // Make sure this matches your Jenkins Maven tool name
        jdk 'jdk17'      // Make sure this matches your Jenkins JDK tool name
    }

    environment {
        IMAGE = "arunasri0096/color:latest"
    }

    stages {

        stage('Clone') {
            steps {
                // Clone your Git repository
                git branch: 'main', url: 'https://github.com/Arunasri-0096/final.git'
            }
        }

        stage('Build') {
            steps {
                // Run Maven build in the workspace directory (where POM exists)
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('sonar-server') {  // Make sure the SonarQube server name matches your Jenkins config
                    sh '''
                        mvn sonar:sonar \
                        -Dsonar.projectKey=color \
                        -Dsonar.projectName=color \
                        -Dsonar.host.url=http://43.204.38.47:9000
                    '''
                }
            }
        }

        stage('Nexus Upload') {
            steps {
                // Inject credentials and run Maven deploy
                withCredentials([usernamePassword(
                    credentialsId: 'nexus-creds', 
                    usernameVariable: 'NEXUS_USER', 
                    passwordVariable: 'NEXUS_PASS'
                )]) {
                    sh '''
                        mvn deploy --settings /var/lib/jenkins/.m2/settings.xml -DskipTests
                    '''
                }
            }
        }

        stage('Docker Pull') {
            steps {
                // Pull Docker image from Docker Hub
                sh "docker pull ${IMAGE}"
            }
        }

        stage('K8s Deploy') {
            steps {
                // Apply Kubernetes manifests
                sh 'kubectl apply -f deployment.yaml'
                sh 'kubectl apply -f service.yaml'
            }
        }
    }

    post {
        success {
            echo "Pipeline completed successfully ✅"
        }
        failure {
            echo "Pipeline failed ❌"
        }
    }
}
