pipeline {
    agent any
    stages {
        stage('Run PowerShell Script') {
            steps {
                echo 'Hello World'
                echo "${WORKSPACE}"
                //script {
                //    pwsh "${WORKSPACE}/test.ps1"
                //}
                powershell(script: "${WORKSPACE}/test.ps1")
            }
        }
    }
}
