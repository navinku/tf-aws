pipeline {
    agent any

    parameters {
        string(name: 'environment', defaultValue: 'default', description: 'Workspace/environment file to use for deployment')
        string(name: 'version', defaultValue: '', description: 'Version variable to pass to Terraform')
        booleanParam(name: 'autoApprove', defaultValue: false, description: 'Automatically run apply after generating plan?')
    }
    
    environment {
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        TF_IN_AUTOMATION      = '1'
    }

    stages {
        stage('Terraform Init') {
            steps {
                script {
                    currentBuild.displayName = params.version ?: 'No Version Specified'
                }
                sh 'terraform init -input=false'
            }
        }

        stage('Select Workspace') {
            steps {
                script {
                    sh 'terraform workspace select ${environment} || terraform workspace new ${environment}'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                sh """
                terraform plan -input=false \
                    -out=tfplan \
                    -var 'version=${params.version}' \
                    --var-file=environments/${params.environment}.tfvars
                """
                sh 'terraform show -no-color tfplan > tfplan.txt'
            }
        }

        stage('Approval') {
            when {
                not { equals expected: true, actual: params.autoApprove }
            }
            steps {
                script {
                    def plan = readFile 'tfplan.txt'
                    input message: "Do you want to apply the plan?",
                        parameters: [text(name: 'Plan', description: 'Please review the plan', defaultValue: plan)]
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                sh 'terraform apply -input=false tfplan'
            }
        }
    }

    post {
        always {
            archiveArtifacts artifacts: 'tfplan.txt'
            cleanWs() // Clean workspace after execution
        }
    }
}