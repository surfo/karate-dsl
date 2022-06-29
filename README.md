
## Karate DSL

![figra1](https://user-images.githubusercontent.com/55904664/133254434-434f31e3-b86c-453a-89cd-61e4db90948d.jpg) 

### DSL(Lenguaje de dominio específico)

Un Lenguaje de dominio específico es un lenguaje de programación con un nivel superior de abstracción optimizado para una clase específica de problemas.

Karate se apoya en la sintaxis Gherkin para escribir sus escenarios.

#### Estructura Gherkin
- Feature: Especifica una funcionalidad del sistema
- Scenario: El comportamiento individual para establecer los criterios de aceptación (Se representarían los casos de pruebas de una funcionalidad)

Para describir los escenarios se utilizan las sentencias de Gherkin: Given, When, Then, And y But

#### Patrón del lenguaje Gherkin
- Given 'dado': Cumplo una precondición
- When 'cuando': Ejecuto una acción
- Then 'entonces': Observo el resultado esperado, las validaciones a realizar

```cucumber
Feature: Extracción de dinero

    Scenario: Como usuario existente y habilitado del cajero,
              quiero realizar una extracción de dinero
        Given Me autentique con una tarjeta habilitada
        And El saldo disponible en mi cuenta es positivo
        When Selecciono la opción de extracción
        And Ingreso la cantidad menor o igual al saldo disponible
        Then Obtengo el dinero
        And El dinero que obtuve se resta del saldo disponible de mi cuenta
```

Ejemplo de un feature Karate (con Json nativo)

```cucumber
Feature: simple requests

    Scenario: hago un echo
        Given url 'https://httpbin.org/anything'
        * configure ssl = true
        And request { myKey: 'Hola' }
        When method post
        Then status 200
        And match response contains { json: { myKey: 'Hola' } }
```

También se utilizan Scenarios Outline, son un tipo de escenario donde se especifican datos de entrada.

```cucumber
Scenario Outline: Extraer dinero con distintas claves de tarjeta.
    Given La tarjeta de crédito está habilitada
    And El saldo disponible en mi cuenta es positivo
    And El cajero tiene suficiente dinero
    When Introduzco la tarjeta en el cajero
    And Ingreso el <pin> de la tarjeta 

Examples: 
| pin  | 
| 1234 | 
| 9876 | 
```

Ejemplo de un Scenario Outline Karate

```cucumber
Scenario Outline: simple sequence desde tabla
    Given url 'https://httpbin.org/anything'
    And configure ssl = true
    And request { myKey: "<data_Input>" }
    When method post
    Then status 200
    And match response contains { json: { myKey: "<data_Output>" } }

Examples:
| data_Input    | data_Output   |
| Buen dia      | Buen dia      |
| Buenas tardes | Buenas tardes |
| Buenas noches | Buenas noches |
```

### Características

- No se requiere conocimiento de Java.
- Es compatible de forma nativa con Json y XML.
- Los datos de los Scenarios se puede leer desde la sección Examples del mismo Scenario, Archivo Json o XML.
- Validaciones en una sola linea.
- Validaciones de esquema Json para validar estructuras.
- Motor JavaScript incorporado que permite crear bibliotecas de funciones reutilizables.
- Informe de pruebas integrado y de fácil lectura

### Validaciones Java vs Json

Java
```java
Cat billie = new Cat();
billie.SetName("Billie");
Cat bob = new Cat();
bob.setId(23);
bob.SetName("Bob");
billie.addKitten(bob);
Cat wild = new Cat();
wild.setId(42);
wild.setName("Wild");
billie.addKitten(wild);


private static boolean hasKitten(Cat cat, Cat Kitten){
    if (cat.getKittens() != null) {
        for (Cat kit : cat.getkittens()) {
            if (kit.getId()) == null) {
                if (kit.getName() == null) {
                    if (kitten.getName() == null) {
                        return true;
                    }
                } else if (kit.getName().equals(kitten.getName())) {
                    return true;
                }
            }
        }
    }
    return false;
}
```
Karate Json
```cucumber
Scenario: Pruebo Json
    Given def cat = 
    """
        {
            name: 'Billie',
            kittens: [
                {id: 23, name: 'Bob'},
                {id: 42, name: 'Wild'}
            ]
        }
    """

* match cat.kittens[*].id == [23,42]
* match cat.kittens[*].id contains 23
* match each cat.kittens == { id: '#notnull', name: '#regex [A-Z][a-z]+'}
```

Karate SOAP XML
```cucumber
Scenario: Pruebo XML
    Given def foo = 
    """
    <records>
        <record index="1">a</record>
        <record index="2">b</record>
        <record index="3" foo="bar">c</record>
    </records>
    """
# json Style
* assert foo.records.record.length == 3

# xpath assertions
* match foo count(/records//record) == 3
* match foo //record[@index=2] == 'b'
* match foo //record[@foo='bar'] == 'c'
```


## Empezando

### Feature: Automatizar API's

### Scenario: framework [Karate DSL](https://github.com/intuit/karate)

### Given Ejecuto comando bash para utilizar el arquetipo de Karate Maven

### Para Linux
```sh
mvn archetype:generate \
-DarchetypeGroupId=com.intuit.karate \
-DarchetypeArtifactId=karate-archetype \
-DarchetypeVersion=1.2.0 \
-DgroupId=com.mycompany \
-DartifactId=myproject
```

### Para Windows
```sh
mvn archetype:generate -DarchetypeGroupId=com.intuit.karate -DarchetypeArtifactId=karate-archetype -DarchetypeVersion=1.2.0 -DgroupId=com.mycompany -DartifactId=myproject
```

### And Configuro el reporte de cucumber

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


### And modifico el Runner en Java
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

### When corro el test 
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

### Version Standalone

El único requisito previo es que Java (solo el entorno de tiempo de ejecución y no el JDK completo) debe estar instalado.

Para probar, escriba esto en una ventana de terminal o consola:
```sh
java --version
```
Si responde con una versión 1.8 o superior (Java versión 8), ¡ya está todo listo!

Buscar la última versión [aqui](https://github.com/karatelabs/karate/releases) desplácese hacia abajo para encontrar "Activos". Y busque el archivo que comienza con karate-y tiene una *.zip extensión

### Instalación
Simplemente extraer el ZIP a cualquier directorio.

### Descargar e instalar visual Studio Code [aqui](https://code.visualstudio.com/Download)

Instalar los plugins de:
- Cucumber (Gherkin) full support
- Karate Runner
- Java Extension Pack


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
