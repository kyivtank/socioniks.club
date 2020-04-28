pipeline {
    agent any
       triggers {
        pollSCM "* * * * *"
       }
    stages {
        stage('Make AWS EC2 instance') { 
            steps {
                echo '=== AWS EC2 ==='
                sh 'uptime' 
            }
        }
        stage('Register DNS Name') {
            steps {
                echo '=== DNS Update ==='
                sh("uptime")
            }
        }
    }
}
