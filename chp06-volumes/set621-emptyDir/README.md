# Chapter 6, Section 6.2.1

### Objective

### Notes
- emptyDir are meant for temporary working disk space.

- The volume's lifetime is tied to that of the pod, so the volume's contents are lost when the pod is deleted.

- All containers in a Pod have read/write access to the same emptyDir - if they requested a mount point for it.

- Containers can access the emptyDir using the same or different mount points.

- Some uses for an emptyDir are:
  1. Scratch space, such as for a disk-based merge sort
  2. Checkpointing a long computation for recovery from crashes
  3. Holding files that a content-manager Container fetches while a webserver Container serves the data
