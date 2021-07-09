pipeline {
    agent any

    tools {
        maven "Maven"
    }

    stages {
        stage('Build') {
            steps {
                sh 'echo "This is test build"'

           }
        }
        stage('push') {
            steps {
                sh 'echo "This is test push"'

           }
        }
    
        stage('deploy') {
            steps {
                sh 'echo "This is test deploy"'

           }
        }
    }
}