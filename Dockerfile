FROM maven:3.9-eclipse-temurin-21 AS builder
WORKDIR /build

ENV MAVEN_OPTS="-Xmx512m -XX:MaxMetaspaceSize=256m"

COPY pom.xml ./
COPY src/ ./src/
RUN mvn clean package -DskipTests -B -T 1

FROM eclipse-temurin:21-jre
WORKDIR /app
COPY --from=builder /build/target/polybot-railway-*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-Xmx256m", "-XX:+UseSerialGC", "-Djava.security.egd=file:/dev/./urandom", "-jar", "app.jar", "--spring.profiles.active=railway"]
