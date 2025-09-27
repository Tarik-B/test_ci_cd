#!groovy

def VERSION = ""

pipeline {
    agent any
    stages {
        stage('Initialization') {
            steps {
                script {
                    VERSION = sh(script: "cat version.txt | xargs", returnStdout: true).trim()
                    echo "Building version ${VERSION}, build ${BUILD_NUMBER} (commit ${GIT_COMMIT} on branch ${GIT_BRANCH})"                    
                    buildName "v${VERSION}-build.${BUILD_NUMBER}"
//                     buildDescription "Executed @ ${NODE_NAME}"
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
                            sh 'rm -rf builds/build_${BUILD_TYPE}'
                            sh 'rm -rf artifacts'
                            sh 'mkdir artifacts'
                        }
                    }
                    stage('Static code analysis') {
                        steps {
                            sh 'cppcheck --enable=all --suppress=missingIncludeSystem  --suppress=checkersReport  --std=c++17 --error-exitcode=2 src/ tests/unit_tests/'
//                             sh 'cppcheck --enable=all --suppress=missingIncludeSystem --error-exitcode=2 src'
//                             --project=builds/build_${BUILD_TYPE}/compile_commands.json # find a way to exclude moc files (-i) and run cmake -B before this
//                             --checkers-report=cppcheck.report
//                             --inline-suppr # "unusedFunction check can't be used with '-j'"
//                             -j 8
                        }
                    }
                    stage('Build') {
                        steps {
                            sh 'cmake -DCMAKE_BUILD_TYPE=${BUILD_TYPE} -S . -B builds/build_${BUILD_TYPE}'
                            sh 'cmake --build builds/build_${BUILD_TYPE}'

                            sh 'cp builds/build_${BUILD_TYPE}/test_ci_cd artifacts/'
                        }
                    }
                    stage('Unit tests and coverage') {
                        steps {
                            sh 'ctest --test-dir builds/build_${BUILD_TYPE} -T test'
                            sh 'ctest --test-dir builds/build_${BUILD_TYPE} -T coverage'
                        }
                    }
                    stage('Robot tests') {
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
                    stage('Delivery') {
                        steps {
                            sh "tar -czf artifacts_v${VERSION}-build.${BUILD_NUMBER}_${BUILD_TYPE}.tar.gz artifacts"
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
