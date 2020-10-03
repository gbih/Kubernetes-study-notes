# Chapter 10, Section 10.3.0

### Objective

### Notes
- One of the more conceptually complex topics in Kubernetes

- Key to StatefulSets: Stateful set creates pods and pvc at the same time

- The StatefulSet has to create the PersistentVolumeClaims as well, the same way it’s cre- ating the pods. For this reason, a StatefulSet can also have one or more volume claim templates, which enable it to stamp out PersistentVolumeClaims along with each pod instance.

- A StatefulSet must guarantee at-most-one semantics for stateful pod instances.

- Especially do not forcibly delete pods in StatefulSets with `--force --grace-period=0` 



# Use HereDoc as a hack for multi-line comments in Bash
# https://linuxize.com/post/bash-comments/
<< 'COMMENT'
echo "kubectl delete -f $FULLPATH -now"
kubectl delete -f $FULLPATH --now
echo $HR
COMMENT

- We cannnot communicate direct with the pods through the Service creates because it is a headless service.
Instead, we need to connect to individual pods directly.
Or, we could create a regular Service, but this wouldn't allow talking to a specific pod.
We can connect to pods directly in different ways:
1. Using port-forwarding
2. Piggyback on another pod and running curl inside
3. Using the API server as a proxy to the pods

Method 2
Piggyback on another pod and running curl inside:


- cat <<- "NOTES"
This seems to be the way to set up PV on microk8s:

microk8s.enable storage

You can then confirm:

> microk8s.kubectl get sc
NAME                          PROVISIONER            AGE
microk8s-hostpath (default)   microk8s.io/hostpath   62s

NOTES
