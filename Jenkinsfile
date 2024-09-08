pipeline {
    agent any // Use any available Jenkins agent (or specify a label if needed)

    environment {
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/org-navinku/tf-aws.git'
            }
        }
        stage('Terraform init') {
            steps {
                sh 'terraform init'
            }
        }
        stage('Terraform apply') {
            steps {
                sh 'terraform apply --auto-approve'
            }
        }
    }

    post {
        always {
            archiveArtifacts artifacts: 'tf-aws/tfplan' // Path to plan file
            cleanWs() // Clean workspace after execution
        }
    }
}