pipeline {
    agent { label "docker" }
    environment {
       date = '${BUILD_DATE_FORMATTED, "yyyyMMdd"}'
       repository = 'jhulibraries/sheridan-libraries-nutch'
       buildImage = ''
       tag = ''
       GITHASH = ''
    }
    stages {
        stage('Build') {
            steps {
                script {
                    GITHASH = sh(script: "git rev-parse --short HEAD", returnStdout: true)
                    echo "***************************"
                    echo "${GITHASH}"
                    echo "***************************"
                    tag = VersionNumber(versionNumberString: '${BUILD_DATE_FORMATTED, "yyyyMMdd"}-${GITHASH}-${BUILD_ID}')
                    echo "***************************"
                    echo "${tag}"
                    echo "***************************"
                    //buildImage = docker.build("${repository}:${tag}", "./nutch1")
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