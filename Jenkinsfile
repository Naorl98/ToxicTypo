pipeline {
    agent any
    options {
        timestamps()  // Corrected option for adding timestamps to the console output
    }
    tools {
        maven "maven 3.6.2"  // Ensure the version and name matches what is configured in Jenkins
        jdk "openjdk-8"  // Corrected to a likely valid JDK configuration name
    }
    stages {
        stage("Checkout") {
            steps {  // Added missing 'steps' block
                echo "================== Checking out ==============="
                checkout scm
                sh 'mvn clean'
            }
        }
    stage("Build test ") {
        when {
            anyOf {
                branch "main"
                branch "feature/*"
            }
        }
        steps {
            echo "==== Build test====="
            sh 'cp spelling-1.0-SNAPSHOT.jar /var/jenkins_home/.m2/repository/spelling/spelling/1.0-SNAPSHOT/ || true'
            withMaven {
                configFileProvider([configFile(fileId: "b97b7c1f-f858-4125-af8e-1c92af8a13be", targetLocation: 'settings.xml')]) {
                    sh 'mvn -s settings.xml verify'
                }
            }
            sh 'mvn verify'

            // Correctly handle the network creation check
            sh 'docker network create test-network || echo "Network exists"'
            
 
            sh 'sleep 3'
            // cd src/test

            // Correctly handle multi-line script with appropriate directory and command
            sh '''
                docker rmi test-app || true
                docker build -t toxic-img .
                sleep 5
                cd src/test
                docker build -t test-app .
                sleep 3
                cd ..
                cd ..

            '''
        }
        post {
            success {
                echo "============ Build test image success ========"
            }
            failure {
                echo "============ Build test image failed ========"
            }
        }
    }

        stage("Run Tests") {
            when {
                anyOf {
                    branch "main"
                    branch "feature/*"
                }
            }
            steps {
                sh 'docker rm -f app-to-test || true'
                sh 'docker rm -f testapp || true'
                sh 'sleep 4'

                sh 'docker run  -d --network test-network --name app-to-test -p 8083:8080 toxic-img:latest'
                sh 'sleep 3'
                sh 'docker run -d --network test-network --name testapp -e app=app-to-test:8080 test-app:latest'
                sh 'docker ps | grep testapp || (echo "failed to run" && exit 1)'
            }
            post {
                success {
                    echo "============ Test execution success ========"
                    sh 'docker rm -f testapp app-to-test'
                    sh 'docker network rm test-network'
                }
                failure {
                    echo "============ Test execution failed ========"
                    sh 'docker rm -f testapp app-to-test'
                    sh 'docker network rm test-network'
                }
            }
        }
        stage("Publish") {
            when {
                branch "main"
            }
            steps {
                echo "=============== Publish ==============="
                sh 'docker build -t toxic-img .'
                sh '''
                    docker tag toxic-img 324037305534.dkr.ecr.ap-south-1.amazonaws.com/toxic-naor:0.1
                    aws ecr get-login-password --region ap-south-1 | docker login --username AWS --password-stdin 324037305534.dkr.ecr.ap-south-1.amazonaws.com
                    docker push 324037305534.dkr.ecr.ap-south-1.amazonaws.com/toxic-naor:0.1
                '''
                    // script {
                    //     // docker.withRegistry('https://324037305534.dkr.ecr.ap-south-1.amazonaws.com', '"ecr:ap-south-1:aws:key"') {
                    //     //     docker.image('toxic-naor').push()
                    //     }
                // }
            }
            post {
                always {
                    echo "============ Publish image done ========"
                }
                success {
                    echo "============ Publish image success ========"
                }
                failure {
                    echo "============ Publish image failed ========"
                }
            }
        }
        stage("Deploy") {
            when {
                branch "main"
            }
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: 'toxic-rsa', keyFileVariable: 'SSH_KEY_PATH', usernameVariable: 'SSH_USER')]) {
                    sh """
                            echo "Checking SSH Key Path: \$SSH_KEY_PATH"
                            chmod 400 \$SSH_KEY_PATH
                            ssh -i \$SSH_KEY_PATH -o StrictHostKeyChecking=no ubuntu@3.110.45.221 \\
                            'set -e && \\
                            echo \"Logging into AWS ECR...\" && \\
                            aws ecr get-login-password --region ap-south-1 | docker login --username AWS --password-stdin 324037305534.dkr.ecr.ap-south-1.amazonaws.com && \\
                            echo \"Pulling latest Docker image...\" && \\
                            docker pull 324037305534.dkr.ecr.ap-south-1.amazonaws.com/toxic-naor:0.1 && \\
                            echo \"Stopping existing container if it exists...\" && \\
                            sudo docker stop toxic-container || true && \\
                            sudo docker rm toxic-container || true && \\
                            echo \"Running new container...\" && \\
                            sudo docker run -d --name toxic-container -p 8083:8080 324037305534.dkr.ecr.ap-south-1.amazonaws.com/toxic-naor:0.1'
                        """

                }   
            }
            post {
                always {
                    echo "============ Deploy done ========"
                }
                success {
                    echo "============ Deploy success ========"
                }
                failure {
                    echo "============ Deploy failed ========"
                }
            }
        }
    }
    post {
        always {
            echo "============ Pipeline completed ========"
        }
        success {
            echo "============ Pipeline success ========"
            // updateGitCommitStatus name: "all good", state:"success" // Corrected function to match typical usage
        }
        failure {
            echo "============ Pipeline failed ========"
            // updateGitCommitStatus name: "error", state:"failed" // Corrected function to match typical usage
        }
    }
}
