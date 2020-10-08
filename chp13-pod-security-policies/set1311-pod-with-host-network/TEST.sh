#!/bin/bash
. ~/src/common/setup.sh
FULLPATH=$(pwd)
echo $HR_TOP

echo "kubectl apply -f $FULLPATH/PSP"
kubectl apply -f $FULLPATH/PSP
echo ""

echo "kubectl apply -f $FULLPATH"
kubectl apply -f $FULLPATH --record
sleep 1
echo ""
echo "kubectl wait --for=condition=Ready pod/pod-with-host-network -n=chp13-set1311"
kubectl wait --for=condition=Ready pod/pod-with-host-network -n=chp13-set1311

enter


((i++))
value=$(<set1311-1-pod-with-host-network.yaml)
echo "$value"

enter

echo "Check environment"
echo ""

echo "cat /var/snap/microk8s/current/args/kube-apiserver"
echo ""
cat /var/snap/microk8s/current/args/kube-apiserver
echo "" 
echo "See more options here: https://kubernetes.io/docs/reference/command-line-tools-reference/kube-apiserver/"

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
echo "kubectl exec pod-with-host-network -n=chp13-set1311 -- ifconfig"
echo ""
kubectl exec pod-with-host-network -n=chp13-set1311 -- ifconfig

enter

((i++))
echo "$i. Clean-up"
echo ""
kubectl delete -f $FULLPATH
kubectl delete -f $FULLPATH/PSP
