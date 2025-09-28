#!groovy

pipeline {
    agent any
    environment {
        VERSION = sh(script: "cat version.txt | xargs", returnStdout: true).trim()
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
                            sh 'scripts/0_prepare.sh'
                        }
                    }
                    stage('Buildsystem generation') {
                        steps {
                            // This generates compile_commands.json required for static analysis
                            sh 'cmake -DCMAKE_BUILD_TYPE=${BUILD_TYPE} -S . -B builds/build_${BUILD_TYPE}'
                        }
                    }
                    stage('Static code analysis') {
                        steps {
                            sh 'cppcheck --enable=all --suppress=missingIncludeSystem --suppress=checkersReport --std=c++17 --error-exitcode=23 src/ tests/unit_tests/'
//                             sh 'run-clang-tidy -j 8 -p builds/build_${BUILD_TYPE}' // run-clang-tidy runs clang-tidy over everything in compile_commands.json at specified path
//                             sh 'cppcheck --enable=all --suppress=missingIncludeSystem --error-exitcode=2 src'
//                             --project=builds/build_${BUILD_TYPE}/compile_commands.json # find a way to exclude moc files (-i) and run cmake -B before this
//                             --checkers-report=cppcheck.report
//                             --inline-suppr # "unusedFunction check can't be used with '-j'"
//                             -j 8
                        }
                    }
//                     --error-exitcode=<number>
                    stage('Build') {
                        steps {
                            sh 'cmake --build builds/build_${BUILD_TYPE}'

                            sh 'cp builds/build_${BUILD_TYPE}/test_ci_cd artifacts/'
                        }
                    }
                    stage('Sanity check') {
                        steps {
                            catchError(buildResult: 'UNSTABLE', stageResult: 'FAILURE') {
                                sh 'valgrind --tool=memcheck --leak-check=full --error-exitcode=23 builds/build_${BUILD_TYPE}/test_ci_cd hello world'
//                                 --log-file=<filename> --xml=yes --xml-file=<filename>
//                                 --gen-suppressions=all --track-origins=yes
                            }
                        }
                    }
                    stage('Unit tests and coverage') {
                        steps {
                            catchError(buildResult: 'UNSTABLE', stageResult: 'FAILURE') {
                                sh 'ctest --test-dir builds/build_${BUILD_TYPE} -T test'
                                sh 'ctest --test-dir builds/build_${BUILD_TYPE} -T coverage'
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
                            sh 'tar -czf artifacts_v${VERSION}-build.${BUILD_NUMBER}_${BUILD_TYPE}.tar.gz artifacts'
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
