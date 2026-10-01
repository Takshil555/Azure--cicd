# ==========================================
# Stage 1: Build Stage
# ==========================================
FROM maven:3-eclipse-temurin-25 AS builder

WORKDIR /build

# Copy pom.xml and download dependencies for layer caching
COPY pom.xml .
RUN mvn dependency:go-offline -B || true

# Copy source code and build the application artifact
COPY src ./src
RUN mvn clean package -DskipTests

# ==========================================
# Stage 2: Runtime Stage
# ==========================================
FROM eclipse-temurin:25-jre

# Set metadata
LABEL maintainer="Nebula Team" \
      application="api-gateway" \
      version="prod"

WORKDIR /app

# Create a dedicated non-root user and group
RUN groupadd -r spring && useradd -r -g spring spring

# Copy compiled JAR file from builder stage
COPY --from=builder /build/target/*.jar /app/app.jar

# Adjust ownership
RUN chown -R spring:spring /app

# Switch to non-root user
USER spring:spring

# Expose Spring Cloud Gateway port
EXPOSE 8091

# Configure JVM flags optimized for containers
ENV JAVA_OPTS="-XX:+UseContainerSupport -XX:MaxRAMPercentage=75.0 -Djava.security.egd=file:/dev/./urandom"

# Launch Spring Boot API Gateway application
ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar /app/app.jar"]
