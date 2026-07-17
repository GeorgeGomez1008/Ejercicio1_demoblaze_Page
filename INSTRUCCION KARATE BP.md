# Instrucción de Buenas Prácticas para Pruebas API con Karate

## 1. Objetivo
Estandarizar la creación, mantenimiento y ejecución de pruebas de APIs con Karate en Banco Pichincha, usando el arquetipo oficial y lineamientos de calidad.

## 2. Contexto del Banco
Dentro de Banco Pichincha se emplean arquetipos como plantillas base para acelerar el desarrollo, reutilizar componentes y mantener consistencia entre equipos.

Para Karate Framework, el arquetipo oficial está en:

- [Arquetipo Karate Framework](https://dev.azure.com/BancoPichinchaEC/BP-Quality-Management/_git/sqa-aut-arq-karate)

## 3. Estructura mínima para Karate API
En este arquetipo, las pruebas API se enfocan en la carpeta de pruebas.

```text
src
├── main
└── test
    └── java
        └── com.pichincha
        │   ├── features
        │   │   └── Archivos .feature
        │   └── TestRunner.java
        └── karate-config.js
```

Regla clave:
- Escribir los escenarios en `features`.
- Ejecutar desde `TestRunner.java`.
- Mantener configuración global en `karate-config.js`.

## 4. Preparación del proyecto
1. Clonar el arquetipo desde Azure DevOps.
2. Abrir el proyecto con IntelliJ (Open File or Project).
3. Esperar la sincronización automática de Gradle.
4. Verificar versiones base del entorno:
- OpenJDK 21.0.3
- Gradle 8.7

Buenas prácticas:
- No modificar estructura base del arquetipo sin acuerdo del equipo.
- Mantener dependencias del proyecto alineadas al estándar del banco.
- Confirmar que el wrapper de Gradle funcione antes de escribir casos.

## 5. Dónde trabajar para APIs
Para automatización API con Karate, el trabajo debe hacerse en la carpeta test.

Prioridad de carpetas:
- test/java/com/pichincha/features: archivos .feature.
- test/java/com/pichincha/TestRunner.java: ejecución por tags.
- test/java/karate-config.js: variables, ambientes y utilidades globales.

Buenas prácticas:
- No mezclar lógica de UI con escenarios API.
- Mantener organización por dominio o funcionalidad.
- Evitar escenarios gigantes; dividir por comportamiento.

## 6. Estructura obligatoria de pruebas
Las pruebas se deben agrupar por dominio o funcionalidad.

Ejemplos de archivos:
- login.feature
- producto.feature

Regla de diseño:
- Cada archivo .feature debe contener escenarios relacionados únicamente a su funcionalidad.
- La ejecución de pruebas se controla desde el Test Runner por medio de tags.

## 7. Nombrado obligatorio de escenarios
Cada Scenario debe nombrarse bajo el formato de gobierno:

T-API-[Numero de HU]-[Criterio de Aceptacion]-[Nombre de la Prueba]

Significado de cada segmento:
- T: indica que el escenario corresponde a un Test Case en Jira.
- API: especifica el tipo de prueba.
- [Numero de HU]: historia de usuario relacionada. Debe coincidir con el identificador usado en el tag de Feature.
- [Criterio de Aceptacion]: criterio de aceptación que cubre el escenario.
- [Nombre de la Prueba]: descripción clara de lo validado.

Ejemplo:
- T-API-PQBP-511-CA2-Iniciar sesion con credenciales correctas

Aclaraciones obligatorias:
- Cada escenario debe tener un nombre unico.
- No pueden existir dos o más escenarios con el mismo nombre.

## 8. Escritura de tags y jerarquía
Los tags permiten controlar qué se ejecuta y qué se omite.

Reglas de jerarquía:
- El tag ubicado a nivel de Feature es el de mayor jerarquía.
- Los escenarios heredan el contexto del tag general del Feature.
- Los tags específicos de Scenario permiten filtrar casos puntuales.

Ejemplo:

```gherkin
@TagGeneral
Feature: Creacion de Pruebas de APIs Basicas

  Background:
    * url 'https://reqres.in/api'
    * header x-api-key = 'reqres-free-v1'

  @TagEspecifico1
  Scenario: Consulta de usuario por ID, Exitosa
    Given path '/users/1'
    When method get
    Then status 200
    And print response

  @TagEspecifico2
  Scenario: Creacion de Usuario, Exitoso
    * def body = {"name":"Juan", "job":"Trainee"}
    Given path '/users'
    And request body
    When method POST
    Then status 201
```

Buenas prácticas de ejecución:
- Si solo se quiere ejecutar un escenario, usar el tag específico en el Test Runner.
- Si se quieren ejecutar todos los escenarios del Feature, usar el tag general del Feature.

## 9. Datos de prueba y configuración
- Centralizar variables en karate-config.js.
- Usar archivos de datos (json/csv) por ambiente cuando aplique.
- Evitar credenciales en texto plano.

Buenas prácticas:
- Manejar secretos por variables de entorno o variable group del pipeline.
- No hardcodear URLs; usar baseUrl por ambiente.
- Mantener datos mínimos y determinísticos.

### 9.1 Evitar código quemado (hardcoded)
No usar valores fijos en el código. Esto reduce flexibilidad, dificulta mantenimiento y puede exponer información sensible.

Ejemplo de token:

Mala práctica:

```gherkin
* def token = 'abc123'
```

Buena práctica:

```gherkin
* def token = call read('classpath:helpers/token.feature')
```

Reglas:
- No escribir tokens, claves API ni credenciales directamente en escenarios.
- Usar variables de sistema o entorno para secretos.
- Para headers sensibles, usar archivos de apoyo (por ejemplo json) y parametrizarlos con variables de entorno.

## 10. Ejecución local
Ejemplo general desde Windows PowerShell:

```powershell
.\gradlew.bat clean test --tests "com.pichincha.automationtest.runners.ApiRunnerTest"
```

Ejecución por tag:

```powershell
.\gradlew.bat clean test --tests "com.pichincha.automationtest.runners.ApiRunnerTest" -Dkarate.options="--tags @smoke"
```

Buenas prácticas:
- Ejecutar primero @smoke para validar salud de pruebas.
- Luego ejecutar regresión completa.
- Revisar reportes siempre, incluso cuando el build esté en verde.

### 10.1 Uso del Test Runner por tags
El Test Runner debe usarse para ejecutar pruebas por tags y mantener controlada la suite.

Ejemplo:

```gherkin
@REQ_PQBP-4163 @countries @agente3
Feature: Manejo de API paises ejemplos

  Background:
    * def manSysProp = Java.type('com.pichincha.utils.ManegeSystemProperties')

  @id:1 @consultaPais
  Scenario Outline: T-API-PQBP-4163-CA1-Consulta datos por pais <pais>
    Given url 'https://restcountries.com/v3.1/name/ecuador'
    And param fields = 'capital,fifa,startOfWeek,capitalInfo,languages'
    When method GET
    Then status 200

  @id:2 @consultaCapital
  Scenario: T-API-PQBP-4163-CA2-Consulta datos por capital
    Given url 'https://restcountries.com/v3.1/capital/quito'
    When method GET
    Then status 200
```

Recomendación de ejecución:
- Si solo se requiere una prueba, ejecutar por su tag específico (por ejemplo @consultaPais).
- Para pruebas API simples, usar parallel = 1.
- Para ejecuciones más exigentes, usar entre 3 y 5 hilos según capacidad del ambiente.

## 11. Reutilización de código
Se debe reutilizar código mediante funciones, archivos comunes y parametrización para evitar duplicación.

Regla recomendada:
- Preferir Scenario Outline sobre múltiples Scenarios casi iguales.
- Usar Examples para cubrir múltiples datos en una sola definición de escenario.

Ejemplo recomendado:

```gherkin
@TagGeneral
Feature: Creacion de Pruebas de APIs Basicas

  @id:1 @verificarConsulta
  Scenario Outline: Consulta de usuario por ID <data_userid>
    Given path 'https://reqres.in/api/users/<data_userid>'
    When method get
    Then status <data_statusCode>
    And print response

    Examples:
      | data_userid | data_statusCode |
      | 2           | 200             |
      | 23          | 404             |
```

Beneficios:
- Mejora legibilidad.
- Reduce código repetido.
- Permite ampliar cobertura con menor esfuerzo.

## 12. Uso de archivos en Scenario Outline
Cuando el volumen de datos crece, se debe externalizar la data en archivos csv o json.

Ejemplo de archivo CatalogoAgencias.csv:

```csv
businessInformationCode,name
1,PLAZA GRANDE
2,LATACUNGA
15,EL VALLE
20,MERCADO CENTRAL
50,ATAHUALPA IBARRA
123,BALZAR
126,EL QUINCHE
174,ORELLANA
208,ALAUSI
```

Ejemplo de uso en Feature:

```gherkin
@REQ_PQBP-4187
Feature: CatalogoAgencia

  Background:
    * callonce read('AuthBP.feature@AutenticationBP')

  @id:1 @BPAgencias
  Scenario Outline: Consultar agencia por Codigo <businessInformationCode> - <name>
    Given url urlApiBp
    * path 'branch-lists/<businessInformationCode>'
    When method GET
    And print response

    Examples:
      read('classpath:../data/apibp/CatalogoAgencias.csv')
```

Buenas prácticas:
- Mantener archivos de datos versionados junto a las pruebas.
- Nombrar archivos de datos según dominio funcional.
- Separar datos de prueba por ambiente cuando corresponda.
- Evitar tablas gigantes embebidas dentro del feature.

## 13. Calidad de validaciones
Checklist mínimo por escenario:
- Validar código de estado HTTP.
- Validar campos críticos de respuesta.
- Validar contrato básico (tipos/estructura).
- Validar mensajes de error en escenarios negativos.
- Registrar evidencia útil en reportes.

Buenas prácticas:
- Evitar validaciones frágiles de campos no relevantes.
- Priorizar aserciones de negocio sobre detalles accidentales.
- Reutilizar pasos comunes cuando sea posible.

## 14. Reportes y evidencia
- Revisar reportes de Karate y Cucumber generados por Gradle.
- Conservar evidencia cuando una prueba falle.

Buenas prácticas:
- Clasificar fallas: datos, ambiente, script, defecto real.
- Corregir flakes antes de incluir en pipelines críticos.
- Mantener trazabilidad de incidentes y correcciones.

## 15. Tags para integración con Pipeline y Jira
En Banco Pichincha se deben usar tags específicos para la integración automática.

| Tag | Funcionalidad | Uso | Ejemplo |
|---|---|---|---|
| @REQ_ | Vincula escenarios con HU o soporte | Es obligatorio a nivel de Feature y debe incluir el identificador de HU/soporte | @REQ_PQBP-511 |
| @id:n | Crea o valida existencia del test en integración | Se usa a nivel de Scenario o Scenario Outline. Debe numerarse según cantidad de escenarios | @id:1 |
| @TEST_ | Vincula forzosamente con un Test Case existente en Jira | Se usa a nivel de Scenario o Scenario Outline y debe incluir el identificador del test | @TEST_PQBP-514 |

Ejemplo con @REQ_ y @id:

```gherkin
@REQ_PQBP-511
Feature: Ejemplo de uso

  @id:1
  Scenario: Primer Caso

  @id:2
  Scenario: Segundo Caso

  @id:3
  Scenario: Tercer Caso
```

Ejemplo con @REQ_ y @TEST_:

```gherkin
@REQ_PQBP-511
Feature: Ejemplo de uso

  @TEST_PQBP-514
  Scenario: Primer Caso
```

Aclaraciones obligatorias:
- Todos los tags deben estar en una sola línea, inmediatamente sobre el Feature o Scenario.
- @id: y @TEST_ no pueden usarse juntos en un mismo escenario.
- La combinación de tags de cada escenario debe ser unica, sin considerar @id: ni @TEST_.

Recomendaciones para pipeline:
- Ejecutar por tags según etapa (por ejemplo: @smoke, @regression).
- Publicar reportes como artefactos.
- Fallar pipeline ante pruebas críticas fallidas.

Buenas prácticas:
- Evitar suites demasiado largas en PR.
- Separar ejecución rápida (PR) vs completa (nocturna).
- Versionar cambios de pruebas junto con cambios de API.

## 16. Antipatrones a evitar
- Escenarios dependientes entre sí.
- Datos quemados de alto acoplamiento.
- Reintentos para ocultar inestabilidad.
- Validaciones superficiales sin valor funcional.
- Mezclar pruebas manuales y automáticas en el mismo flujo.

## 17. Plantilla rápida de escenario
```gherkin
@REQ_PQBP-511
Feature: Consulta de clientes

  Background:
    * url baseUrl

  @id:1 @smoke @api_clientes
  Scenario: T-API-PQBP-511-CA1-Consultar cliente existente
    Given path '/clientes', '12345'
    When method get
    Then status 200
    And match response.id == '12345'
```

## 18. Recomendaciones adicionales para el equipo
Esta sección complementa los lineamientos técnicos para mejorar la experiencia de uso de Karate y fomentar código limpio, mantenible y eficiente.

Recomendaciones clave:
- Cubrir no solo happy path, también escenarios fallidos, excepciones y validaciones de error.
- Si la HU o solicitud no especifica cobertura negativa, preguntar explícitamente: "Deseas incluir casos negativos/excepciones en esta HU?" antes de diseñar escenarios.
- Al finalizar la ejecución, abrir reportes desde el explorador de archivos para evitar comportamientos inconsistentes al abrir desde IntelliJ con navegadores.
- Escribir todos los tags en una sola línea, nunca uno sobre otro.
- Cada tag debe escribirse sin espacios internos en su identificador (ejemplo válido: @REQ_PQBP-511).
- No exponer claves, API keys ni información sensible en el código.
- Fomentar colaboración continua entre miembros del equipo para enriquecer escenarios y buenas prácticas.
- Revisar y actualizar escenarios de prueba de forma periódica para reflejar cambios de requisitos o del sistema.
- Mantener un registro de errores comunes y sus soluciones para acelerar futuras resoluciones.
- Definir claramente validaciones de datos de entrada antes de automatizar para prevenir fallos en ejecución.

Buenas prácticas operativas sugeridas:
- Incorporar revisiones cruzadas de features antes de subir cambios.
- Mantener una convención de diseño de escenarios compartida por todo el equipo.
- Priorizar estabilidad y trazabilidad antes de ampliar volumen de casos.

## 19. Criterios de salida
Una suite API está lista cuando:
- Todos los escenarios críticos pasan.
- No existen fallos intermitentes sin plan de corrección.
- El reporte es legible y trazable.
- Se puede ejecutar local y en pipeline con el mismo resultado esperado.

---

Documento actualizado con lineamientos de estructura, nomenclatura y tags de integración Banco Pichincha.
