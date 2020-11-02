# 6.2.1 Using a Persistent Disk in a pod volume (hostPath volume in multipass

### Objective
1. Explore Persistent Disk

### Notes
- Persistent Disk is really network-attached storage.

- Persistent Disk is a bit low-level in nature.

- A hostPath volume mounts a file or directory from the host node's filesystem into your Pod.
This allows us to access files on the worker node's filesystem.
This is not something that most Pods will need, but it offers a powerful escape hatch for some applications.

- Some uses for a hostPath are:
  1. Running a Container that needs access to Docker internals; use a hostPath of /var/lib/docker
  2. Running cAdvisor in a Container; use a hostPath of /sys
  3. Allowing a Pod to specify whether a given hostPath should exist prior to the Pod running, whether it should be created, and what it should exist as.

- On the Kubernetes node the mountPath is /tmp/mongodb, and in the container the mountPath is /data/db
