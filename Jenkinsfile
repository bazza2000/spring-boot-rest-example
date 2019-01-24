pipeline {
    agent any
    stages {
        stage('Build') { 
    agent {
        docker {
            image 'maven:3-alpine' 
            args '-v /root/.m2:/root/.m2 -v /mnt:/artifacts' 
        }
    }
            steps {
                sh 'pwd ; df -k ; ls -al'
                sh 'mvn -B -DskipTests clean package'
                sh 'cp -rp target /artifacts'
            }
        }
        stage('Test') {
    agent {
        docker {
            image 'maven:3-alpine' 
            args '-v /root/.m2:/root/.m2' 
        }
    }
            steps {
                sh 'mvn test'
            }
            post {
                always {
                    junit 'target/surefire-reports/*.xml'
                }
            }
        }

        stage('Containerize') {
            steps {
                sh 'pwd ; df -k ; ls -al'
                sh 'cp -rp /mnt/target . ; /usr/bin/docker build -t spring-boot-rest-example .'
                sh '/usr/bin/docker login -u admin -p admin123 ec2-63-34-137-130.eu-west-1.compute.amazonaws.com:8082'
            }
        }
    }
}
