# Chapter 4, Section 4.4.2

### Objective
1. Explore DaemonSets

### Notes

- Use a DaemonSet to run a pod on every node.

- Relevant node label commands:
```
kubectl get nodes --show-labels
kubectl label nodes actionbook-vm disk=ssd
kubectl get nodes -l disk=ssd --show-labels
kubectl label nodes actionbook-vm disk-
```

- Corresponding DaemonSet pod template node selector:
```
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: ssd-monitor
  namespace: chp04-set442
spec:
  selector:
    matchLabels:
      app: ssd-monitor
  template:
    metadata:
      labels:
        app: ssd-monitor
    spec:
      nodeSelector:
        disk: ssd
      containers:
      - name: main
        image: luksa/ssd-monitor
```
