pipeline {
    agent any
    environment {
        sender = 'sender@example.com'
        recipients = ['recipient1@example.com', 'recipient2@example.com']
        cc = ['cc1@example.com', 'cc2@example.com']
    }
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
            archiveArtifacts artifacts: '**/*', fingerprint: true
            emailext (
                subject: "${currentBuild.result == 'SUCCESS' ? '执行成功' : '执行失败'} - Job: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                body: '''构建结果：${currentBuild.result}
                构建日志：${env.BUILD_URL}console
                ''',
                to: recipients.join(','),
                cc: cc.join(','),
                from: sender
            )
        }
    }
}
