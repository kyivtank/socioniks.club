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
                  sh "terraform apply -auto-approve|tee terraform.out"
                 }
		 sh 'aws ec2 describe-instances'
                }
            }
        }
        stage('Register IP for DNS Name') {
            steps {
                echo '=== DNS A record update ==='
		sh './update_godaddy_dns.sh'
            }
        }
	Stage('Setup the Server') {
	    steps {
                echo '=== Try ssh ==='
		withCredentials(bindings: [sshUserPrivateKey(credentialsId: 'aws2020', keyFileVariable: 'private_key')]){
                 sh "ssh -i $private_key -o StrictHostKeyChecking=no ubuntu@$GD_DOMAIN uptimei"
                }
	    }
	}
    }
}
