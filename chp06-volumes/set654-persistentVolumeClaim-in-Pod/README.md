# 6.5.4 Using a PersistentVolumeClaim in a pod

### Objective
1. Explore PersistentVolumeClaim in a pod

### Notes
- To use a PV inside a pod, we have to reference the PVC by name inside the pod's volume.

```
piVersion: v1
kind: Pod
metadata:
  name: mongodb
  namespace: chp06-set654
  labels:
    app: mongodb
    env: dev
spec:
  containers:
  - image: mongo
    name: mongodb
    volumeMounts:
    - name: mongodb-data
      mountPath: /data/db
    ports:
    - containerPort: 27017
      protocol: TCP
  volumes:
  - name: mongodb-data
    persistentVolumeClaim:
      # reference to PVC name
      claimName: mongodb-pvc
```

- Selected result from `kubectl describe pod/mongodb -n=chp06-set654`

```
Name:         mongodb
Namespace:    chp06-set654
...
Containers:
  mongodb:
    Mounts:
      /data/db from mongodb-data (rw)
      /var/run/secrets/kubernetes.io/serviceaccount from default-token-527lp (ro)
...
Volumes:
  mongodb-data:
    Type:       PersistentVolumeClaim (a reference to a PersistentVolumeClaim in the same namespace)
    ClaimName:  mongodb-pvc
    ReadOnly:   false
```
