pipeline {
    agent any
    stages {
        stage('Run PowerShell Script') {
            steps {
                echo 'Hello World'
                Script{
                    pwsh 'test.ps1'
                }
            }
        }
    }
}
