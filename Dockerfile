# Stage 1: Build stage
FROM maven:3.9.9-eclipse-temurin-25 AS builder

WORKDIR /app

COPY pom.xml .

RUN mvn dependency:go-offline -B || true

COPY src ./src

RUN mvn clean package -DskipTests


# Stage 2: Runtime stage
FROM eclipse-temurin:25-jre-alpine

WORKDIR /app

RUN addgroup -S appgroup && \
    adduser -S appuser -G appgroup

COPY --from=builder /app/target/*.jar app.jar

RUN chown -R appuser:appgroup /app

USER appuser

EXPOSE 8091

ENTRYPOINT ["java", "-XX:+UseContainerSupport", "-XX:MaxRAMPercentage=75.0", "-jar", "app.jar"]