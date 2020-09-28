# Chapter 6, Section 6.6.3

### Objective
1. Explore Dynamic provisioning of PersistentVolumes 

### Notes
- For dynamic provisioning, we don't explicitly specify which storage class to use. In turn, the default storage class (fast)will be used to dynamically provision a PersistentVolume.

- After a user create a PVC, a PV is created by the Storage Class provisioner

- If we want the PVC to be bound to a pre-provisioned PV,
use this setting to prevent the dynamic provisioner from interfering
`storageClassName: ""`

### Setup

```
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: mongodb-pvc-default
  namespace: chp06-set663
  labels:
    app: mongodb-pvc-default
spec:
  resources:
    requests:
      storage: 100Mi
  accessModes:
  - ReadWriteOnce # single client, RW
```
