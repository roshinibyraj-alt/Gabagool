FROM maven:3.9-eclipse-temurin-21 AS builder
WORKDIR /build

ENV MAVEN_OPTS="-Xmx512m -XX:MaxMetaspaceSize=256m"

COPY pom.xml ./
COPY polybot-core/pom.xml ./polybot-core/pom.xml
COPY strategy-service/pom.xml ./strategy-service/pom.xml

# Strip unused modules from pom.xml so Maven doesn't fail
RUN sed -i '/<module>analytics-service/,/<\/module>/d' pom.xml && \
    sed -i '/<module>ingestor-service/,/<\/module>/d' pom.xml && \
    sed -i '/<module>infrastructure-orchestrator-service/,/<\/module>/d' pom.xml

# Copy source and build
COPY polybot-core/ ./polybot-core/
COPY strategy-service/ ./strategy-service/
RUN mvn clean package -DskipTests -pl strategy-service -am -B -T 1

FROM eclipse-temurin:21-jre
WORKDIR /app
COPY --from=builder /build/strategy-service/target/strategy-service-*.jar app.jar
EXPOSE 8081
ENTRYPOINT ["java", "-Xmx256m", "-XX:+UseSerialGC", "-Djava.security.egd=file:/dev/./urandom", "-jar", "app.jar", "--spring.profiles.active=railway"]
