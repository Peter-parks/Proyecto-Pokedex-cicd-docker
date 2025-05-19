pipeline {
    agent any

    environment {
        IMAGE_TEST    = "pokedex-app:test"
        IMAGE_PROD    = "pokedex-app:latest"
        CONTAINER_TEST = "pokedex-test-container"
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
                    // Levanta el contenedor en background
                    sh "docker rm -f $CONTAINER_TEST || true"
                    sh "docker run -d --name $CONTAINER_TEST $IMAGE_TEST tail -f /dev/null"

                    // Ejecuta dentro del contenedor los comandos de test y lint
                    sh "docker exec $CONTAINER_TEST npm test"
                    sh "docker exec $CONTAINER_TEST npm run eslint"

                    // Elimina el contenedor de test
                    sh "docker rm -f $CONTAINER_TEST"                                                        
                }
            }
        }    

        stage('Build Docker Image') {
            steps {
                dir(env.WORKSPACE){
                    sh "docker build -t $IMAGE_PROD ."
                }
            }
        }

        stage('Run Production Container') {
            steps {
                dir(env.WORKSPACE){
                    // Borra y levanta el contenedor de producción
                    sh "docker rm -f pokedex-app || true"
                    sh "docker run -d --name pokedex-app -p 0.0.0.0:5000:5000 $IMAGE_PROD"
                    echo "✅ Contenedor pokedex-app levantado. Esperando 10 minutos para pruebas manuales..."

                    // Espera 600 segundos
                    sh "sleep 600"

                    // Detiene el contenedor automáticamente
                    sh "docker stop pokedex-app"
                    echo "⏹️ Contenedor pokedex-app detenido tras 10 minutos."
                }
            }
        }
    }

    post {
        always {
            dir(env.WORKSPACE){
                // Limpieza de la imagen test
                sh "docker rmi $IMAGE_TEST || true"
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
