pipeline {
    agent any
    stages {
        stage('Build') {
            steps {
                sh 'rm -rf build'
                sh 'cmake -B build -S .'
                sh 'cmake --build build'
            }
        }
        stage('Test') {
            steps {
                sh './build/test_ci_cd'
            }
        }
        stage('Deliver') {
            steps {
                sh 'tar -czf test_ci_cd.tar.gz build/test_ci_cd'
                archiveArtifacts artifacts: 'test_ci_cd.tar.gz', fingerprint: true
            }
        }
    }
}
