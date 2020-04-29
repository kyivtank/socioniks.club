pipeline {
    agent any
       triggers {
        pollSCM "* * * * *"
       }
    environment {
        AWS_ACCESS_KEY_ID     = credentials('jenkins-aws-secret-key-id')
        AWS_SECRET_ACCESS_KEY = credentials('jenkins-aws-secret-access-key')
        AWS_REGION = "eu-central-1"
        GD_DOMAIN = "socioniks.club"
	GD_API_KEY = credentials ('jenkins-godaddy-key')
        GD_API_SECRET = credentials('jenkins-godaddy-secret')
    }
    stages {
        stage('Make AWS EC2 instance') { 
            steps {
                echo '=== AWS EC2 ==='
                dir("${env.WORKSPACE}/terraform") {
                 sh "terraform init"
                 sh "terraform apply -auto-approve|tee -a terraform.out"
                }
		sh 'aws ec2 describe-instances'
            }
        }
        stage('Register DNS Name') {
            steps {
                echo '=== DNS Current state ==='
		sh 'update_godaddy_dns.sh'
            }
        }
    }
}
