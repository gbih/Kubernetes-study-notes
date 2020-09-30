https://www.chaseadams.io/posts/install-dig-and-nslookup-linux/
dig and nslookup are in bind-tools on Alpine:

FROM alpine:latest
RUN apk --update && apk add bind-tools

docker build -t georgebaptista/dnsutils . 
docker push georgebaptista/dnsutils


