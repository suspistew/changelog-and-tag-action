FROM alpine
COPY changelog-generator.sh /changelog-generator.sh

RUN apk update && apk add bash git curl jq

ENTRYPOINT ["/changelog-generator.sh"]