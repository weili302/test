pipeline {
    agent any
    stages {
        stage('Hello') {
            steps {
                echo 'Hello World'
            }
        }
        stage('Run PowerShell Script') {
            steps {
                pwsh 'test.ps1'
            }
        }
    }
}
