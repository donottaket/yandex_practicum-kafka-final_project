FROM gradle:8.14.3-jdk24 AS build
WORKDIR /workspace

COPY settings.gradle build.gradle gradle/ ./
RUN gradle --no-daemon -g /home/gradle/.gradle dependencies || true

COPY src ./src

RUN gradle --no-daemon -g /home/gradle/.gradle clean bootJar -x test

FROM eclipse-temurin:24-jre-alpine AS runtime
ENV APP_HOME=/app
WORKDIR $APP_HOME

RUN apk add --no-cache libstdc++ libgcc

COPY --from=build /workspace/build/libs/*.jar ./app.jar

ENTRYPOINT ["sh","-c","java $JAVA_OPTS -jar app.jar"]