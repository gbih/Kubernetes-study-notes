# Chapter 4, Section 4.2.2

### Objective
1. Explore replication controllers

### Notes

- Using replication controllers directly is somewhat outdated, should use deployments instead.

- A ReplicationController has 3 essential parts:
  1. label selector, determining what pods are in the RC's scope
  2. replica count, specifying the desired number of pods to run
  3. pod template, used when creating new pod replicas

- Only changes to replica count affect existing pods.

- Unfortunately, rollout status is not implemented for replicationcontroller, as we get this error:
```
kubectl rollout status replicationcontroller kubia -n=chp04-set422

error: no status viewer has been implemented for ReplicationController
```
