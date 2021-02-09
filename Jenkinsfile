pipeline {
  agent any

  tools {
    terraform 'terraform14'
  }

  environment {
    AWS = credentials('AWS')
  }

  stages {

    stage('Terraform Apply') {
      steps {
        sh '''
          export AWS_ACCESS_KEY_ID=${AWS_USR}
          export AWS_SECRET_ACCESS_KEY=${AWS_PSW}
          make dev-init
          make dev-apply
        '''
      }
    }

  }

}