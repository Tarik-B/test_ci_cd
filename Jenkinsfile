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
//                             script {
//                                 env.BUILD_TYPE='${BUILD_TYPE}'
//                             }
                            echo "Do Build ${env.BUILD_TYPE}"
                            sh 'rm -rf builds/build_${BUILD_TYPE}'
                            sh 'cmake -DCMAKE_BUILD_TYPE=${BUILD_TYPE} -S . -B builds/build_${BUILD_TYPE}'
                            sh 'cmake --build builds/build_${BUILD_TYPE}'
                        }
                    }
                    stage('Test') {
                        steps {
                            sh './builds/build_${BUILD_TYPE}/test_ci_cd'
//                             sh './tests/robot/robot.sh'
                        }
                    }
                    stage('Deliver') {
                        steps {
                            sh 'tar -czf test_ci_cd_${BUILD_TYPE}.tar.gz builds/build_${BUILD_TYPE}/test_ci_cd'
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
