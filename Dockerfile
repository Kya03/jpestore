# Étape 1 : Build avec Maven
FROM maven:3.8.5-openjdk-17 AS build
COPY . /app
WORKDIR /app
RUN mvn clean package -DskipTests

# Étape 2 : Exécution avec Java (Image stable et maintenue)
FROM eclipse-temurin:17-jre-alpine
# On récupère le fichier .war
COPY --from=build /app/target/*.war /app/application.war
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "/app/application.war"]
