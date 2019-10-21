FROM alpine
COPY changelog-generator.sh /changelog-generator.sh 
ADD convention /convention
ADD helper /helper

RUN apk update && apk add bash git curl jq

ENTRYPOINT ["/bin/bash", "/changelog-generator.sh"]

