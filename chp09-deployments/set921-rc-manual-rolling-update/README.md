# 9.2.1 Running the initial version of the app

### Objectives
1. Manually update ReplicationController without deprecated `rolling-update` command

### Notes
- https://kubernetes.io/docs/concepts/workloads/controllers/replicationcontroller/#rolling-updates

- https://github.com/kubernetes/kubernetes/issues/1353

- Rolling updates

- The ReplicationController is designed to facilitate rolling updates to a service by replacing pods one-by-one.

- As explained in #1353, the recommended approach is to create a new ReplicationController with 1 replica, scale the new (+1) and old (-1) controllers one by one, and then delete the old controller after it reaches 0 replicas. This predictably updates the set of pods regardless of unexpected failures.

- Ideally, the rolling update controller would take application readiness into account, and would ensure that a sufficient number of pods were productively serving at any given time.

- The two ReplicationControllers would need to create pods with at least one differentiating label, such as the image tag of the primary container of the pod, since it is typically image updates that motivate rolling updates.
