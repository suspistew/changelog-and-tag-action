FROM alpine:3

RUN apk update && apk add bash git curl

COPY changelog-generator.sh /changelog-generator.sh 
COPY convention /convention
COPY helper /helper

ENTRYPOINT ["/bin/bash", "/changelog-generator.sh"]