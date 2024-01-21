pipeline {
    agent any
    stages {
        stage('Run PowerShell Script') {
            steps {
                echo 'Hello World'
                powershell(script: 'test.ps1')
            }
        }
    }
}
