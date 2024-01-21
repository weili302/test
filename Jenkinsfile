pipeline {
    agent any
    stages {
        stage('Run PowerShell Script') {
            steps {
                echo "${WORKSPACE}"
                script {
                    pwsh "${WORKSPACE}/test.ps1"
                }
            }
        }
    }
    post {
        always {
            echo "${currentBuild.result}"
        }
    }
}
