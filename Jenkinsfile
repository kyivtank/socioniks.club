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
	GODADDY_API_KEY= = credentials ('jenkins-godaddy-key')
        GODADDY_API_SECRET = credentials('jenkins-godaddy-secret')
        ANSIBLE_HOST_KEY_CHECKING = 'false'
        ANSIBLE_FORCE_COLOR = 'true'
    }
    stages {
        stage('Terraform') { 
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
        stage('GoDaddy') {
            steps {
                echo '=== DNS A record update ==='
                wrap([$class: 'AnsiColorBuildWrapper', 'colorMapName': 'xterm']) {
                 sh 'scripts/update_godaddy_dns.sh'
                }
            }
        }
        stage('Ansible') {
            steps {
                echo '=== Try ssh ==='
                wrap([$class: 'AnsiColorBuildWrapper', 'colorMapName': 'xterm']) {
                 withCredentials(bindings: [sshUserPrivateKey(credentialsId: 'aws2020', keyFileVariable: 'private_key')]){
                  sh "scripts/deploy_all.sh"
                 }
                }
	    }
	}
    }
}
