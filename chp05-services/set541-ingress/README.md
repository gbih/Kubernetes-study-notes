# Chapter 5, Section 5.4.1

### Objective
1. Explore Ingress

### Notes
- ingress syntax changes
  1. Deprecated
    `kubectl get ingress`
  2. New
    `kubectl get ingress.networking.k8s.io`

- An Ingress only requires one load balancer, as opposed to a LoadBalancer service.
When a client sends an HTTP request to the Ingress, the host and path in the request determine which service is forwarded to.
Ingresses operate at the application layer of the network stack (HTTP) and can provide features such as cookie-based session affinity, etc, which services cannot.

Note that the Ingress is akin to a wrapper on top of another service, such as NodePort.
We cannot use the Ingress by itself, in other words.
Also, an Ingress controller needs to be running in the cluster.


### Automatic Setup

Turning on Ingress service in microk8s
```
microk8s status
microk8s enable ingress
microk8s status
```


### Manual Setup

Installing Ingress-Nginx manually

1. Setup prerequisite:
https://kubernetes.github.io/ingress-nginx/deploy/#prerequisite-generic-deployment-command
```
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/nginx-0.30.0/deploy/static/mandatory.yaml
```

2. Provider Specific Steps
Cloud Provider (GCE-GKE, Docker for Mac):
```
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/nginx-0.30.0/deploy/static/provider/cloud-generic.yaml
```

Bare-metal (using NodePort):
```
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/nginx-0.30.0/deploy/static/provider/baremetal/service-nodeport.yaml
```

Verify installation:
```
kubectl get pods --all-namespaces -l app.kubernetes.io/name=ingress-nginx
```

Detect installed version:
```
POD_NAMESPACE=ingress-nginx
POD_NAME=$(kubectl get pods -n $POD_NAMESPACE -l app.kubernetes.io/name=ingress-nginx -o jsonpath='{.items[0].metadata.name}')
kubectl exec -it $POD_NAME -n $POD_NAMESPACE -- /nginx-ingress-controller --version
```

