def repoName = ''
def branchName = ''

pipeline {
    agent any
    
    environment {        
        TERRAFORM_VERSION= tool 'terraform'
    }

    options {
        timestamps()
        disableConcurrentBuilds()
    }
    
    stages {

        stage('Initialize variables') {
            steps {
                script {
                    repoName = env.GIT_URL?.tokenize('/').last()?.replace('.git', '')
                    branchName = env.GIT_BRANCH?.replaceFirst(/^origin\//, '')
                }
            }
        }

        stage('Checkout Repositories') {
            when {
                anyOf {
                    branch 'PR-*'
                    expression {
                        return branchName == 'staging'
                    }
                }
            }
            steps {
                script {
                    echo "Checking out the source code from the repository: ${repoName} - branch: ${branchName}"
                    dir('Iac_Terraform') {
                        checkout scm
                    }  
                }
            }
        }

        stage('Initialize Terraform') {
            when {
                anyOf {
                    branch 'PR-*'
                    expression {
                        return branchName == 'staging'
                    }
                }
            }

            steps {
                script {
                    def terraformDirs = ['DB', 'EC2', 'VPC']
                    def parallelSteps = terraformDirs.collectEntries { dirName ->
                        ["Initialize ${dirName}": {
                            dir("Iac_Terraform/${dirName}") {
                                echo "Initializing Terraform for ${repoName}/${dirName} repository."
                                withCredentials([aws(accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'AWS_CREDENTIALS', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                                    sh 'terraform init --backend-config=../backend.hcl'
                                }
                            }
                        }]
                    }
                    parallel parallelSteps
                }
            }
        }

        stage('Terraform Validate') {
            when {
                branch 'PR-*'
            }

            steps {
                script {
                    def terraformDirs = ['DB', 'VPC']
                    def parallelSteps = terraformDirs.collectEntries { dirName ->
                        ["Validate ${dirName}": {
                            dir("Iac_Terraform/${dirName}") {
                                echo "Validating Terraform for ${repoName}/${dirName} repository."
                                withCredentials([aws(accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'AWS_CREDENTIALS', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'),
                                                file(credentialsId: "terraform${dirName.toLowerCase()}.tfvars", variable: 'AWS_TF_VARS')]) {
                                    sh "cp ${AWS_TF_VARS} terraform.tfvars"
                                    sh "terraform validate -var-file=terraform.tfvars"
                                }
                            }
                        }]
                    }
                    parallel parallelSteps
                }
            }
        }

        stage('Terraform Plan') {
            when {
                branch 'PR-*'
            }

            steps {
                script {
                    def terraformDirs = ['DB', 'VPC']
                    def parallelSteps = terraformDirs.collectEntries { dirName ->
                        ["Plan ${dirName}": {
                            dir("Iac_Terraform/${dirName}") {
                                echo "Creating Terraform plan for ${repoName}/${dirName} repository."
                                withCredentials([aws(accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'AWS_CREDENTIALS', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'),
                                                file(credentialsId: "terraform${dirName.toLowerCase()}.tfvars", variable: 'AWS_TF_VARS')]) {
                                    sh "cp ${AWS_TF_VARS} terraform.tfvars"
                                    sh 'terraform plan -var-file=terraform.tfvars -out=tfplan'
                                }
                            }
                        }]
                    }
                    parallel parallelSteps

                    echo "Terraform plan created for ${repoName} repository."
                    echo "Storing Terraform plan in the workspace."
                    // Archive the Terraform plan for later use
                    archiveArtifacts artifacts: 'Iac_Terraform/*/tfplan', fingerprint: true
                }
            }
        }

        stage('Terraform Plan Approval') {
            when {
                expression {
                    return branchName == 'staging'
                }
            }
            steps {
                input message: 'Approve Terraform Plan?'
            }
        }

        stage('Terraform Apply') {
            when {
                expression {
                    return branchName == 'staging'
                }
            }
            steps {
                script {
                    def terraformDirs = ['DB', 'VPC']
                    def parallelSteps = terraformDirs.collectEntries { dirName ->
                        ["Apply ${dirName}": {
                            dir("Iac_Terraform/${dirName}") {
                                echo "Applying Terraform for ${repoName}/${dirName} repository."
                                withCredentials([aws(accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'AWS_CREDENTIALS', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'),
                                                file(credentialsId: "terraform${dirName.toLowerCase()}.tfvars", variable: 'AWS_TF_VARS')]) {
                                    sh "cp ${AWS_TF_VARS} terraform.tfvars"
                                    sh 'terraform apply -var-file=terraform.tfvars -auto-approve'
                                }
                            }
                        }]
                    }
                    parallel parallelSteps

                    echo "Terraform apply completed for ${repoName} repository."
                }
            }
        }
    }

    post {

        success {
            script {
                echo "Terraform apply completed successfully for ${repoName} repository."
                cleanWs()
            }
        }

        failure {
            script {
                echo "Terraform apply failed for ${repoName} repository."
                cleanWs()
            }
        }

        aborted {
            script {
                echo "Terraform apply was aborted for ${repoName} repository."
                cleanWs()
            }
        }
    }
}