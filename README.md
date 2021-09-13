## Ejecuto por comando para armar el arquetipo
```sh
mvn archetype:generate \
-DarchetypeGroupId=com.intuit.karate \
-DarchetypeArtifactId=karate-archetype \
-DarchetypeVersion=1.1.0 \
-DgroupId=com.template \
-DartifactId=karate-api
```

## Configuro el reporte de cucumber (Opcional)

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


## Trabajo con el Runner en Java
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

Creo la funcion para generar el reporte

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



