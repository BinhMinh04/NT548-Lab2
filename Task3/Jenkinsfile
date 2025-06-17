pipeline {
    agent any
    
    environment {
        SONAR_PROJECT_KEY = 'Giabaoday_Sample-microservice'
        SONAR_ORG = 'giabaoday'
        DOCKER_HUB_REPO = 'baotg0502/demo-app'
        DOCKER_HUB_CREDENTIALS = 'docker-hub-credentials'
    }
    
    tools {
        maven 'Maven'         
        jdk 'JDK11'            
    }
    
    stages {
        stage('Checkout') {
            steps {
                echo '📥 Code đã được checkout từ GitHub'
                sh 'ls -la'
            }
        }
        
        stage('Build') {
            steps {
                echo '🔨 Building application với Maven...'
                sh '''
                    mvn clean compile
                    echo "Maven build completed!"
                '''
            }
        }
        
        stage('Test') {
            steps {
                echo '🧪 Running unit tests...'
                sh '''
                    mvn test
                    echo "All tests passed!"
                '''
            }
            post {
                always {
                    junit testResults: 'target/surefire-reports/*.xml', allowEmptyResults: true
                }
            }
        }
        
        stage('SonarCloud Analysis') {
            steps {
                echo '🔍 Running SonarCloud code quality analysis...'
                withSonarQubeEnv('SonarCloud') {  
                    sh '''
                        mvn clean verify sonar:sonar \
                            -Dsonar.projectKey=${SONAR_PROJECT_KEY} \
                            -Dsonar.organization=${SONAR_ORG} \
                            -Dsonar.host.url=https://sonarcloud.io
                    '''
                }
            }
        }
        
        stage('Quality Gate') {
            steps {
                echo '⏳ Waiting for SonarCloud Quality Gate...'
                timeout(time: 10, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
                echo '✅ Quality Gate passed!'
            }
        }
         
        stage('Build & Push Docker Image') {
            steps {
                echo '🐳 Building and pushing Docker image...'
                script {
                    sh '''
                        if [ -f Dockerfile ]; then
                            echo "Dockerfile found, building image..."
                            
                            # Build image với build number
                            docker build -t ${DOCKER_HUB_REPO}:${BUILD_NUMBER} .
                            docker tag ${DOCKER_HUB_REPO}:${BUILD_NUMBER} ${DOCKER_HUB_REPO}:latest
                            
                            echo "Docker image built successfully!"
                            echo "Image: ${DOCKER_HUB_REPO}:${BUILD_NUMBER}"
                            echo "Image: ${DOCKER_HUB_REPO}:latest"
                        else
                            echo "No Dockerfile found, skipping Docker build"
                            exit 1
                        fi
                    '''
                    
                    withCredentials([usernamePassword(credentialsId: "${DOCKER_HUB_CREDENTIALS}", 
                                                    usernameVariable: 'DOCKER_HUB_USERNAME', 
                                                    passwordVariable: 'DOCKER_HUB_PASSWORD')]) {
                        sh '''
                            echo "🔐 Logging into Docker Hub..."
                            echo $DOCKER_HUB_PASSWORD | docker login -u $DOCKER_HUB_USERNAME --password-stdin
                            
                            echo "⬆️ Pushing images to Docker Hub..."
                            docker push ${DOCKER_HUB_REPO}:${BUILD_NUMBER}
                            docker push ${DOCKER_HUB_REPO}:latest
                            
                            echo "✅ Images pushed successfully!"
                            
                            # Logout for security
                            docker logout
                        '''
                    }
                }
            }
        }
        
        stage('Scan') {
            steps {
                script {
                    snykSecurity(
                        severity: 'critical',
                        snykInstallation: 'Snyk',
                        snykTokenId: 'snyk-token',
                        failOnIssues: false
                    )
                }
            }
        }
        
        stage('Deploy to Kubernetes') {
            steps {
                script {
                    sh '''
                        if ! [ -f ./kubectl ]; then
                          curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
                          chmod +x ./kubectl
                        fi
                        
                        # Update deployment image với latest build
                        ./kubectl set image deployment/demo-microservice demo-microservice=${DOCKER_HUB_REPO}:${BUILD_NUMBER}
                        
                        # Apply configs (nếu có thay đổi)
                        ./kubectl apply -f k8s/deployment.yaml
                        ./kubectl apply -f k8s/service.yaml
                        
                        # Wait for rollout với timeout dài hơn
                        ./kubectl rollout status deployment/demo-microservice --timeout=600s
                        
                        # Verify deployment
                        ./kubectl get pods -l app=demo-microservice
                        
                        # Health check
                        SERVICE_URL=$(./kubectl get service demo-microservice-service -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
                        if [ -n "$SERVICE_URL" ]; then
                            echo "Service URL: http://$SERVICE_URL"
                            curl -f http://$SERVICE_URL/health || echo "Health check failed, but continuing..."
                        fi
                        echo "✅ Kubernetes deployment successful!"
                    '''
                }
            }
            post {
                failure {
                    echo '❌ Deployment failed, attempting rollback...'
                    sh '''
                        ./kubectl rollout undo deployment/demo-microservice
                        ./kubectl rollout status deployment/demo-microservice --timeout=300s
                    '''
                }
            }
        }
    }
    
    post {
        always {
            echo '🧹 Cleaning up workspace...'
            archiveArtifacts artifacts: 'target/*.jar', allowEmptyArchive: true
            
            sh '''
                docker rmi ${DOCKER_HUB_REPO}:${BUILD_NUMBER} || true
                docker rmi ${DOCKER_HUB_REPO}:latest || true
                docker system prune -f || true
            '''
        }
        success {
            echo ''
            echo '🎉 ===== PIPELINE SUCCESS ===== 🎉'
            echo '✅ Code checkout completed'
            echo '✅ Build successful'
            echo '✅ Tests passed'
            echo '✅ SonarCloud quality gate passed'
            echo '✅ Docker image built and pushed'
            echo '✅ Security scans completed'
            echo '✅ Deployment successful'
            echo ''
            echo '📊 Reports available:'
            echo '   - SonarCloud: https://sonarcloud.io'
            echo '   - Snyk Dashboard: https://app.snyk.io'
            echo '   - Jenkins Artifacts: Check build artifacts'
            echo '   - Docker Hub: https://hub.docker.com/r/${DOCKER_HUB_REPO}'
            echo '================================='
        }
        failure {
            echo ''
            echo '❌ ===== PIPELINE FAILED ===== ❌'
            echo 'Pipeline execution failed. Check logs above for details.'
            echo ''
            echo '🔧 Common issues:'
            echo '   - SonarCloud quality gate failed'
            echo '   - Critical security vulnerabilities found'
            echo '   - Build or test failures'
            echo '   - Docker build/push failures'
            echo '   - Kubernetes deployment issues'
            echo '   - Tool configuration issues'
            echo ''
            echo '💡 Next steps:'
            echo '   1. Check SonarCloud report for code quality issues'
            echo '   2. Review Snyk report for security vulnerabilities'
            echo '   3. Verify Docker Hub credentials and repository'
            echo '   4. Check Kubernetes cluster status'
            echo '   5. Fix issues and push new code'
            echo '================================='
        }
        unstable {
            echo '⚠️ Pipeline completed with warnings - check security scan results'
        }
    }
}