# Build stage using a Maven container
FROM maven:3.6.2-jdk-8 AS builder
WORKDIR /app

# Copy the project files into the container
COPY target /app

# Runtime stage using an Eclipse Temurin base image
FROM eclipse-temurin:11-jre as runtime

WORKDIR /app

# Copy only the built artifact from the build stage
COPY --from=builder /app/toxictypoapp-1.0-SNAPSHOT.jar ./toxictypoapp.jar

# Expose port 8080 for the application
EXPOSE 8083
# Use entrypoint for running the application
ENTRYPOINT ["java", "-jar", "toxictypoapp.jar"]