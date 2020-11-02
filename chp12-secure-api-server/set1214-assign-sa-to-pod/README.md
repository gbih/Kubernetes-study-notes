# 12.1.4 Assigning a ServiceAccount to a pod

### Objective

### Notes
* This script will not work anymore when the RBAC-plugin is enabled on the cluster.

Using ServiceAccounts
* ServiceAccounts are a way for an application running inside a pod to authenticate itself with the API server.
* Applications do that by passing the ServiceAccount's token in the request.

* You can assign a ServiceAccount to a pod by specifying the account's name in the pod manifest.
* If you don’t assign it explicitly, the pod will use the default ServiceAccount in the namespace.
