# Chapter 5, Section 5.3.2

### Objective
1. Explore LoadBalancer service

### Notes
* K8s clusters running on cloud providers usually support the automatic provision of a load balancer from the cloud infrastructure. 

* All you need to do is set the service's type to LoadBalancer instead of NodePort.

* The load balancer will have its own unique, publicly accessible IP address, and will redirect all connections to your service.

* You can thus access your service through the load balancer's IP address.

* If K8s is running in an environment that doesn't support LoadBalancer services, the load balancer will not be provisioned, but the service will still behave like a NodePort service.

* This is because a LoadBalancer service is an extension of a NodePort service. 


### Turning on LoadBalancer service in microk8s
```
microk8s status
microk8s.enable metallb
[Enter each IP address range delimited by comma]: 10.64.140.43-10.64.140.49,192.168.0.105-192.168.0.111
microk8s status
```

### MetalLB Notes
The LoadBalancer implementation we use for microk8s is MetalLB,
https://metallb.universe.tf/
Kubernetes does not offer an implementation of network load-balancers (Services of type LoadBalancer) for bare metal clusters. The implementations of Network LB that Kubernetes does ship with are all glue code that calls out to various IaaS platforms (GCP, AWS, Azure…). If you’re not running on a supported IaaS platform (GCP, AWS, Azure…), LoadBalancers will remain in the pending state indefinitely when created.
Bare metal cluster operators are left with two lesser tools to bring user traffic into their clusters, NodePort and externalIPs services. Both of these options have significant downsides for production use, which makes bare metal clusters second class citizens in the Kubernetes ecosystem.
MetalLB aims to redress this imbalance by offering a Network LB implementation that integrates with standard network equipment, so that external services on bare metal clusters also just work as much as possible.


### Creating a LoadBalancer service

kubia-svc-loadbalancer.yaml
```
apiVersion: v1
kind: Service
metadata:
  name: kubia-loadbalancer
spec:
  type: LoadBalancer
  ports:
    - port: 80
      targetPort: 8080
  selector:
    app: kubia
```

* The service type is set to LoadBalancer instead of NodePort.

* We are not specifying a specific node port, although we could.
