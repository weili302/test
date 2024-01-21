pipeline {
    agent any
    stages {
        stage('Run PowerShell Script') {
            steps {
                echo 'Hello World'
                echo "${WORKSPACE}"
                script {
                    //dir("${WORKSPACE}") {
                        pwsh "${WORKSPACE}/test.ps1"
                    //}
                }
                // powershell(script: 'test.ps1')
            }
        }
    }
}
