pipeline {
    agent any

    stages {
        stage('Provision server') {
            environment {
                AWS_ACCESS_KEY_ID = credentials('jenkins_aws_access_key_id')
                AWS_SECRET_ACCESS_KEY = credentials('jenkins_aws_secret_access_key')
                TF_VAR_env_prefix = 'test'
            }
            steps {
                script {
                    dir('terraform') {
                        sh "terraform init"
                        sh "terraform apply --auto-approve"
                    }
                }

           }
        }
        stage('Build server ansible') {
            steps {
                sh 'echo "This is test build"'

           }
        }
    
        stage('Prod server ansible') {
            steps {
                sh 'echo "This is test deploy"'

           }
        }
    }
}