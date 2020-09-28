# Chapter 6, Section 6.5.2

### Objective
1. Explore PersistentVolume

### Notes
- To enable apps to request storage in a Kubernetes cluster without having to deal with infrastructure specifics, two new resources were introduced. They are PersistentVolumes and PersistentVolumeClaims.

- We use PersistentVolumes to decouple pods from the underlying storage technology.

- Here we create a PersistentVolume backed by a hostPath.

- PersistentVolumes don't belong to any namespace. They're cluster-level resources like nodes.

