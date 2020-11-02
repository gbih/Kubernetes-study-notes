# 12.2.3 Using Roles and RoleBindings

### Objective

### Notes
- Need to make sure RBAC is enabled in your cluster.

- With microk8s, we can use this service via 'add-ons':
```
microk8s status
microk8s enable rbac
microk8s status
``` 

This will essentially block scripts from chapter 1-11 from working, however.
To disable rbac so we can again run these earlier scripts, run:
```
microk8s disable rbac
```

In this chapter, we still do not need to use any admission plugins or pod-security-policies.

