pipeline {
  agent {
    node {
      label 'a1'
    }
    
  }
  stages {
    stage('') {
      steps {
        sh '''wget https://github.com/dwippoer/centos7-nginx-php7/blob/master/main.sh -P /tmp
bash /tmp/main.sh'''
      }
    }
  }
}