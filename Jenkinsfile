pipeline {
    agent { label "docker" }
    environment {
       date = '${BUILD_DATE_FORMATTED, "yyyyMMdd"}'
       repository = 'jhulibraries/sheridan-libraries-nutch'
       buildImage = ''
       tag = ''
    }
    stages {
        stage('Build') {
            steps {
                script {
                    githash = sh(script: "git rev-parse --short HEAD", returnStdout: true)
                    echo "***************************"
                    echo "${githash}"
                    echo "***************************"
                    tag = VersionNumber (versionNumberString: '${date}-${githash}-${BUILD_ID}')
                    echo "***************************"
                    echo "${tag}"
                    echo "***************************"
                    buildImage = docker.build("${repository}:${tag}", "./nutch1")
                }
            }
        }
        stage('Deploy') {
            when {
                branch 'master'
            }
            steps {
                script {
                    docker.withRegistry('', 'dockerhub') {
                        buildImage.push()
                        buildImage.push("latest")
                    }
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