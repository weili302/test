pipeline {
    agent any
    stages {
        stage('Run PowerShell Script') {
            steps {
                echo 'Hello World again'
                echo "${WORKSPACE}"
                script {
                    pwsh "${WORKSPACE}/test.ps1"
                }
            }
        }
    }
}
