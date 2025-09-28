#!groovy

pipeline {
    agent any
    environment {
        VERSION = sh(script: "cat version.txt | xargs", returnStdout: true).trim()
        PROJECT_NAME = 'test_ci_cd'
    }
    stages {
        stage('Initialization') {
            steps {
                script {
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
                    stage('Preparation') {
                        steps {
                            script {
                                echo "Building ${BUILD_TYPE}"
                            }
                            sh 'scripts/init.sh'
                        }
                    }
                    stage('Buildsystem generation') {
                        steps {
                            // This generates compile_commands.json required for static analysis
                            sh 'scripts/configure.sh'
                        }
                    }
                    stage('Static code analysis') {
                        steps {
                            sh 'scripts/analyze.sh src/ tests/unit_tests/'
                        }
                    }
//                     --error-exitcode=<number>
                    stage('Build') {
                        steps {
                            sh 'scripts/build.sh'

                            sh 'cp builds/build_${BUILD_TYPE}/${PROJECT_NAME} artifacts/'
                        }
                    }
                    stage('Sanity check') {
                        steps {
                            catchError(buildResult: 'UNSTABLE', stageResult: 'FAILURE') {
                                sh 'scripts/test_sanity.sh hello world'
                            }
                        }
                    }
                    stage('Unit tests and coverage') {
                        steps {
                            catchError(buildResult: 'UNSTABLE', stageResult: 'FAILURE') {
                                sh 'scripts/test_units.sh'
                            }
                        }
                    }
                    stage('Robot Framework tests') {
                        steps {
                            catchError(buildResult: 'UNSTABLE', stageResult: 'FAILURE') {
                                dir("tests/robot") {
                                    sh './robot.sh'
                                }

                                sh 'mkdir -p artifacts/robot'

                                // Copy all files in robot output folder
                                sh 'cp -a tests/robot/output/. artifacts/robot'

                                // Publish results to robot framework jenkins plugin
                                robot(outputPath: ".",
//                                     passThreshold: 90.0,
//                                     unstableThreshold: 70.0,
                                    disableArchiveOutput: true,
                                    outputFileName: "artifacts/robot/output.xml",
                                    logFileName: 'artifacts/robot/log.html',
                                    reportFileName: 'artifacts/robot/report.html',
                                    countSkippedTests: true,    // Optional, defaults to false
//                                     otherFiles: 'screenshot-*.png'
                                )
                            }
                        }
                    }
                    stage('Delivery') {
                        steps {
                            sh 'scripts/package_artifacts.sh ${PROJECT_NAME}_v${VERSION}-build.${BUILD_NUMBER}_${BUILD_TYPE}'
                            archiveArtifacts artifacts: '*.tar.gz', fingerprint: true, onlyIfSuccessful: true
                        }
                    }
                }
                post {
                    cleanup {
//                         sh 'cmake --build builds/build_${BUILD_TYPE} --target clean'
                        cleanWs()
                    }
                }
            }
        }
    }
}
