FROM eclipse-temurin:17-jdk-focal AS builder 

WORKDIR /app

ARG RESOURCE_VERSION=3.5
ARG GRASSCUTTER_VERSION=1.4.7

RUN apt-get update && apt-get install git -y --no-install-recommends

ADD https://github.com/Grasscutters/Grasscutter/raw/development/keystore.p12 .

RUN git clone https://gitlab.com/YuukiPS/GC-Resources --branch ${RESOURCE_VERSION}
RUN mv ./GC-Resources/Resources ./resources && mv ./GC-Resources/Tool ./tool && rm -rf ./GC-Resources

ADD https://github.com/Grasscutters/Grasscutter/releases/download/v${GRASSCUTTER_VERSION}/grasscutter-${GRASSCUTTER_VERSION}.jar grasscutter.jar
RUN timeout 5s java -jar grasscutter.jar; ls config.json
RUN sed -i 's/localhost/mongodb_grasscutter/g' config.json
RUN sed -i 's/enableConsole": true/enableConsole": false/g' config.json

FROM eclipse-temurin:17-jre-focal

WORKDIR /app

EXPOSE 80/udp
EXPOSE 80/tcp
EXPOSE 443/udp
EXPOSE 443/tcp
EXPOSE 8888/udp
EXPOSE 8888/tcp
EXPOSE 22102/udp
EXPOSE 22102/tcp

COPY --from=builder /app /app

ENTRYPOINT ["java", "-jar", "grasscutter.jar"]
