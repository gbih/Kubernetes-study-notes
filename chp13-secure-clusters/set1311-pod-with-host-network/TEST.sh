#!/bin/bash
. ~/src/common/setup.sh
FULLPATH=$(pwd)

((i++))

cat <<- "NOTES"
NOTES:
* Using the host node's namespaces in a pod

---
GB SETUP NOTES
If we are using a PSP, make sure we don't have multiple PSP's around that conflict with each other!
---

Containers in a pod usually run under separate Linux namespaces, which isolate their processes from processes running in other containers or in the node's default namespaces.

For example, we learned that each pod gets its own IP and port space, because it uses its own network namespace. Likewise, each pod has its own process tree, because it has its own PID namespace, and it also uses its own IPC namespace, allowing only processes in the same pod to communicate with each other through the Inter-Process Communication mechanism (IPC).


** Using the node's network namespace in a pod

Certain pods (usually system pods) need to operate in the host's default namespaces, allowing them to see and manipulate node-level resources and devices. For example, a pod may need to use the node’s network adapters instead of its own virtual network adapters. This can be achieved by setting the hostNetwork property in the pod spec to true.

In that case, the pod gets to use the node's network interfaces instead of having its own set, as shown in figure 13.1. This means the pod doesn’t get its own IP address and if it runs a process that binds to a port, the process will be bound to the node’s port.
NOTES

enter

value=$(<set1311-1-pod-with-host-network.yaml)
echo "$value"

enter

echo "Check environment"
echo ""

echo "kubectl version --short"
kubectl version --short
echo ""

echo "cat /var/snap/microk8s/current/args/kube-apiserver"
echo ""
cat /var/snap/microk8s/current/args/kube-apiserver
echo "" 
echo "See more options here: https://kubernetes.io/docs/reference/command-line-tools-reference/kube-apiserver/"

enter

echo "$i. Deploying the app"
echo ""


echo "kubectl apply -f $FULLPATH/PSP"
kubectl apply -f $FULLPATH/PSP
echo ""

echo "kubectl apply -f $FULLPATH"
kubectl apply -f $FULLPATH --record
sleep 1
echo ""
echo "kubectl wait --for=condition=Ready ..."
#kubectl wait --for=condition=Ready pod/pod-with-host-network -n=chp13-set1311
#kubectl wait --for=condition=Ready pod/pod2-with-host-network -n=chp13-set1311
#kubectl wait --for=condition=Ready pod/pod-regular -n=chp13-set1311
#kubectl wait --for=condition=Ready pod/pod2-regular -n=chp13-set1311

enter

((i++))
echo "$i. Compare pods using host network vs regular pods"
echo ""
echo "kubectl get pods -n=chp13-set1311 -o wide"
kubectl get pods -n=chp13-set1311 -o wide --sort-by=.status.podIP
echo ""

echo "Check if there is any PSP enabled"
echo "kubectl get psp"
kubectl get psp

enter


((i++))
echo "$i. Check that the pod is using the host's network network namespace"
echo ""
echo "kubectl exec pod-with-host-network -n=chp13-set1311 ifconfig"
echo ""
kubectl exec pod-with-host-network -n=chp13-set1311 ifconfig

#enter
echo $HR

((i++))
echo "$i. Clean-up"
echo ""
kubectl delete -f $FULLPATH
kubectl delete -f $FULLPATH/PSP
