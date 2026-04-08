pipeline {
    agent any

    tools {
        maven 'maven3'   // Must match your Jenkins Maven tool name
        jdk 'jdk17'      // Must match your Jenkins JDK tool name
    }

    environment {
        IMAGE = "arunasri0096/color:latest"
    }

    stages {

        stage('Clone') {
            steps {
                // Clone your repository
                git branch: 'main', url: 'https://github.com/Arunasri-0096/final.git'
            }
        }

        stage('Build') {
            steps {
                // Build the project using Maven
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('sonar-server') { // Make sure this matches your Jenkins SonarQube config
                    sh '''
                        mvn sonar:sonar \
                        -Dsonar.projectKey=color \
                        -Dsonar.projectName=color \
                        -Dsonar.host.url=http://65.2.175.14:9000
                    '''
                }
            }
        }

        stage('Nexus Upload') {
            steps {
                // Inject Jenkins credentials and write a temporary settings.xml for Maven
                withCredentials([usernamePassword(
                    credentialsId: 'nexus-creds',
                    usernameVariable: 'USER',
                    passwordVariable: 'PASS'
                )]) {
                    writeFile file: 'settings-temp.xml', text: """
<settings>
  <servers>
    <server>
      <id>nexus-releases</id>
      <username>${USER}</username>
      <password>${PASS}</password>
    </server>
    <server>
      <id>nexus-snapshots</id>
      <username>${USER}</username>
      <password>${PASS}</password>
    </server>
  </servers>
</settings>
"""
                    sh 'mvn deploy --settings settings-temp.xml -DskipTests'
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
                // Deploy to Kubernetes cluster
                sh 'kubectl apply -f deployment.yaml'
                sh 'kubectl apply -f service.yml'
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
