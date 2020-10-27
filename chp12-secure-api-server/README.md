# Study Notes for Kubernetes In Action, v1
## Chapter 12

### Objectives
- Work through securing the API server via RBAC, ServiceAccounts, Roles, RoleBindings

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
