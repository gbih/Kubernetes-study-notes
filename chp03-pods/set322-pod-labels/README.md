# Chapter 3, Section 3.2.2

### Objective
1. Labels and Selectors
2. Namespaces

### Notes

1. We are still creating pods without any reference to the PodSecurityPolicy, Roles, RoleBindings, etc. 

2. When creating a service object, the spec.selector must match the label key:value in the corresponding pod or object,

```
apiVersion: v1
kind: Service
metadata:
  name: kubia
  namespace: chp03-set322
spec:
  selector:
    # match corresponding pods with label `creation_method: manual`
    creation_method: manual
  ports:
  - port: 8080
    protocol: TCP
    targetPort: 8080
  type: NodePort
```

and matching pod description,

```
apiVersion: v1
kind: Pod
metadata:
  name: kubia-manual
  namespace: chp03-set322
  labels:
    creation_method: manual
spec:
  containers:
  - image: georgebaptista/kubia
    name: kubia
    ports:
    - containerPort: 8080
      protocol: TCP
```

3. To assign a label to a node, first list possible nodes:
```
kubectl get nodes --show-labels
```

Add the label as a key=value pairing:
```
kubectl label nodes actionbook-vm gpu=true
```

To remove the nodel label, append a `-` after the key:
```
kubectl label nodes actionbook-vm gpu-
```

4. Using port-forwarding hangs the bash script, so use a Service object with NodePort for now.
