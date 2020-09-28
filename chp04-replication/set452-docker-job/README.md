# Chapter 4, Section 4.5.2

### Objectives
1. Explore batch files

---

## Dockerfile

Create Dockerfile using Scratch base image

```
FROM busybox
ENTRYPOINT echo "$(date) Batch job starting"; sleep 3; echo "$(date) Finished succesfully"
```

### Build image


Build Docker image and tag as `batch-job`

```
docker build -t batch-job .
```


### Pushing the image to an image registry (default is DockerHub)
```
docker tag batch-job georgebaptista/batch-job
docker push georgebaptista/batch-job
# If initial log-in to DockerHub:
docker login --username georgebaptista --password XXXXXXXXXXXXXXX)
```

### Clean-up

```
docker rmi batch-job
docker image prune
```

