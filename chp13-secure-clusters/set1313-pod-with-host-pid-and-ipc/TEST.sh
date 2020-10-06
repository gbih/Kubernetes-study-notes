#!/bin/bash
. ../../SETUP.sh
FULLPATH=$(pwd)

((i++))

cat <<- "NOTES"
NOTES:
Using the node’s PID and IPC namespaces

Similar to the hostNetwork option are the hostPID and hostIPC pod spec properties. When you set them to true, the pod’s containers will use the node’s PID and IPC namespaces, allowing processes running in the containers to see all the other processes on the node or communicate with them through IPC, respectively.

You’ll remember that pods usually see only their own processes, but if you run this pod and then list the processes from within its container, you’ll see all the processes run- ning on the host node, not only the ones running in the container, as shown in the following listing.

By setting the hostIPC property to true, processes in the pod’s containers can also communicate with all the other processes running on the node, through Inter-Process Communication.
NOTES

enter

value=$(<set1313-1-pod-with-host-pid-and-ipc.yaml)
echo "$value"

enter


value=$(<set1313-2-pod-regular.yaml)
echo "$value"

enter



echo "$i. Deploying the app via StatefulSet"
echo ""

echo "kubectl apply -f $FULLPATH"
kubectl apply -f $FULLPATH --record
#sleep 1
echo ""
echo "kubectl wait --for=condition=Ready ..."
kubectl wait --for=condition=Ready pod/pod-with-host-pid-and-ipc -n=chp13-set1313

echo $HR

((i++))
echo "$i. Check pod and node"
echo ""
echo "kubectl get pods -n=chp13-set1313 -o wide"
kubectl get pods -n=chp13-set1313 -o wide --sort-by=.status.podIP
echo ""
echo "kubectl get node"
kubectl get node
echo ""
echo "kubectl get psp"
kubectl get psp
enter


((i++))
echo "Check processes visible in a pod with hostPID: true"
echo ""
echo "Remember that pods usually see only their own processes."
echo "However, if you run this pod and then list the processes from within its container, you’ll see all the processes running on the host node, not only the ones running in the container."
echo "By setting the hostIPC property to true, processes in the pod’s containers can also communicate with all the other processes running on the node, through Inter-Process Communication."
echo ""

echo "kubectl exec pod-with-host-pid-and-ipc -n=chp13-set1313 ps aux | head -10"
kubectl exec pod-with-host-pid-and-ipc -n=chp13-set1313 ps aux | head -10
echo ""

echo "Test with regular pod:"
echo "kubectl exec pod-regular -n=chp13-set1313 ps aux | head -10"
kubectl exec pod-regular -n=chp13-set1313 ps aux | head -10


enter

echo "kubectl describe pod/pod-with-host-pid-and-ipc -n=chp13-set1313"
kubectl describe pod/pod-with-host-pid-and-ipc -n=chp13-set1313

#enter
echo $HR

((i++))
echo "$i. Clean-up"
echo ""
echo "kubectl delete -f $FULLPATH --now"
kubectl delete -f $FULLPATH --now

