pipeline {
    agent {"Sudha"}

    environment {
        TF_DIR = 'terraform'                     // Folder where .tf files are placed
        DOCKER_IMAGE = "dock2o/three-tier-app"
        DOCKER_CREDENTIALS_ID = 'dockerhub-credentials'
        SSH_KEY = credentials('terraform-ec2-key') // Jenkins Credential ID for private key
        EC2_USER = 'ubuntu'
        EC2_IP = 'your.ec2.public.ip'             // Optionally fetch dynamically using Terraform outputs
    }

    stages {
        stage('Clone Repository') {
            steps {
                git 'https://github.com/Dheeraj-kumar001/three-tier-app.git'
            }
        }

        stage('Terraform Init & Apply') {
            dir("${TF_DIR}") {
                steps {
                    sh '''
                    terraform init
                    terraform apply -auto-approve
                    '''
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    dockerImage = docker.build("${DOCKER_IMAGE}:${BUILD_NUMBER}")
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                script {
                    docker.withRegistry('', DOCKER_CREDENTIALS_ID) {
                        dockerImage.push()
                    }
                }
            }
        }

        stage('Deploy to EC2') {
            steps {
                sh """
                ssh -o StrictHostKeyChecking=no -i ${SSH_KEY} ${EC2_USER}@${EC2_IP} '
                    docker pull ${DOCKER_IMAGE}:${BUILD_NUMBER}
                    docker stop app || true && docker rm app || true
                    docker run -d --name app -p 80:80 ${DOCKER_IMAGE}:${BUILD_NUMBER}
                '
                """
            }
        }
    }

    post {
        success {
            echo '✅ Infrastructure + App Deployed Successfully!'
        }
        
    }
}
