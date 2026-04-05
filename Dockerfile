stage('Pull Docker Image') {
    steps {
        sh 'docker pull arunasri@0096/color:latest'
    }
}
