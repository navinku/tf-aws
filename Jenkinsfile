pipeline {
    agent any

    environment {
        // Define environment variables, for example, Terraform state name
        TF_STATE_NAME = 'your-terraform-state'
    }

    stages {
        stage('fmt') {
            steps {
                // Format Terraform code
                sh 'terraform fmt -check'
            }
        }

        stage('validate') {
            steps {
                // Validate the Terraform configuration
                sh 'terraform validate'
            }
        }

        stage('build') {
            steps {
                // Initialize Terraform and prepare infrastructure
                sh 'terraform init'
                sh 'terraform plan -out=tfplan'
            }
            environment {
                // Example: Terraform backend configuration based on environment
                TF_WORKSPACE = "${env.TF_STATE_NAME}"
            }
        }

        stage('deploy') {
            steps {
                // Apply the Terraform plan to deploy the infrastructure
                sh 'terraform apply tfplan'
            }
            environment {
                // Example: Use a specific Terraform workspace
                TF_WORKSPACE = "${env.TF_STATE_NAME}"
            }
        }

        stage('cleanup') {
            when {
                // Run this stage only when triggered manually
                expression { return env.BRANCH_NAME == 'main' }
            }
            steps {
                // Destroy the Terraform-managed infrastructure
                input message: "Do you want to destroy the infrastructure?", ok: "Yes"
                sh 'terraform destroy -auto-approve'
            }
        }
    }

    post {
        always {
            // Clean up workspace after pipeline execution
            cleanWs()
        }

        success {
            echo 'Pipeline completed successfully!'
        }

        failure {
            echo 'Pipeline failed!'
        }
    }
}