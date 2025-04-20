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

        stage('check s3 bucket') {
            steps {
                script {
                    echo "Checking if the S3 bucket exists in the region ${env.AWS_REGION}."
                    withCredentials([aws(accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'AWS_CREDENTIALS', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                        sh "aws s3 ls --region ${env.AWS_REGION}"
                    }
                }             
            }
        }

        // stage('Initialize variables') {
        //     steps {
        //         script {
        //             repoName = env.GIT_URL?.tokenize('/').last()?.replace('.git', '')
        //             branchName = env.GIT_BRANCH?.replaceFirst(/^origin\//, '')
        //         }
        //     }
        // }

        // stage('Checkout Repositories') {
        //     when {
        //         anyOf {
        //             branch 'PR-*'
        //             expression {
        //                 return branchName == 'staging'
        //             }
        //         }
        //     }
        //     steps {
        //         script {
        //             echo "Checking out the source code from the repository: ${repoName} - branch: ${branchName}"
        //             dir('Iac_Terraform') {
        //                 checkout scm
        //             }  
        //         }
        //     }
        // }

        // stage('Initialize Terraform') {
        //     when {
        //         anyOf {
        //             branch 'PR-*'
        //             expression {
        //                 return branchName == 'staging'
        //             }
        //         }
        //     }
        //     steps {
        //         script {
        //             dir('Iac_Terraform/DB') {
        //                 echo "Initializing Terraform for ${repoName}/DB repository."
        //                 withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-credentials', usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY']]) {
        //                     sh 'terraform init --backend-config=../backend.hcl'
        //                 }                      
        //             }
        //             dir('Iac_Terraform/EC2') {
        //                 echo "Initializing Terraform for ${repoName}/EC2 repository."
        //                 withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-credentials', usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY']]) {
        //                     sh 'terraform init --backend-config=../backend.hcl'
        //                 }                      
        //             }
        //             dir('Iac_Terraform/VPC') {
        //                 echo "Initializing Terraform for ${repoName}/VPC repository."
        //                 withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-credentials', usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY']]) {
        //                     sh 'terraform init --backend-config=../backend.hcl'
        //                 }
        //             }
        //         }
        //     }
        // }

        // stage('Terraform Plan') {
        //     when {
        //         branch 'PR-*'
        //     }
        //     steps {
        //         script {
        //             // Generate a Terraform plan
        //             dir('Iac_Terraform/DB') {
        //                 echo "Generating Terraform plan for ${repoName}/DB repository."
        //                 withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-credentials', usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY']]) {
        //                     sh 'terraform plan -out=tfplan'
        //                 }
        //             }
        //             dir('Iac_Terraform/EC2') {
        //                 echo "Generating Terraform plan for ${repoName}/EC2 repository."
        //                 withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-credentials', usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY']]) {
        //                     sh 'terraform plan -out=tfplan'
        //                 }
        //             }
        //             dir('Iac_Terraform/VPC') {
        //                 echo "Generating Terraform plan for ${repoName}/VPC repository."
        //                 withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-credentials', usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY']]) {
        //                     sh 'terraform plan -out=tfplan'
        //                 }
        //             }
        //             // Archive the Terraform plan for later use
        //             archiveArtifacts artifacts: 'Iac_Terraform/*/tfplan', fingerprint: true
        //         }
        //     }
        // }

        // stage('Terraform Apply') {
        //     when {
        //         expression {
        //             return branchName == 'staging'
        //         }
        //     }
        //     steps {
        //         script {
        //             // Apply the Terraform plan
        //             dir('Iac_Terraform/DB') {
        //                 echo "Applying Terraform plan for ${repoName}/DB repository."
        //                 withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-credentials', usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY']]) {
        //                     sh 'terraform apply -auto-approve'
        //                 }
        //             }
        //             dir('Iac_Terraform/EC2') {
        //                 echo "Applying Terraform plan for ${repoName}/EC2 repository."
        //                 withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-credentials', usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY']]) {
        //                     sh 'terraform apply -auto-approve'
        //                 }
        //             }
        //             dir('Iac_Terraform/VPC') {
        //                 echo "Applying Terraform plan for ${repoName}/VPC repository."
        //                 withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-credentials', usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY']]) {
        //                     sh 'terraform apply -auto-approve'
        //                 }
        //             }
        //         }
        //     }
        // }
    }

    post {
        always {
            script {
                echo "Cleaning up workspace for ${repoName} repository."
                cleanWs()
            }
        }

        success {
            script {
                echo "Terraform apply completed successfully for ${repoName} repository."
            }
        }

        failure {
            script {
                echo "Terraform apply failed for ${repoName} repository."
            }
        }

        unstable {
            script {
                echo "Terraform apply was unstable for ${repoName} repository."
            }
        }
    }
}