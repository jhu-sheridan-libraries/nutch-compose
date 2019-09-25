pipeline {
    agent { label: "docker" }
    environment {
       date = ${BUILD_DATE_FORMATTED, "yyyyMMdd"}
       githash = ''
       repository = 'jhulibraries/sheridan-libraries-nutch'
       buildImage = ''
       tag = ''
    }
    stages {
        stage('Build') {
            steps {
                script {
                    githash = sh('git rev-parse --parse HEAD')
                    tag = VersionNumber (versionNumberString: '${date}-${githash}-${BUILD_ID}')
                    buildImage = docker.build("${repository}:${tag}")
                }
            }
        }
        stage('Deploy') {
            when {
                branch 'master'
            }
            steps {
                docker.withRegistry('', 'dockerhub') {
                    buildImage.push()
                    buildImage.push("latest")
                }
            }
        }
    }
}