FROM alpine:latest

RUN apk add --update --no-cache bash curl git

COPY src/ /src

ENTRYPOINT ["bash", "/src/main.sh"]
