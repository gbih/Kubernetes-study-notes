https://www.chaseadams.io/posts/install-dig-and-nslookup-linux/
dig and nslookup are in bind-tools on Alpine:

FROM alpine:latest
RUN apk update && apk --no-cache add curl

docker build -t georgebaptista/curl .
docker push georgebaptista/curl

