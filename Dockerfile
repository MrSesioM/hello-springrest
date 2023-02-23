FROM gradle:alpine AS build
WORKDIR /usr/src/app
COPY . .
RUN gradle build

FROM amazoncorretto:11-alpine
WORKDIR /usr/src/app
COPY --from=build /usr/src/app/build/libs/rest-service-0.0.1-SNAPSHOT.jar .
EXPOSE 8080
CMD ["java","-jar","rest-service-0.0.1-SNAPSHOT.jar"]
LABEL org.opencontainers.image.source https://github.com/MrSesioM/hello-springrest
