pipeline {
    agent any // Use any available Jenkins agent (or specify a label if needed)

    environment {
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        TF_IN_AUTOMATION      = '1'
    }

    stages {
        stage('Checkout') {
            steps {
                // Clone the GitHub repository
                checkout scm
            }
        }

        stage('Debug') {
            steps {
                dir('tf-aws') {
                    sh 'ls -la' // List files in the repository to confirm the presence of Terraform files
                }
            }
        }

        stage('Terraform Init') {
            steps {
                dir('tf-aws') { // Path where Terraform files are located
                    sh 'terraform init -reconfigure'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                dir('tf-aws') { // Path where Terraform files are located
                    sh 'terraform plan -out=tfplan' // Save the plan to a file
                }
            }
        }

        stage('Approval') {
            when {
                not { equals expected: true, actual: params.autoApprove }
            }
            steps {
                script {
                    def plan = readFile 'tf-aws/tfplan'
                    input message: "Do you want to apply the plan?",
                        parameters: [text(name: 'Plan', description: 'Please review the plan', defaultValue: plan)]
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                dir('tf-aws') { // Path where Terraform files are located
                    sh 'terraform apply -input=false tfplan'
                }
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