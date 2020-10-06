#!/bin/bash
. ~/src/common/setup.sh
FULLPATH=$(pwd)

echo $HR_TOP

echo "kubectl apply -f $FULLPATH"
kubectl apply -f $FULLPATH
echo $HR

value=$(<set652-1-mongodb-pv-hostpath.yaml)
echo "$value"
enter

echo "kubectl get storageclass -o wide"
kubectl get storageclass -o wide

echo $HR

echo "kubectl get pv -l app=mongodb-pv -o wide"
kubectl get pv -l app=mongodb-pv -o wide
echo ""

echo $HR

echo "kubectl describe pv mongodb-pv"
kubectl describe pv mongodb-pv

echo $HR

echo "kubectl delete -f $FULLPATH"
kubectl delete -f $FULLPATH

