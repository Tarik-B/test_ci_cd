#!groovy

pipeline {
    agent any
    environment {
        VERSION = sh(script: 'cat version.txt | xargs', returnStdout: true).trim()
        PROJECT_NAME = sh(script: 'basename "$PWD"', returnStdout: true)
    }
    stages {
        stage('Initialization') {
            steps {
                script {
//                     sh 'scripts/pipeline.sh --init' // sets up VERSION and PROJECT_NAME env variables but those will be lost on subshell termination
                    echo "Building version ${VERSION}, build ${BUILD_NUMBER} (commit ${GIT_COMMIT} on branch ${GIT_BRANCH})"                    
                    buildName "v${VERSION}-build.${BUILD_NUMBER}"
                }
            }
        }
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
                    stage('Buildsystem generation') {
                        steps {
                            // generates compile_commands.json required for static analysis
                            sh 'scripts/pipeline.sh --configure ${BUILD_TYPE}'
                        }
                    }
                    stage('Static code analysis') {
                        steps {
                            sh 'scripts/pipeline.sh --analyze ${BUILD_TYPE}'
                        }
                    }
                    stage('Build') {
                        steps {
                            sh 'scripts/pipeline.sh --build ${BUILD_TYPE}'
                        }
                    }
                    stage('Sanity check') {
                        steps {
                            catchError(buildResult: 'UNSTABLE', stageResult: 'FAILURE') {
                                sh 'scripts/pipeline.sh --sanity ${BUILD_TYPE}'
                            }
                        }
                    }
                    stage('Unit tests and coverage') {
                        steps {
                            catchError(buildResult: 'UNSTABLE', stageResult: 'FAILURE') {
                                sh 'scripts/pipeline.sh --test ${BUILD_TYPE}'
                            }
                        }
                    }
                    stage('Robot Framework tests') {
                        steps {
                            catchError(buildResult: 'UNSTABLE', stageResult: 'FAILURE') {
                                sh 'scripts/pipeline.sh --robot ${BUILD_TYPE}'

                                // Publish results to robot framework jenkins plugin
                                robot(outputPath: ".",
//                                     passThreshold: 90.0,
//                                     unstableThreshold: 70.0,
                                    disableArchiveOutput: true,
                                    outputFileName: "tests/robot/output/output.xml",
                                    logFileName: 'tests/robot/output/log.html',
                                    reportFileName: 'tests/robot/output/report.html',
                                    countSkippedTests: true,    // Optional, defaults to false
//                                     otherFiles: 'screenshot-*.png'
                                )
                            }
                        }
                    }
                    stage('Delivery') {
                        steps {
                            sh 'scripts/pipeline.sh --package ${BUILD_TYPE}'
                            archiveArtifacts artifacts: '*.tar.gz', fingerprint: true, onlyIfSuccessful: true
                        }
                    }
                }
                post {
                    cleanup {
//                         sh 'cmake --build builds/build_${BUILD_TYPE} --target clean'
                        sh 'rm -rf build builds/build_${BUILD_TYPE}'
                        cleanWs()
                    }
                }
            }
        }
    }
}
