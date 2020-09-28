# Study Notes for Kubernetes In Action, v1
## Chapter 5: Services

### Objectives
- Work through the mechanisms and details of Services, one of the most important elements in Kubernets.

### Notes
- There are essentially 2 mechanisms around Kubernetes Services:
  1. Proxying
  2. Discovery

- Kubernetes Services provide a single, constant IP address to a pod, or group of pods.

- In Service yaml, no containerPort is used, since this is not a container.

- The primary purpose of services is exposing groups of pods to other pods in the cluster.

- Services are also used to expose pods externally.

- `kubectl exec` allows you to remote run arbitrary commands inside an existing container of a pod. Conversely, containers built upon the Scratch image do not allow this functionality.

- Kubernetes services don't operate at the HTTP level. Services deal with TCP and UDP packages and don't care about the payload they carry. Because cookies are a construct of the HTTP protocol, services don't know about them. If you want to use session-like functionality, we need Ingress for HTTP level service.

- Endpoints are a separate resource and not an attribute of a service.

- The LoadBalancer service is an extension of a NodePort service.

- If K8s is running in an environment that doesn't support LoadBalancer services, the load balancer will not be provisioned, but the service will still behave like a NodePort service.

- Kubernetes does not offer an implementation of network load-balancers (Services of type LoadBalancer) for bare metal clusters. Bare metal cluster operators are left with two lesser tools to bring user traffic into their clusters, “NodePort” and “externalIPs” services. Both of these options have significant downsides for production use, which makes bare metal clusters second class citizens in the Kubernetes ecosystem. MetalLB aims to redress this imbalance by offering a Network LB implementation that integrates with standard network equipment, so that external services on bare metal clusters also “just work” as much as possible.
https://metallb.universe.tf/

- Role of Ingresses
  1. Each LoadBalancer service requires its own load balancer with its own public IP address. However, an Ingress service only requires one load balancer, even when providing access to dozens of services.
  2. When a client sends an HTTP request to the Ingress, the host and path in the request determine which service the request is forwarded to.
  3. Multiple services can be exposed through a single Ingress.
  4. Ingresses operate at the application layer of the network stack (HTTP) and can provide features such as cookie-based session affinity and the like, which services cannot.
  5. To make Ingress resources work, an Ingress Controller needs to be running in the cluster.





