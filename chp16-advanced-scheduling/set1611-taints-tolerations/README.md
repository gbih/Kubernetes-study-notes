# 16.1.1 Introducing taints and tolerations

### Objective
- Display a node's taints
- Display a pod's tolerations
- Understanding taint effects

### Notes

- UNDERSTANDING TAINT EFFECTS, p.460
> Each taint has an effect associated with it. Three possible effects exist:
>  1. NoSchedule, which means pods won't be scheduled to the node if they don't tolerate the taint.
>  2. PreferNoSchedule is a soft version of NoSchedule, meaning the scheduler will try to avoid scheduling the pod to the node, but will schedule it to the node if it can't schedule it somewhere else.
>  3. NoExecute, unlike NoSchedule and PreferNoSchedule that only affect scheduling, also affects pods already running on the node. If you add a NoExecute taint to a node, pods that are already running on that node and don't tolerate the NoExecute taint will be evicted from the node.
