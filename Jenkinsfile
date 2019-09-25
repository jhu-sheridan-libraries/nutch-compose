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
                    echo "***************************"
                    echo "${githash}"
                    echo "***************************"
                    echo "***************************"
                    echo "${tag}"
                    echo "***************************"
                    buildImage = docker.build("${repository}:${tag}", "./nutch1")
                }
            }
        }
        stage ('Temporary') {
            steps {
                script {
                    echo "${GITHASH}"
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