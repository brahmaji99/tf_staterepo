pipeline {
  agent any

  parameters {
    choice(
      name: 'ENV',
      choices: ['dev', 'qa', 'prod'],
      description: 'Terraform workspace/environment'
    )
    booleanParam(
      name: 'BOOTSTRAP',
      defaultValue: false,
      description: 'Run backend bootstrap (S3 + DynamoDB + IAM) – run only once'
    )
  }

  environment {
    AWS_REGION = "eu-north-1"
  }

  stages {

    stage('Checkout') {
        steps {
                git branch: 'main',
                    //credentialsId: 'jenkins-ssh',
                    url: 'git@github.com:brahmaji99/tf_staterepo.git'
            }
    }

    stage('Terraform Bootstrap (Backend Infra)') {
      when {
        expression { params.BOOTSTRAP == true }
      }
      steps {
        dir('tf_staterepo')
          sh '''
            terraform init
            terraform plan
            terraform apply -auto-approve
          '''
        }
    }
    

    stage('Terraform Init (Infra)') {
      steps {
        dir('tf_staterepo') {
          sh '''
            terraform init
          '''
        }
      }
    }

    stage('Select or Create Workspace') {
      steps {
        dir('tf_staterepo') {
          sh '''
            terraform workspace list | grep ${ENV} \
              || terraform workspace new ${ENV}

            terraform workspace select ${ENV}
          '''
        }
      }
    }

    stage('Terraform Plan') {
      steps {
        dir('tf_staterepo') {
          sh '''
            terraform plan
          '''
        }
      }
    }

    stage('Terraform Apply') {
      steps {
        dir('tf_staterepo') {
          sh '''
            terraform apply -auto-approve
          '''
        }
      }
    }
  }

  post {
    success {
      echo "✅ Terraform deployment successful for ${ENV}"
    }
    failure {
      echo "❌ Terraform deployment failed"
    }
  }
}
