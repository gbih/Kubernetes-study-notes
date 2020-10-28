# Study Notes for Kubernetes In Action, v1
## Chapter 12

### Objectives
- Work through securing the API server when making component-based client requests, via RBAC.

## Notes

- Up to now, we used kubectl as the main way to access the Kubernetes API. It is essentially a client CLI for human users that enables syntactic shortcuts, both in terms of making requests and in the received output. However, the underlying mechanism is still about making standard REST API calls to endpoints. To understand the usefulness of RBAC, it's useful to think more at this lower-level, and to see the client as other pods or components. 

- To help see things more "lower-level", use the --v=6 tag when making `kubectl get ..` requests in order to see the actual HTTP request being made / REST API endpoint being requested. Understanding that endpoint helps in understanding what specific role/binding you will need to adjust for the RBAC plugin. That is a big part of understanding RBAC.

- The principle of 'least privilege' is the way to approach RBAC adjustments. In general it is easier to go from more to less. Get the component working first, then gradually lock it down. 

- There are only 60 or so Kubernetes API resources, so it's useful to learn the various RBAC combinations for all of them. 


## Reference

- Authenticating
https://kubernetes.io/docs/reference/access-authn-authz/authentication/

Table 12.2 When to use specific combinations of role and binding types

| For accessing                                                                                        | Role type to use | Binding type to use |
|------------------------------------------------------------------------------------------------------|------------------|---------------------|
| Cluster-level resources (Nodes, PersistentVolumes, ...)                                              | ClusterRole      | ClusterRoleBinding  |
| Non-resource URLs (/api, /healthz, ...)                                                              | ClusterRole      | ClusterRoleBinding  |
| Namespaced resources in any namespace (and across all namespaces)                                    | ClusterRole      | ClusterRoleBinding  |
| Namespaced resources in a specific namespace (reus- ing the same ClusterRole in multiple namespaces) | ClusterRole      | RoleBinding         |
| Namespaced resources in a specific namespace (Role must be defined in each namespace)                | Role             | RoleBinding         |
