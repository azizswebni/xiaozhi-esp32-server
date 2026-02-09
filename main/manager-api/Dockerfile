# Multi-stage build for Spring Boot application

# Stage 1: Build
FROM maven:3.9-eclipse-temurin-21-alpine AS builder

WORKDIR /app

# Copy pom.xml first for dependency caching
COPY pom.xml .

# Download dependencies (cached layer)
RUN mvn dependency:go-offline -B

# Copy source code
COPY src ./src

# Build the application
RUN mvn clean package -DskipTests -B

# Stage 2: Runtime
FROM eclipse-temurin:21-jre-alpine

# Add non-root user for security
RUN addgroup -g 1000 xiaozhi && \
    adduser -u 1000 -G xiaozhi -s /bin/sh -D xiaozhi

WORKDIR /app

# Copy JAR from builder
COPY --from=builder /app/target/xiaozhi-esp32-api.jar app.jar

# Create directories for uploads and logs
RUN mkdir -p /uploadfile /app/logs && \
    chown -R xiaozhi:xiaozhi /app /uploadfile

# Switch to non-root user
USER xiaozhi

# Expose port
EXPOSE 8002

# JVM options for container environment
ENV JAVA_OPTS="-XX:+UseContainerSupport -XX:MaxRAMPercentage=75.0 -Djava.security.egd=file:/dev/./urandom"

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD wget --no-verbose --tries=1 --spider http://localhost:8002/actuator/health || exit 1

# Run the application
ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar app.jar"]
