# Chapter 6, Section 6.6.1

### Objective
1. Explore Dynamic provisioning of PersistentVolumes 

### Set-up
- To enable dynamic provisioning of PersistentVolumes in microk8s, we need to setup the `storage` add-on.

- We can create a default storage class which allocates storage from a host directory via:

```
microk8s enable storage
```

- To list the StorageCLasses in your cluster:
```
kubectl get sc
```

Next, an admin will need to create one or more StorageClass resources, before a user can create a PVC. This specifies which provisioner should be used for provisioning the PV when a PVC requests this StorageClass. Here we use the provisioner microk8s.io/hostpath.

```
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: fast
  # StorageClass aren't namespaced
  labels:
    app: mongodb-pvc
# volume plugin to use for provisioning the PV
provisioner: microk8s.io/hostpath
parameters:
  # parameters passed to the provisioner
  type: ps-ssd
```




### Notes
- This is perhaps the most powerful method of obtaining persistent storage in Kubernetes.

- Instead of pre-provisioning a bunch of PersistentVolumes, you can instead define one or two (or more) StorageClasses and let the system create a new PersistentVolume each time one is requested through a PersistentVolumeClaim.
