# Chapter 8, Section 8.2.4

### Objective

### Notes
Authenticating inside the cluster
https://github.com/kubernetes/client-go
https://github.com/kubernetes/client-go/tree/master/examples/in-cluster-client-configuration


# Authenticating inside the cluster
https://github.com/kubernetes/client-go
https://github.com/kubernetes/client-go/tree/master/examples/in-cluster-client-configuration

## Setup and create Go program
Create main.go

`go mod init github.com/gbih/client-go`

`go get k8s.io/client-go@v0.19.0`

(edit main.go)


## Build and push container to Docker Hub
`GOOS=linux go build -o ./bin/app .`

`docker build -t georgebaptista/client-go-auth-inside:v1 .`

`docker push georgebaptista/client-go-auth-inside:v1`


## Run via docker

`kubectl run --rm -i demo --image=georgebaptista/client-go-auth-inside:v1 --image-pull-policy Always`

or

`kubectl run -i --tty demo --image=georgebaptista/client-go-auth-inside:v1 --restart=Never --image-pull-policy Always -- sh`

## Clean up
`kubectl delete pod demo`
