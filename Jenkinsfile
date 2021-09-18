pipeline {
  agent any
  stages {
    stage('build') {
      steps {
        sh 'virtualenv .venv'
        sh """
            source .venv/bin/activate
            pip install -r requirements.txt
            pip install wheel
            python setup.py bdist_wheel
           """
      }
    }
    stage('test') {
      steps {
        sh """
             source .venv/bin/activate
             python my_application/test.py
           """
      }
      post {
        always {
          junit 'test-reports/*.xml'
        }
      }
    }
    stage('uploadBinaryToS3') {
      steps {
        sh """
              source .venv/bin/activate
              pwd
              ls
              aws s3 cp dist/my_application-*.whl s3://test-ankur/users/temp/
           """
      }
    }
    stage('deploy') {
      steps {
        sh """
              terraform -v
              cd terraform
              terraform init
              terraform plan -out plan.out
              terraform apply -auto-approve plan.out
              terraform plan -destroy -out planfile
              aws s3 cp plan.out s3://test-ankur/users/temp/
              aws s3 cp planfile s3://test-ankur/users/temp/
           """
      }
    }
  }
  post {
        always {
            cleanWs()
        }
    }
}