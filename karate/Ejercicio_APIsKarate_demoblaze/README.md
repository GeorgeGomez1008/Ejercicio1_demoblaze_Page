Este documento proporciona instrucciones detalladas sobre cómo ejecutar y probar el proyecto con JDK 11 y Gradle 7.5.1.
Asegúrese de seguir estos pasos para garantizar una ejecución exitosa.

### Requisitos Previos
- JDK 11 instalado en su máquina.
- Gradle 7.5.1 Wrapper configurado en el proyecto.
#### Configuración del Entorno
- JDK 11: Asegúrese de tener JDK 11 instalado en su máquina. Puede descargarlo desde Oracle JDK o utilizar una
  distribución como OpenJDK.

 - Gradle 7.4 Wrapper: Verifique que el proyecto esté configurado con Gradle 7.4 Wrapper. Si aún no lo ha hecho, puede
   configurarlo ejecutando el siguiente comando en la raíz del proyecto:

```bash
./gradlew wrapper --gradle-version=7.4
```

### Ejecución de Pruebas desde la Ruta src/java/test

* Ejecutar el Runner para la Prueba:
  Este comando cambiará al directorio src/java/test y ejecutará la prueba de categoría usando el runner RunnerPet y el
  método testGet.


Informes

Después de ejecutar las pruebas, los informes estarán disponibles en el directorio *
*target/karate-reports/karate-tags.html** Abra este archivo en un navegador web para ver los resultados detallados de
las pruebas.

