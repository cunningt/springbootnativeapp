# Spring Boot Native Application

A Spring Boot application compiled to a native executable using GraalVM Native Image and Spring AOT (Ahead-of-Time compilation). This demonstrates the dramatic performance improvements achievable with native compilation.

## Overview

This project showcases:
- Spring Boot 3.5.7 with native image support
- Apache Camel and Camel Spring Boot 4.14.2 integration
- Native executable generation with GraalVM

## Prerequisites

- **Java 21** or later
- **Maven 3.x**
- **GraalVM** (for native compilation)

### Environment Setup

Configure the required environment variables for GraalVM:

```bash
export GRAAL_21_HOME=/Library/Java/JavaVirtualMachines/graalvm-21.jdk/Contents/Home/
export GRAAL_HOME=${GRAAL_21_HOME}
export JAVA_HOME=${GRAAL_21_HOME}
export PATH=$JAVA_HOME/bin:$PATH
```

**Note:** Adjust the `GRAAL_21_HOME` path to match your GraalVM installation location.


## Building the Application

### Step 1: AOT Compilation and Packaging

Build the Spring application and invoke the AOT engine:

```bash
mvn clean compile spring-boot:process-aot package
```

This command:
- Compiles the application
- Processes the application with Spring's AOT engine
- Packages the application for native compilation

For more details, see the [Spring Boot AOT Maven Plugin documentation](https://docs.spring.io/spring-boot/maven-plugin/aot.html).

### Step 2: Generate Reflection Hints (Optional)

Generate reflection metadata for GraalVM native image compilation. This step uses the native-image-agent to capture runtime reflection usage and create configuration files.

You can use the included `generate.sh` script or run the command directly:

```bash
java -Dspring.aot.enabled=true \
  -agentlib:native-image-agent=config-merge-dir=./src/main/resources/META-INF/native-image/ \
  -jar target/my-camel-springboot-app-1.0.0-SNAPSHOT.jar
```

This command:
- Runs the application with the native-image-agent attached
- Captures reflection, JNI, and resource usage during runtime
- Generates JSON configuration files in `src/main/resources/META-INF/native-image/`
- Merges with existing configuration if present

For more details, see:
- [Spring Boot Native Image documentation](https://docs.spring.io/spring-boot/docs/3.2.2/reference/html/native-image.html)
- [GraalVM Reflection documentation](https://www.graalvm.org/jdk21/reference-manual/native-image/dynamic-features/Reflection/)

### Step 3: Native Binary Compilation

Compile the application to a native executable:

```bash
mvn native:compile-no-fork
```

Upon successful completion, you will have a native executable at:
```
target/my-camel-springboot-app
```

## Running the Application

Execute the native binary:

```bash
./target/my-camel-springboot-app
```

## Performance

**Startup Time: 0.088 seconds** (88 milliseconds)

The native executable demonstrates exceptional startup performance compared to traditional JVM-based Spring Boot applications.

<details>
<summary>Sample Startup Output</summary>

```
  .   ____          _            __ _ _
 /\\ / ___'_ __ _ _(_)_ __  __ _ \ \ \ \
( ( )\___ | '_ | '_| | '_ \/ _` | \ \ \ \
 \\/  ___)| |_)| | | | | || (_| |  ) ) ) )
  '  |____| .__|_| |_|_| |_\__, | / / / /
 =========|_|==============|___/=/_/_/_/

 :: Spring Boot ::                (v3.5.7)

2025-11-04T17:03:49.899-05:00  INFO 11247 --- [           main] com.example.MySpringBootApplication      : Starting AOT-processed MySpringBootApplication using Java 21.0.9
2025-11-04T17:03:49.971-05:00  INFO 11247 --- [           main] o.s.b.w.embedded.tomcat.TomcatWebServer  : Tomcat started on port 8080 (http) with context path '/'
2025-11-04T17:03:49.979-05:00  INFO 11247 --- [           main] o.a.c.impl.engine.AbstractCamelContext   : Apache Camel 4.14.2 (MyCamel) started in 7ms
2025-11-04T17:03:49.979-05:00  INFO 11247 --- [           main] com.example.MySpringBootApplication      : Started MySpringBootApplication in 0.088 seconds (process running for 0.095)
Hello World
Hello World
```

</details>

### Step 4 : Build a native image

In order to build a native image :

`mvn -Pnative spring-boot:build-image`

There are a number of options you can set to change the amount of memory used to build the image, the JVM version used, and JMX options.    See https://github.com/paketo-buildpacks/bellsoft-liberica for more details.

Building native images seems quite memory intensive on the container engine that you use for building the image, so make sure to allocate enough memory to your Docker or Podman Engine.