# Proyecto Pokedex CI/CD con Docker y Jenkins

## Descripción

Esta aplicación de Pokedex, desarrollada con Node.js y Webpack, sirve como práctica de dockerización y CI/CD con Jenkins. Permite:

* Mostrar información de Pokémon.
* Ejecutar tests y análisis de código estático (eslint) dentro de contenedores Docker.
* Automatizar la construcción, prueba y despliegue de imágenes Docker en Docker Hub.

> **Fork del repositorio**
> Si querés practicar con este setup, forkear este repositorio te dará una base ya preparada para CI/CD.

## Flujo CI/CD en Jenkins

El pipeline está definido en `Jenkinsfile` y consta de tres etapas principales:

1. **Build Test Image**

   * Construye una imagen de prueba desde el target `builder` de tu `Dockerfile`.
2. **Run Tests in Test Container**

   * Levanta un contenedor en background, ejecuta `npm test` y `npm run eslint`, y limpia el contenedor.
3. **Push Test Image to Docker Hub**

   * Hace login en Docker Hub usando credenciales de Jenkins, etiqueta la imagen y la sube a tu repositorio.

```groovy
pipeline {
  agent any
  environment {
    IMAGE_TEST            = 'pokedex-app:test'
    CONTAINER_TEST        = 'pokedex-test-container'
    DOCKERHUB_REPO        = 'jonathanaliendo/proyecto-pokedex-cicd-docker'
    DOCKERHUB_CREDENTIALS = 'dockerhub-creds'
  }
  stages {
    stage('Build Test Image') { /* ... */ }
    stage('Run Tests in Test Container') { /* ... */ }
    stage('Push Test Image to Docker Hub') { /* ... */ }
  }
  post { /* limpieza y logout */ }
}
```

## Comandos Útiles

Dentro de la carpeta del proyecto:

```bash
npm install          # Instalar dependencias
npm start            # Iniciar servidor de desarrollo
npm test             # Ejecutar tests
enpm run eslint      # Correr linter
npm run build        # Generar build de producción
npm run start-prod   # Ejecutar build de producción
```

## Subida a Docker Hub

El pipeline sube la imagen con la etiqueta `test` al repositorio:

```bash
docker push jonathanaliendo/proyecto-pokedex-cicd-docker:test
```

---

Con este setup simplificado, pude practicar CI/CD y dockerización de forma rápida y reproducible.
