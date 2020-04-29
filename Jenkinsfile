pipeline {
    agent any
       triggers {
        pollSCM "* * * * *"
       }
    environment {
        AWS_ACCESS_KEY_ID     = credentials('jenkins-aws-secret-key-id')
        AWS_SECRET_ACCESS_KEY = credentials('jenkins-aws-secret-access-key')
        AWS_DEFAULT_REGION = 'eu-central-1'
        AWS_DEFAULT_OUTPUT = 'table'
        GD_DOMAIN = 'socioniks.club'
	GD_API_KEY = credentials ('jenkins-godaddy-key')
        GD_API_SECRET = credentials('jenkins-godaddy-secret')
    }
    stages {
        stage('Make AWS EC2 instance') { 
            steps {
                echo '=== AWS EC2 ==='
                dir("${env.WORKSPACE}/terraform") {
                 wrap([$class: 'AnsiColorBuildWrapper', 'colorMapName': 'xterm']) {
                  sh "terraform init"
                  sh "terraform apply -auto-approve|tee -a terraform.out"
                 }
		 sh 'aws ec2 describe-instances'
                }
            }
        }
        stage('Register IP for DNS Name') {
            steps {
                echo '=== $GD_DOMAIN A record update ==='
		sh './update_godaddy_dns.sh'
            }
        }
    }
}
