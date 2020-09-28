# Chapter 6, Section 6.2.1, Building fortune container image with Alpine

### Objectives
1. Build script with Dockerfile with minimal Alpine base image (6MB Alpine vs 70MB Ubuntu)
2. Push to DockerHub
3. Pull from DockerHub

---

## Bash Script

1. The Alpine base image does not have bash, so we have to use sh instead.
2. The install location of fortune will be in `/usr/bin/fortune` in Alpine.
3. apk is the install manager for Alpine.


Create sh script as `fortuneloop.sh`

```
#!/bin/sh
trap "exit" SIGINT
mkdir /var/htdocs
while :
do
  echo $(date) Writing fortune to /var/htdocs/index.html
  /usr/bin/fortune > /var/htdocs/index.html
  sleep 10
done
```

Create Dockerfile using Alpine base image
- We use Alpine Linux package management, apk, for any installs on Alpine.

```
FROM alpine:latest
ADD fortuneloop.sh /bin/fortuneloop.sh
RUN apk --update add --no-cache fortune && chmod +x /bin/fortuneloop.sh
ENTRYPOINT /bin/fortuneloop.sh
```

Build Docker image and tag as `fortune`

```
docker build -t fortune .
```

## Pushing the image to an image registry (default is DockerHub)
```
docker tag fortune georgebaptista/fortune
docker push georgebaptista/fortune
# If initial log-in to DockerHub:
docker login --username georgebaptista --password XXXXXXXXXXXXXXX)
```

Test this Alpine image by running it locally
```
docker run --rm --name fortune -it fortune
```

In another terminal, run fortune
```
Docker exec -it fortune fortune
```

Or, we can log in and explore the file directories
```
docker exec -it fortune sh
```
