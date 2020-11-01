# 18.1.2 Automating custom resources with custom controllers

### Objective

### Notes
- This image is outdated:
https://github.com/luksa/k8s-website-controller
and needs to be updated, otherwise it will not work!

- Creating service imperatively:
```
kubectl expose deployment.apps/website-controller  --name kubia-http --dry-run=client -o yaml -n=chp18-set1812 --port=80
```

### Reference

https://kubernetes.io/docs/concepts/extend-kubernetes/api-extension/custom-resources/#authentication-authorization-and-auditing

> Authentication, authorization, and auditing

> CRDs always use the same authentication, authorization, and audit logging as the built-in resources of your API server.

> If you use RBAC for authorization, most RBAC roles will not grant access to the new resources (except the cluster-admin role or any role created with wildcard rules). You'll need to explicitly grant access to the new resources. CRDs and Aggregated APIs often come bundled with new role definitions for the types they add.

> Aggregated API servers may or may not use the same authentication, authorization, and auditing as the primary API server.

So, we can grant access to our CRD via this ClusterRole:

```
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: clusterrole-psp
rules:
- apiGroups: ["extensions.example.com"] # CRD apiGroup, required
  resources: ["websites"]
  verbs: ["*"]

- apiGroups: [""]
  resources: ["pods", "services"]
  verbs: ["get", "list", "create"]

- apiGroups: ["extensions", "apps"]
  resources: ["deployments"]
  verbs: ["get", "list", "watch", "create", "update", "patch", "delete"]

- apiGroups: ["policy"]
  resourceNames: ["restricted"]
  resources: ["podsecuritypolicies"]
  verbs: ["use"]
```
