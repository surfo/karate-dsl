
## Karate DSL

![figra1](https://user-images.githubusercontent.com/55904664/133254434-434f31e3-b86c-453a-89cd-61e4db90948d.jpg) 

### DSL(Lenguaje de dominio específico)

Un Lenguaje de dominio específico es un lenguaje de programación con un nivel superior de abstracción optimizado para una clase específica de problemas.

Karate se apoya en la sintaxis Gherkin para escribir sus escenarios.

Patron del lenguaje Gherkin
- Given 'dado': Cumplo una precondiciòn
- When 'cuando': Ejecuto una acciòn
- Then 'entonces': Observo el resultado esperado, las validaciones a realizar

```cucumber
Feature: Extracciòn de dinero

    Scenario: Como usuario existente y habilitado del cajero,
              quiero realizar una extracciòn de dinero
    Given Me autentiquè con una tarjeta habilitada
    And El saldo disponible en mi cuenta es positivo
    When Selecciono la opcion de extracciòn
    And Ingreso la cantidad menor o igual al saldo disponible
    Then Obtengo el dinero
    And El dinero que obtuve se resta del saldo disponible de mi cuenta
```






## Feature: Automatizar API's

## Scenario: framework [Karate DSL](https://github.com/intuit/karate)

## Given Ejecuto comando bash para utilizar el arquetipo de Karate Maven

```sh
mvn archetype:generate \
-DarchetypeGroupId=com.intuit.karate \
-DarchetypeArtifactId=karate-archetype \
-DarchetypeVersion=1.1.0 \
-DgroupId=com.template \
-DartifactId=karate-api
```

## And Configuro el reporte de cucumber

Cargo en el POM el cucumber-reporting
Ingreso en el Maven central para verificar ultima version
https://mvnrepository.com/
Busco cucumber Reporting

```xml
<!-- https://mvnrepository.com/artifact/net.masterthought/cucumber-reporting -->
<dependency>
    <groupId>net.masterthought</groupId>
    <artifactId>cucumber-reporting</artifactId>
    <version>5.6.0</version>
</dependency>
```


## And modifico el Runner en Java
Descomento la linea para habilitar la creacion del Json para que lo use el reporte de cucumber
```java
//.outputCucumberJson(true)
```
Agrego debajo

```java
.karateEnv("Reporte Nombre")
```

Importaciòn

```java
import java.io.File;
import java.util.Collection;
import org.apache.commons.io.FileUtils;
import java.util.List;
import java.util.ArrayList;
import net.masterthought.cucumber.Configuration;
import net.masterthought.cucumber.ReportBuilder;
```

Creo la funciòn para generar el reporte

```java
public static void generateReport(String karateOutputPath) {
    Collection<File> jsonFiles = FileUtils.listFiles(new File(karateOutputPath), new String[] {"json"}, true);
    List<String> jsonPaths = new ArrayList<>(jsonFiles.size());
    jsonFiles.forEach(file -> jsonPaths.add(file.getAbsolutePath()));
    Configuration config = new Configuration(new File("target"), "Reporte Nomber");
    ReportBuilder reportBuilder = new ReportBuilder(jsonPaths, config);
    reportBuilder.generateReports();
}
```

## When corro el test 
```sh
sh:~/path/karate-api$ mvn test
```

```sh
[INFO] Scanning for projects...
[INFO] 
[INFO] ----------------------< com.template:karate-api >-----------------------
[INFO] Building karate-api 1.0.0
[INFO] --------------------------------[ jar ]---------------------------------
[INFO] 
[INFO] --- maven-resources-plugin:2.6:resources (default-resources) @ karate-api ---
[INFO] Using 'UTF-8' encoding to copy filtered resources.
[INFO] skip non existing resourceDirectory /home/surfo/Practicas/Automatizacion/karate/docker/karate-api/src/main/resources
[INFO] 
[INFO] --- maven-compiler-plugin:3.8.1:compile (default-compile) @ karate-api ---
[INFO] No sources to compile
[INFO] 
[INFO] --- maven-resources-plugin:2.6:testResources (default-testResources) @ karate-api ---
[INFO] Using 'UTF-8' encoding to copy filtered resources.
[INFO] Copying 3 resources
[INFO] 
[INFO] --- maven-compiler-plugin:3.8.1:testCompile (default-testCompile) @ karate-api ---
[INFO] Nothing to compile - all classes are up to date
[INFO] 
[INFO] --- maven-surefire-plugin:2.22.2:test (default-test) @ karate-api ---
[INFO] 
[INFO] -------------------------------------------------------
[INFO]  T E S T S
[INFO] -------------------------------------------------------
[INFO] Running examples.ExamplesTest
```

```sh
======================================================
elapsed:   7,98 | threads:    5 | thread time: 4,63 
features:     1 | skipped:    0 | efficiency: 0,12
scenarios:    2 | passed:     2 | failed: 0
======================================================
```

## Then obtengo el reporte cucumber

![figra2](https://user-images.githubusercontent.com/55904664/133254422-6c3b9ad8-55bd-46e4-8dd9-abf380eb3387.png) 

## Version Standalone

El único requisito previo es que Java (solo el entorno de tiempo de ejecución y no el JDK completo) debe estar instalado.

Para probar, escriba esto en una ventana de terminal o consola:
```sh
java --version
```
Si responde con una versión 1.8 o superior (Java versión 8), ¡ya está todo listo!

Buscar la última versión [aqui](https://github.com/karatelabs/karate/releases) desplácese hacia abajo para encontrar "Activos". Y busque el archivo que comienza con karate-y tiene una *.zip extensión

### Instalación
Simplemente extraer el ZIP a cualquier directorio.

### Correr un script

Puede ejecutar comandos desde el terminal o la consola después de cambiar a la raíz de la carpeta creada cuando extrajo el archivo ZIP. 

Ejecutar todo menos el tag
java -jar karate.jar -t ~@ignore .



Ejecutar un tag especifico
java -jar karate.jar -t @tag .



Ejecutar mas de un tag
java -jar karate.jar -t @regression,@test .

Ejecutar en un ambiente especifico
java -jar karate.jar -e desa .
