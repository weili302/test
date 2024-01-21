pipeline {
    agent any
    stages {
        stage('Run PowerShell Script') {
            steps {
                echo 'Hello World'
                echo '${WORKSPACE}'
                powershell(script: 'test.ps1')
            }
        }
    }
}
