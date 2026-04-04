# Step 1: Build the application
FROM maven:3.9.6-eclipse-temurin-17 AS builder
WORKDIR /app

# Copy Maven files and source code
COPY pom.xml .
COPY src ./src
COPY .mvn .mvn
COPY mvnw .

# Give execute permission to mvnw
RUN chmod +x mvnw

# Build the Spring Boot application without tests
RUN ./mvnw clean package -DskipTests

# Step 2: Run the application
FROM eclipse-temurin:17-jdk
WORKDIR /app

# Copy the built jar from the builder stage
COPY --from=builder /app/target/*.jar app.jar

# Expose a port (Render uses dynamic port)
EXPOSE 10000
ENV PORT 10000

# Run Spring Boot on Render's assigned port
ENTRYPOINT ["java","-Dserver.port=$PORT","-jar","app.jar"]
