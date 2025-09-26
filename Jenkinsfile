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
                    stage('Build') {
                        steps {
                            echo 'Do Build ${BUILD_TYPE}'
                            sh 'rm -rf builds/build_${BUILD_TYPE}'
                            sh 'cmake -DCMAKE_BUILD_TYPE=${BUILD_TYPE} -S . -B builds/build_${BUILD_TYPE}'
                            sh 'cmake --build builds/build_${BUILD_TYPE}'
                        }
                    }
                    stage('Test') {
                        steps {
                            sh './builds/build_${BUILD_TYPE}/test_ci_cd'
                        }
                    }
                    stage('Deliver') {
                        steps {
                            sh 'tar -czf test_ci_cd_${BUILD_TYPE}.tar.gz builds/build_${BUILD_TYPE}/test_ci_cd'
                            archiveArtifacts artifacts: 'test_ci_cd_${BUILD_TYPE}.tar.gz', fingerprint: true
                        }
                    }
                }
                post {
                    cleanup {
                        sh 'cmake --build builds/build_${BUILD_TYPE} --target clean'
                        //cleanWs()
                    }
                }
            }
        }
    }
}
