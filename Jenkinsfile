pipeline {
    agent {
        docker {
            image 'hashicorp/terraform:1.5.6' // Use the Terraform Docker image
            args '-u root'  // Use root to install additional dependencies if needed
        }
    }
    environment {
        TF_VAR_aws_access_key = credentials('AWS_ACCESS_KEY_ID')
        TF_VAR_aws_secret_key = credentials('AWS_SECRET_ACCESS_KEY')
    }
    stages {
        stage('Terraform Fmt') {
            steps {
                sh 'terraform fmt -check'
            }
        }
        stage('Terraform Validate') {
            steps {
                sh 'terraform validate'
            }
        }
        stage('Terraform Init') {
            steps {
                sh 'terraform init'
            }
        }
        stage('Terraform Plan') {
            steps {
                sh 'terraform plan -out=plan.out'
            }
        }
        stage('Terraform Apply') {
            when {
                branch 'main'
            }
            steps {
                sh 'terraform apply -auto-approve plan.out'
            }
        }
        stage('Cleanup') {
            when {
                expression { params.CLEANUP == true }
            }
            steps {
                sh 'terraform destroy -auto-approve'
            }
        }
    }
    post {
        always {
            cleanWs() // Clean workspace after build
        }
    }
}