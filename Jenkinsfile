pipeline {
    agent any
    
    environment {
        FLUTTER_VERSION = 'stable'
        JAVA_VERSION = '17'
        ANDROID_SDK_ROOT = "${env.ANDROID_HOME ?: '/opt/android-sdk'}"
    }
    
    options {
        timeout(time: 30, unit: 'MINUTES')
        buildDiscarder(logRotator(numToKeepStr: '10'))
        disableConcurrentBuilds()
    }
    
    tools {
        // Make sure Flutter and Java are installed in Jenkins
        // Configure in Jenkins: Manage Jenkins -> Global Tool Configuration
        // Flutter: Add Flutter SDK path or use Flutter plugin
        // Java: Add JDK installation
    }
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
                script {
                    echo "Checking out code from ${env.GIT_BRANCH}"
                }
            }
        }
        
        stage('Setup Flutter') {
            steps {
                script {
                    // Install Flutter if not already installed
                    // Adjust path based on your Jenkins setup
                    sh '''
                        if ! command -v flutter &> /dev/null; then
                            echo "Flutter not found. Please install Flutter in Jenkins."
                            exit 1
                        fi
                        flutter --version
                        flutter doctor
                    '''
                }
            }
        }
        
        stage('Get Dependencies') {
            steps {
                sh '''
                    flutter pub get
                    flutter pub upgrade
                '''
            }
        }
        
        stage('Code Analysis') {
            steps {
                sh 'flutter analyze --no-fatal-infos'
            }
            post {
                success {
                    echo 'Code analysis passed!'
                }
                failure {
                    echo 'Code analysis failed!'
                }
            }
        }
        
        stage('Run Tests') {
            steps {
                sh 'flutter test --coverage'
            }
            post {
                always {
                    // Publish test results
                    publishTestResults testResultsPattern: 'test/**/*.xml'
                    // Publish coverage reports if available
                    publishCoverageReports(
                        reportFile: 'coverage/lcov.info',
                        reportName: 'Flutter Test Coverage'
                    )
                }
                success {
                    echo 'All tests passed!'
                }
                failure {
                    echo 'Tests failed!'
                }
            }
        }
        
        stage('Build Android APK') {
            when {
                anyOf {
                    branch 'main'
                    branch 'master'
                    branch 'develop'
                }
            }
            steps {
                script {
                    sh '''
                        # Patch flutter_aws_chime plugin if it exists
                        echo "Checking for flutter_aws_chime plugin..."
                        PLUGIN_DIR=$(find ~/.pub-cache -name "*flutter_aws_chime*" -type d 2>/dev/null | head -1)
                        if [ -n "$PLUGIN_DIR" ]; then
                            BUILD_GRADLE=$(find "$PLUGIN_DIR" -name "build.gradle" -o -name "build.gradle.kts" 2>/dev/null | head -1)
                            if [ -n "$BUILD_GRADLE" ]; then
                                if ! grep -q "namespace" "$BUILD_GRADLE" 2>/dev/null; then
                                    cp "$BUILD_GRADLE" "$BUILD_GRADLE.backup"
                                    sed -i '/^android {/a\    namespace = "com.flutter_aws_chime"' "$BUILD_GRADLE"
                                    echo "Plugin patched successfully"
                                fi
                            fi
                        fi
                        
                        # Build APK
                        flutter build apk --release
                        echo "APK built successfully at: build/app/outputs/flutter-apk/app-release.apk"
                    '''
                }
            }
            post {
                success {
                    echo 'Android APK built successfully!'
                    archiveArtifacts artifacts: 'build/app/outputs/flutter-apk/*.apk', fingerprint: true
                }
                failure {
                    echo 'Android APK build failed!'
                }
            }
        }
        
        stage('Build Android App Bundle') {
            when {
                anyOf {
                    branch 'main'
                    branch 'master'
                }
            }
            steps {
                script {
                    sh '''
                        # Patch flutter_aws_chime plugin if it exists
                        echo "Checking for flutter_aws_chime plugin..."
                        PLUGIN_DIR=$(find ~/.pub-cache -name "*flutter_aws_chime*" -type d 2>/dev/null | head -1)
                        if [ -n "$PLUGIN_DIR" ]; then
                            BUILD_GRADLE=$(find "$PLUGIN_DIR" -name "build.gradle" -o -name "build.gradle.kts" 2>/dev/null | head -1)
                            if [ -n "$BUILD_GRADLE" ]; then
                                if ! grep -q "namespace" "$BUILD_GRADLE" 2>/dev/null; then
                                    cp "$BUILD_GRADLE" "$BUILD_GRADLE.backup"
                                    sed -i '/^android {/a\    namespace = "com.flutter_aws_chime"' "$BUILD_GRADLE"
                                    echo "Plugin patched successfully"
                                fi
                            fi
                        fi
                        
                        # Build App Bundle
                        flutter build appbundle --release
                        echo "AAB built successfully at: build/app/outputs/bundle/release/app-release.aab"
                    '''
                }
            }
            post {
                success {
                    echo 'Android App Bundle built successfully!'
                    archiveArtifacts artifacts: 'build/app/outputs/bundle/release/*.aab', fingerprint: true
                }
                failure {
                    echo 'Android App Bundle build failed!'
                }
            }
        }
    }
    
    post {
        always {
            // Archive coverage reports
            archiveArtifacts artifacts: 'coverage/**/*', allowEmptyArchive: true
            
            // Publish test results summary
            script {
                def testResults = sh(
                    script: 'find . -name "*.xml" -path "*/test/*" 2>/dev/null | head -1',
                    returnStdout: true
                ).trim()
                if (testResults) {
                    publishTestResults testResultsPattern: testResults
                }
            }
        }
        success {
            echo 'Pipeline succeeded!'
            // Send success notification (configure email/Slack/etc.)
            // emailext (
            //     subject: "Build Success: ${env.JOB_NAME} - ${env.BUILD_NUMBER}",
            //     body: "Build succeeded for ${env.GIT_BRANCH}",
            //     to: "sunilanddeveloper@gmail.com"
            // )
        }
        failure {
            echo 'Pipeline failed!'
            // Send failure notification
            // emailext (
            //     subject: "Build Failed: ${env.JOB_NAME} - ${env.BUILD_NUMBER}",
            //     body: "Build failed for ${env.GIT_BRANCH}. Check console output for details.",
            //     to: "sunilanddeveloper@gmail.com"
            // )
        }
        unstable {
            echo 'Pipeline is unstable!'
        }
    }
}

