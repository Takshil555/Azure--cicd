# ==========================================
# Stage 1: Build
# ==========================================
FROM maven:3.9.9-eclipse-temurin-25 AS builder

WORKDIR /app

# Copy Maven configuration
COPY pom.xml .

# Download dependencies
RUN mvn dependency:go-offline -B || true

# Copy source code
COPY src ./src

# Build application
RUN mvn clean package -DskipTests


# ==========================================
# Stage 2: Runtime
# ==========================================
FROM eclipse-temurin:25-jre-alpine

WORKDIR /app

# Create non-root user
RUN addgroup -S appgroup && \
    adduser -S appuser -G appgroup

# Copy JAR from build stage
COPY --from=builder /app/target/*.jar app.jar

# Set ownership
RUN chown -R appuser:appgroup /app

# Run as non-root user
USER appuser

# Application port
EXPOSE 8091

# Start application
ENTRYPOINT [
    "java",
    "-XX:+UseContainerSupport",
    "-XX:MaxRAMPercentage=75.0",
    "-jar",
    "app.jar"
]