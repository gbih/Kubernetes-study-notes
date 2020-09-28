# Chapter 4, Section 4.1.2, Creating a Dockerfile for the image

### Objectives
1. Build Go script with Dockerfile (multi-build process with Go and Scratch base images)
2. Push to DockerHub
3. Pull from DockerHub

---

## Go script

Create Go script as `main.go`:

```
package main

import (
  "fmt"
  "log"
  "net/http"
  "os"
)

var requestCount int = 0

func handler(w http.ResponseWriter, r *http.Request) {
  fmt.Println("Received request from:", r.RemoteAddr)

  name, err := os.Hostname()
  if err != nil {
    log.Fatal(err)
  }

  requestCount++
  if requestCount > 5 {
    w.WriteHeader(http.StatusInternalServerError) // 500 status
    w.Write([]byte("I'm not well. Please restart me!\n"))
    return
  }

  w.WriteHeader(http.StatusOK) // 200 status
  fmt.Fprintf(w, "You've hit %v\n", name)
}

func main() {
  http.HandleFunc("/", handler)
  fmt.Println("Kubia server starting...")
  log.Fatal(http.ListenAndServe(":8080", nil))
}
```

Create Go module

```
go mod init github.com/gbih/k8s-study/kubia-unhealthy
```

Create Dockerfile using Scratch base image

```
# MULTISTAGE BUILD
# Step 1: Build executable binary
# Base image
FROM golang:1.15.2-alpine AS build

WORKDIR /src/

# Copy Go code from current dir
COPY main.go go.* /src/

# Tell Docker how to build Go binary
# CGO_ENABLED=0: provide statically linked binary
RUN CGO_ENABLED=0 go build -o /bin/app

# Step 2: Build a small image using scratch
# Use empty container image
FROM scratch

# Copy the static executable
COPY --from=build /bin/app /bin/app

# Run the binary
ENTRYPOINT ["/bin/app"]
```

Build Docker image and tag as `kubia-unhealthy`

```
docker build -t kubia-unhealthy .
```

Run
```
docker run --name kubia-container -p 8080:8080 -d kubia-unhealthy
```

Test via curl:
```
curl localhost:8080
```

Edit Go source code, then rebuild:
```
docker image build -t kubia-unhealthy .
```

## Pushing the image to an image registry (default is DockerHub)
```
docker tag kubia-unhealthy georgebaptista/kubia-unhealthy
docker push georgebaptista/kubia-unhealthy
# If initial log-in to DockerHub:
docker login --username georgebaptista --password XXXXXXXXXXXXXXX)
```

## Clean-up

```
docker container stop kubia-container
docker rm kubia-container
docker rmi kubia-unhealthy
docker image prune
```

