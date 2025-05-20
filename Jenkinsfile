pipeline {
    agent any

    environment {
        IMAGE_TEST             = "pokedex-app:test"
        CONTAINER_TEST         = "pokedex-test-container"
        DOCKERHUB_REPO         = "jonathanaliendo/proyecto-pokedex-cicd-docker"
        DOCKERHUB_CREDENTIALS  = "pokedex-cicd"
    }

    stages {
        stage('Build Test Image') {
           steps {
                dir(env.WORKSPACE){
                    // Construye solo la etapa 'builder' desde el Dockerfile en el workspace
                    sh "docker build --target builder -t $IMAGE_TEST ."
                }
            }
        }

        stage('Run Tests in Test Container') {
            steps {
                dir(env.WORKSPACE){
                  // Asegura que la etapa no detenga el pipeline en caso de fallo
                  catchError(buildResult: 'SUCCESS', stageResult: 'UNSTABLE') {
                    // Elimina cualquier contenedor previo
                    sh "docker rm -f $CONTAINER_TEST || true"
                    // Levanta el contenedor en background
                    sh "docker run -d --name $CONTAINER_TEST $IMAGE_TEST tail -f /dev/null"

                    // Ejecuta dentro del contenedor los comandos de test y lint
                    sh "docker exec $CONTAINER_TEST npm test"
                    sh "docker exec $CONTAINER_TEST npm run eslint"

                    // Elimina el contenedor de test
                    sh "docker rm -f $CONTAINER_TEST" 
                    }                                                       
                }
            }
        }    

//        stage('Build Docker Image') {
//            steps {
//                dir(env.WORKSPACE){
//                    sh "docker build -t $IMAGE_PROD ."
//                }
//            }
//        }
//        stage('Run Production Container') {
//            steps {
//                dir(env.WORKSPACE){
//                    // Borra y levanta el contenedor de producción
//                    sh "docker rm -f pokedex-app || true"
//                    sh "docker run -d --name pokedex-app -p 0.0.0.0:5000:5000 $IMAGE_PROD"
//                    echo "✅ Contenedor pokedex-app levantado. Esperando 10 minutos para pruebas manuales..."
//
                    // Espera 600 segundos
//                    sh "sleep 600"
//
                    // Detiene el contenedor automáticamente
//                    sh "docker stop pokedex-app"
//                    echo "⏹️ Contenedor pokedex-app detenido tras 10 minutos."
//                }
//            }
        stage('Push Test Image to Docker Hub') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: env.DOCKERHUB_CREDENTIALS,
                    usernameVariable: 'DH_USER',
                    passwordVariable: 'DH_PASS'
                )]) {
                    // Login en Docker Hub
                    sh 'echo $DH_PASS | docker login -u $DH_USER --password-stdin'
                    // Tag y push al repositorio
                    sh "docker tag $IMAGE_TEST $DOCKERHUB_REPO:test"
                    sh "docker push $DOCKERHUB_REPO:test"
                }
            }
        }
    }

    post {
        always {
            dir(env.WORKSPACE){
                // Limpieza de la imagen test
                sh "docker rmi $IMAGE_TEST || true"
                sh "docker logout"
            }
        }
        success {
            echo '✅ Pipeline completado correctamente'
        }
        failure {
            echo '❌ Pipeline falló'
        }            
    }    
}
