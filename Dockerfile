# Étape 1 : Build de l'application avec Maven
FROM maven:3.8.5-openjdk-17 AS build
COPY . /app
WORKDIR /app
# On génère le fichier .war
RUN mvn clean package -DskipTests

# Étape 2 : Image finale légère pour l'exécution
FROM openjdk:17-jdk-slim
# On récupère le fichier compilé de l'étape précédente
COPY --from=build /app/target/*.war /app/application.war
EXPOSE 8080
# Commande pour lancer l'application
ENTRYPOINT ["java", "-jar", "/app/application.war"]