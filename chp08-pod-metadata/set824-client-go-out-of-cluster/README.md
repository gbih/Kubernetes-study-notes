# Chapter 8, Section 8.2.4

### Objective

### Notes

# Authenticating outside the cluster
- https://github.com/kubernetes/client-go
- https://github.com/kubernetes/client-go/tree/master/examples/out-of-cluster-client-configuration

## Setup and create Go program
Create main.go
- https://github.com/kubernetes/client-go/blob/master/examples/out-of-cluster-client-configuration/main.go

`go mod init github.com/gbih/client-go-outside`

Need to download this dependency:
`go get github.com/googleapis/gnostic@v0.5.1`

`go get k8s.io/client-go@v0.19.0`

(edit main.go)


## Build 
`go build -o bin/app .`


## Run
When you run `./bin/app`, it looks for kubeconfig, so we have to specify the microk8s location:
./bin/app -kubeconfig /var/snap/microk8s/current/credentials/client.config


Running this application will use the kubeconfig file and then authenticate to the cluster, and print the number of pods in the cluster every 10 seconds:

```
./app
There are 3 pods in the cluster
There are 3 pods in the cluster
There are 3 pods in the cluster
```

