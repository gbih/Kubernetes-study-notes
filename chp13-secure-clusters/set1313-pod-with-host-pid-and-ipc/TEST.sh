#!/bin/bash
. ~/src/common/setup.sh
FULLPATH=$(pwd)

echo "kubectl apply -f $FULLPATH"
kubectl apply -f $FULLPATH --record
#sleep 1
echo ""
echo "kubectl wait --for=condition=Ready ..."
kubectl wait --for=condition=Ready pod/pod-with-host-pid-and-ipc -n=chp13-set1313

enter

((i++))

value=$(<set1313-1-pod-with-host-pid-and-ipc.yaml)
echo "$value"
echo $HR

value=$(<set1313-2-pod-regular.yaml)
echo "$value"

enter

((i++))
echo "$i. Check pod and node"
echo ""
echo "kubectl get pods -n=chp13-set1313 -o wide"
kubectl get pods -n=chp13-set1313 -o wide --sort-by=.status.podIP
echo ""
echo "kubectl get node -o wide"
kubectl get node -o wide
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

echo "kubectl exec pod-with-host-pid-and-ipc -n=chp13-set1313 -- ps aux | head -10"
kubectl exec pod-with-host-pid-and-ipc -n=chp13-set1313 -- ps aux | head -10
echo ""

echo "Test with regular pod:"
echo "kubectl exec pod-regular -n=chp13-set1313 -- ps aux | head -10"
kubectl exec pod-regular -n=chp13-set1313 -- ps aux | head -10



#enter
echo $HR

((i++))
echo "$i. Clean-up"
echo ""
echo "kubectl delete -f $FULLPATH --now"
kubectl delete -f $FULLPATH --now

