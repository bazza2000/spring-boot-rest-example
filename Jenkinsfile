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
                sh "cp -rp /mnt/target . ; /usr/bin/docker build -t  ec2-63-34-137-130.eu-west-1.compute.amazonaws.com:8083/spring-boot-rest-example:${env.BUILD_ID} ."
            }
        }
        stage('Push Image') {
            steps {
                sh '/usr/bin/docker login -u admin -p admin123 ec2-63-34-137-130.eu-west-1.compute.amazonaws.com:8083'
                sh '/usr/bin/docker push ec2-63-34-137-130.eu-west-1.compute.amazonaws.com:8083/spring-boot-rest-example'
            }
        }
        stage('Kubernetes Deploy') {
          agent { label 'jenkins_host' }
          steps {
              sh "PATH=$PATH:/root/bin ; cat demo-service.yaml.1 | sed \"s/JOB_NUMBER/${env.BUILD_ID}/g\" > demo-service.yaml ; /root/bin/kubectl apply -f /root/demo-service.yaml"
                sh "/root/check_deploy"
          }
        }
    }
}
