# Chapter 7, Section 7.2.2, Building fortune container image with Alpine

### Objectives
1. Build script with Dockerfile with minimal Alpine base image (6MB Alpine vs 70MB Ubuntu)
2. Push to DockerHub
3. Pull from DockerHub

---

## Bash Script

1. The Alpine base image does not have bash, so we have to use sh instead.
2. The install location of fortune will be in `/usr/bin/fortune` in Alpine.
3. apk is the install manager for Alpine.
4. Configure script with INTERVAL configurable through argument.


Create sh script as `fortuneloop.sh`

```
#!/bin/sh
trap "exit" SIGINT
INTERVAL=$1
echo Configured to generate new fortune every $INTERVAL seconds
mkdir -p /var/htdocs
while :
do
  echo $(date) Writing fortune to /var/htdocs/index.html
  /usr/bin/fortune > /var/htdocs/index.html
  sleep $INTERVAL
done
```

Create Dockerfile using Alpine base image
- We use Alpine Linux package management, apk, for any installs on Alpine.

```
FROM alpine:latest
MAINTAINER George Baptista <george@omame.com>
ADD fortuneloop.sh /bin/fortuneloop.sh
RUN apk --update add --no-cache fortune && chmod +x /bin/fortuneloop.sh
ENTRYPOINT ["/bin/fortuneloop.sh"]
CMD ["10"]
```

## Build image, tag as fortune:args, push to image registry
docker build -t georgebaptista/fortune:args .
docker push georgebaptista/fortune:args

# If initial log-in to DockerHub:
docker login --username georgebaptista --password XXXXXXXXXXXXXXX)
```

Test this Alpine image by running it locally
```
docker run --rm georgebaptista/fortune:args
```

We can now override the default sleep interval by passing it as an argument:
```
docker run --rm georgebaptista/fortune:args 1
```

