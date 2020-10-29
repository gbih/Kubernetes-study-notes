# Study Notes for Kubernetes In Action, v1
## Chapter 12

### Objectives

### Notes

https://kubernetes.io/docs/reference/access-authn-authz/rbac/#service-account-permissions
> ServiceAccount permissions

> Default RBAC policies grant scoped permissions to control-plane components, nodes, and controllers, but grant no permissions to service accounts outside the kube-system namespace (beyond discovery permissions given to all authenticated users).

> This allows you to grant particular roles to particular ServiceAccounts as needed. Fine-grained role bindings provide greater security, but require more effort to administrate. Broader grants can give unnecessary (and potentially escalating) API access to ServiceAccounts, but are easier to administrate.

---

https://unofficial-kubernetes.readthedocs.io/en/latest/admin/authorization/rbac/
