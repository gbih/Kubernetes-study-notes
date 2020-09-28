# Chapter 2, Section 2.13, Creating a Dockerfile for the image

### Objectives
1. Build Node script with Dockerfile (Node base image)
2. Push to DockerHub
3. Pull from DockerHub

---

Create Node script as `app.js`:

```js script
const http = require('http');
const os = require('os');

console.log("Kubia server starting...");

var handler = function(request, response) {
  console.log("Received request from " + request.connection.remoteAddress);
  response.writeHead(200);
  response.end("You've hit " + os.hostname() + "\n");
};

var www = http.createServer(handler);
www.listen(8080);
```

Create `Dockerfile`

```
FROM node:7
ADD app.js /app.js
ENTRYPOINT ["node", "app.js"]
```

Build Docker image and tag as `kubia`

```
docker build -t kubia .
```

Check images 

```
docker images
```

Create new container named `kubia-container` from the `kubia` image.\
The container will be detached from the local console via -d flag.\
Port 8080 on the local machine will be mapped to port 8080 inside the container.
```
docker run --name kubia-container -p 8080:8080 -d kubia
```

Check via curl (inside the multipass instance)
```
curl localhost:8080
```

Check docker properties, stop, delete
```
docker ps
docker inspect kubia-container
docker stop kubia-container
docker start kubia-container
docker rm kubia-container
docker rmi kubia
docker images prune
```

## Pushing the image to an image registry (default is DockerHub)
```
docker tag kubia username/kubia
docker login --username XXXXXXXXXX --password XXXXXXXXXXXXXXX
docker push georgebaptista/kubia

```
