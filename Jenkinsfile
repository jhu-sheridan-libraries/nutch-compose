pipeline {
    agent { label "docker" }
    environment {
       repository = 'jhulibraries/sheridan-libraries-nutch'
       buildImage = ''
       githash = sh(script: "git rev-parse --short HEAD", returnStdout: true).trim()
       tag = VersionNumber (versionNumberString: '${BUILD_DATE_FORMATTED, "yyyyMMdd"}' + "-${githash}-" + '${BUILD_ID}')
    }
    stages {
        stage('Build') {
            steps {
                script {
                    buildImage = docker.build("${repository}:${tag}", "./nutch1")
                }
            }
        }
    }
    post {
        always {
            sh ('docker system prune -a --force')
        }
    }
}