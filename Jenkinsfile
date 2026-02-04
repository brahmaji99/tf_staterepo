pipeline {
  agent any

  options {
    skipDefaultCheckout(true)
  }

  parameters {
    choice(
      name: 'ENV',
      choices: ['dev', 'qa', 'prod'],
      description: 'Terraform workspace'
    )
  }

  environment {
    AWS_REGION = "eu-north-1"
  }

  stages {

    stage('Checkout') {
      steps {
        checkout([
          $class: 'GitSCM',
          branches: [[name: '*/main']],
          userRemoteConfigs: [[
            url: 'git@github.com:brahmaji99/tf_staterepo.git',
            credentialsId: 'jenkins-ssh'
          ]]
        ])
      }
    }

    stage('Terraform Init') {
      steps {
        sh '''
          terraform version
          terraform init
        '''
      }
    }

    stage('Select or Create Workspace') {
      steps {
        sh '''
          set -e
          terraform workspace list | grep -w "${ENV}" \
            && terraform workspace select "${ENV}" \
            || terraform workspace new "${ENV}"
        '''
      }
    }

    stage('Terraform Plan') {
      steps {
        sh 'terraform plan'
      }
    }

    stage('Terraform Apply') {
      steps {
        sh 'terraform apply -auto-approve'
      }
    }
  }
}
