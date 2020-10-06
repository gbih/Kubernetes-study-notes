#!/bin/bash
. ~/src/COMMON/SETUP.sh
FULLPATH=$(pwd)

echo $HR_TOP

echo "kubectl apply -f $FULLPATH"
kubectl apply -f $FULLPATH
sleep 1
echo $HR

value=$(<set742-1-configmap.yaml)
echo "$value"
enter

echo "kubectl get cm -n=chp07-set742 --show-labels" 
kubectl get cm -n=chp07-set742 --show-labels
echo $HR

echo "kubectl describe cm fortune-config -n=chp07-set742"
kubectl describe cm fortune-config -n=chp07-set742

echo $HR
echo "kubectl delete -f $FULLPATH"
kubectl delete -f $FULLPATH
