FROM alpine:latest
MAINTAINER George Baptista <george@omame.com>
ADD fortuneloop.sh /bin/fortuneloop.sh
RUN apk --update add --no-cache fortune && chmod +x /bin/fortuneloop.sh
ENTRYPOINT /bin/fortuneloop.sh
