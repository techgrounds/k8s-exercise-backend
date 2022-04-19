### Build ###
FROM maven:3.8.5-openjdk-8-slim as build
WORKDIR /workspace

COPY app/pom.xml .
RUN --mount=type=cache,target=/root/.m2 mvn -B -e -C -T 1C org.apache.maven.plugins:maven-dependency-plugin:3.1.2:go-offline

COPY app/mvnw .
COPY app/src src

RUN mvn clean install -DskipTests -B

### Image assembly
FROM openjdk:8-jre-alpine

RUN addgroup -S spring && adduser -S spring -G spring
USER spring:spring

VOLUME /tmp

COPY --from=build /workspace/target/*.jar app.jar

EXPOSE 8080
ENTRYPOINT ["java","-jar","app.jar"]
