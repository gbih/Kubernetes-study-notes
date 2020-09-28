# Study Notes for Kubernetes In Action, v1
## Chapter 6

### Objectives
- Learn how pod containers can access external disk storage and/or share storage between them.

### Set-up
- When working with microk8s, we can create a default storage class which allocates storage from a host directory:

```
microk8s enable storage
```

- To list the StorageCLasses in your cluster:
```
kubectl get sc
```

### Notes
- Each container in a pod has its own isolated filesystem, because the file-system comes from the container's image.

- Volume types

  1. emptyDir - simple empty dir used for storing transient data

  2. hostPath - used for mounting dirs from the worker node's filesystem into a pod

  3. gitRepo - volume initialized by checking out the contents of a Git repo (deprecated)

  4. nfs - an NFS share mounted into the pod.

  5. gcePersistentDisk, awsElasticBlockStore, azureDisk - used for mounting cloud provider-specific storage.

  6. cinder, cephfs, iscsi, flocker, glusterfs, quobyte, rbd, flexVolume, vsphereVolume, photonPersistentDisk, scaleIO - used for mounting other types of network storage.

  7. configMap, secret, downwardAPI - special types of volumes used to expose certain K8s resources and cluster information to the pod. These aren't really used for storing data, but for exposing K8s metadata to apps running in the pod.

  8. persistentVolumeClaim - a way to use a pre- or dynamically provisioned persistent storage.
