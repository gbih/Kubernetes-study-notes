#!/bin/bash
. ~/src/common/setup.sh
FULLPATH=$(pwd)
echo "Configuring allowed, default, and disallowed capabilities"
echo $HR_TOP

((i++))


value=$(<set1333-1-psp-capabilities.yaml)
echo "$value"

enter

value=$(<set1333-2-pod-add-sysadmin-capability.yaml)
echo "$value"

enter

echo "cat /var/snap/microk8s/current/args/kube-apiserver"
echo ""
cat /var/snap/microk8s/current/args/kube-apiserver

enter


echo "$i. Deploying the app"
echo ""

echo "kubectl apply -f $FULLPATH"
#kubectl apply -f $FULLPATH/PSP
kubectl apply -f $FULLPATH/set1333-0-ns.yaml
kubectl apply -f $FULLPATH/set1333-1-psp-capabilities.yaml
sleep 2

echo $HR 

((i++))
echo "$i. Check objects and node"
echo ""

echo "kubectl get node"
kubectl get node
echo ""

echo "kubectl get psp"
kubectl get psp

echo $HR

((i++))
echo "$i. If a user tries to create a pod where they explicitly add one of the capabilities listed in the policy’s requiredDropCapabilities field, the pod is rejected:"
echo ""

echo "kubectl apply -f $FULLPATH/set1333-2-pod-add-sysadmin-capability.yaml"
kubectl apply -f $FULLPATH/set1333-2-pod-add-sysadmin-capability.yaml

echo $HR

((i++))
echo "$i. Clean-up"
echo ""
echo "kubectl delete -f $FULLPATH"
kubectl delete -f $FULLPATH
