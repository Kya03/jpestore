# Étape 1 : Build avec Maven (on utilise une version plus récente pour éviter le bug Cgroup)
FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /app

# On profite du cache Docker pour les dépendances
COPY pom.xml .
RUN mvn dependency:go-offline

# On copie le reste et on build
COPY . .
RUN mvn clean package -DskipTests

# Étape 2 : Runtime sécurisé (Utilisateur non-root)
FROM eclipse-temurin:17-jre-alpine
WORKDIR /app

# Création de l'utilisateur de sécurité (comme dans ton flashback !)
RUN addgroup -S jpetgroup && adduser -S jpetuser -G jpetgroup

# On récupère le fichier compilé et on change le propriétaire
COPY --from=build --chown=jpetuser:jpetuser /app/target/*.war /app/application.war

# On passe sur l'utilisateur non-privilégié
USER jpetuser

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "/app/application.war"]
