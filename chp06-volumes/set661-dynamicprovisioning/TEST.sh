#!/bin/bash
. ~/src/common/setup.sh
FULLPATH=$(pwd)
echo "6.6.1 Defining the available storage types through StorageClass resources"
echo $HR_TOP

echo "kubectl apply -f $FULLPATH"
kubectl apply -f $FULLPATH
echo $HR

value=$(<set661-1-storageclass-fast-hostpath.yaml)
echo "$value"
enter

value=$(<set661-2-mongodb-pvc.yaml)
echo "$value"
enter

echo "kubectl get storageclass"
kubectl get storageclass
echo $HR

echo "kubectl get pvc mongodb-pvc -n=chp06-set661"
kubectl get pvc mongodb-pvc -n=chp06-set661
echo $HR

echo "kubectl get pv"
kubectl get pv 

enter

echo "kubectl describe sc fast"
kubectl describe sc fast
echo $HR

echo "kubectl delete -f $FULLPATH"
kubectl delete -f $FULLPATH

