# Chapter 7, Section 7.3.1, Building fortune container image with Alpine

### Objectives
1. Build script with Dockerfile with minimal Alpine base image (6MB Alpine vs 70MB Ubuntu)
2. Push to DockerHub
3. Pull from DockerHub

---

## Bash Script

1. The Alpine base image does not have bash, so we have to use sh instead.
2. The install location of fortune will be in `/usr/bin/fortune` in Alpine.
3. apk is the install manager for Alpine.
4. Enable the interval configurable through env var
5. Leave out the $INTERVAL variable in bash script


Create sh script as `fortuneloop.sh`

```
#!/bin/sh
trap "exit" SIGINT
echo Configured to generate new fortune every $INTERVAL seconds
mkdir /var/htdocs
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
```

## Build Docker image, tag as fortune:env, push to image registry 
```
docker build -t georgebaptista/fortune:env .
docker push georgebaptista/fortune:env

# If initial log-in to DockerHub:
docker login --username georgebaptista --password XXXXXXXXXXXXXXX)
```
