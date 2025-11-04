#!/bin/sh
java -Dspring.aot.enabled=true -agentlib:native-image-agent=config-merge-dir=./src/main/resources/META-INF/native-image/ -jar target/my-camel-springboot-app-1.0.0-SNAPSHOT.jar
