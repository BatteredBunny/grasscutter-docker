FROM openjdk:19 AS builder 
WORKDIR /app
RUN microdnf install git
ADD https://github.com/Grasscutters/Grasscutter/raw/development/keystore.p12 .
RUN git clone https://git.crepe.moe/tamilpp25/Grasscutter_Resources.git && mv ./Grasscutter_Resources/Resources ./resources && rm -rf ./Grasscutter_Resources
ADD https://github.com/Grasscutters/Grasscutter/releases/download/v1.4.3/grasscutter-1.4.3.jar grasscutter.jar
RUN java -jar grasscutter.jar -handbook -gachamap; sed -i 's/localhost/mongodb_grasscutter/g' config.json; sed -i 's/enableConsole": true/enableConsole": false/g' config.json

FROM openjdk:19
WORKDIR /app
#VOLUME [ "/app" ]

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
