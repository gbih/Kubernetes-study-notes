# 6.5.3 Claiming a PersistentVolume by creating a PersistentVolumeClaim

### Objective
1. Explore PersistentClaim

### Notes
- In order to use a PersistentVolume, we have to claim it first, via PersistentVolumeClaim.

- Claiming a PersistentVolume is a completely separate process from creating a pod, because we want the same PersistentVolumeClaim to stay available even if the pod is rescheduled.

- Here we are not actually using either the PV or PVC with a pod yet. We are just exploring the relationship between a PV and PVC.

