pipeline {
    agent any
       triggers {
        pollSCM "* * * * *"
       }
    environment {
        AWS_ACCESS_KEY_ID     = credentials('jenkins-aws-secret-key-id')
        AWS_SECRET_ACCESS_KEY = credentials('jenkins-aws-secret-access-key')
	GD_API_KEY = credentials ('jenkins-godaddy-key')
        GD_API_SECRET = credentials('jenkins-godaddy-secret')
    }
    stages {
        stage('Make AWS EC2 instance') { 
            steps {
                echo '=== AWS EC2 ==='
                sh 'uptime' 
		sh 'aws ec2 describe-instances --region eu-central-1'
            }
        }
        stage('Register DNS Name') {
            steps {
                echo '=== DNS Update ==='
                sh("uptime")
		sh 'curl -X GET -H"Authorization: sso-key $GD_API_KEY:$GD_API_SECRET" "https://api.godaddy.com/v1/domains/socioniks.club/records/A/@"'
            }
        }
    }
}
