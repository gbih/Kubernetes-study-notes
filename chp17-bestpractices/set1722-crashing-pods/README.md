# 17.2.2 Rescheduling of dead or partially dead pods

### Objective

### Notes
If a pod's container keeps crashing, the Kubelet will keep restarting it indefinitely.
Such pods are not automatically removed and rescheduled, even if they are part of a ReplicaSet.
The RS Controller doesn't care if the pod is dead -- all it cares about is the number of pods match the desired replica count.
