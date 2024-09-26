FROM alpine:latest

RUN apk add --update --no-cache bash git

COPY src/ /src

ENTRYPOINT ["bash", "/src/main.sh"]
