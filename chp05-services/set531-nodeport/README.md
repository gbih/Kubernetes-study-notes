# 5.3.1 Using a NodePort service

### Objective
1. Explore NodePort service

### Notes
- Remember that NodePort is not a load balancer.

- By creating a NodePort service, Kubernetes reserves a port on all its nodes
(the same port number is used across all of them), and it forwards incoming
connections to the pods that are part of the service.
