FROM maven:3.9-eclipse-temurin-21 AS builder
WORKDIR /build

COPY pom.xml ./
COPY polybot-core/pom.xml ./polybot-core/pom.xml
COPY strategy-service/pom.xml ./strategy-service/pom.xml

# Strip unused modules from pom.xml so Maven doesn't fail on missing modules
RUN sed -i '/<module>analytics-service/,/<\/module>/d' pom.xml && \
    sed -i '/<module>ingestor-service/,/<\/module>/d' pom.xml && \
    sed -i '/<module>infrastructure-orchestrator-service/,/<\/module>/d' pom.xml

# Cache Maven dependencies
RUN mvn dependency:go-offline -pl strategy-service -am -B -q 2>/dev/null || true

# Build
COPY polybot-core/ ./polybot-core/
COPY strategy-service/ ./strategy-service/
RUN mvn clean package -DskipTests -pl strategy-service -am -B -q

FROM eclipse-temurin:21-jre
WORKDIR /app
COPY --from=builder /build/strategy-service/target/strategy-service-*.jar app.jar
EXPOSE 8081
ENTRYPOINT ["java", "-Xmx256m", "-XX:+UseSerialGC", "-Djava.security.egd=file:/dev/./urandom", "-jar", "app.jar", "--spring.profiles.active=railway"]
