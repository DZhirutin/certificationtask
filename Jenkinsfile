pipeline {
    agent any
    environment {
        ANSIBLE_SERVER = "35.232.84.72"
    }
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
        stage('copy files to ansible server') {
            steps {
                script {
                    echo "copying  all neccessary files to ansible control node"
                    sshagent(['ansible-server-key']) {
                        sh "scp -o StrictHostKeyChecking=no ansible/* root@${ANSIBLE_SERVER}:/root"

                        withCredentials([sshUserPrivateKey(credentialsId: 'server-ssh-key', keyFileVariable: 'keyfile', usernameVariable: 'user')]) {
                            sh 'scp $keyfile root@$ANSIBLE_SERVER:/root/myapp-key-pair.pem'

                }
            }
        }
    
        stage('Prod server ansible') {
            steps {
                sh 'echo "This is test deploy"'

           }
        }
    }
}