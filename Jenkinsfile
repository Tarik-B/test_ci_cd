#!groovy

pipeline {
    agent any
    stages {
        stage('BuildTestDeliver') {
            matrix {
                agent any
                axes {
                    axis {
                        name 'BUILD_TYPE'
                        values 'debug', 'release'
                    }
                }
                stages {
                    stage('Initialization') {
                        steps {
                            echo "Do Build ${BUILD_TYPE}"
                            sh 'rm -rf builds/build_${BUILD_TYPE}'
                            sh 'rm -rf artifacts'
                            sh 'mkdir artifacts'
                        }
                    }
                    stage('Build') {
                        steps {
                            sh 'cmake -DCMAKE_BUILD_TYPE=${BUILD_TYPE} -S . -B builds/build_${BUILD_TYPE}'
                            sh 'cmake --build builds/build_${BUILD_TYPE}'
                            
                            sh 'cp builds/build_${BUILD_TYPE}/test_ci_cd artifacts/'
                        }
                    }
                    stage('Unit tests') {
                        steps {
                            sh 'ctest --test-dir builds/build_${BUILD_TYPE}'
                        }
                    }
                    stage('Tests') {
                        steps {
                            dir("tests/robot") {
                                sh './robot.sh'
                            }
                            
                            sh 'mkdir -p artifacts/robot'
                            
                            // Copy all files in robot output folder
                            sh 'cp -a tests/robot/output/. artifacts/robot'
                            
                            // Publish results to robot framework jenkins plugin
                            robot(outputPath: ".",
//                                 passThreshold: 90.0,
//                                 unstableThreshold: 70.0,
                                disableArchiveOutput: true,
                                outputFileName: "artifacts/robot/output.xml",
                                logFileName: 'artifacts/robot/log.html',
                                reportFileName: 'artifacts/robot/report.html',
                                countSkippedTests: true,    // Optional, defaults to false
//                                 otherFiles: 'screenshot-*.png'
                            )
                        }
                    }
                    stage('Deliver') {
                        steps {
                            sh 'tar -czf artifacts_${BUILD_TYPE}.tar.gz artifacts'
                            archiveArtifacts artifacts: '*.tar.gz', fingerprint: true, onlyIfSuccessful: true
                        }
                    }
                }
                post {
                    cleanup {
                        sh 'cmake --build builds/build_${BUILD_TYPE} --target clean'
                        cleanWs()
                    }
                }
            }
        }
    }
}
