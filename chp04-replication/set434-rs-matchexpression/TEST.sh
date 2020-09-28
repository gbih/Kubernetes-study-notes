#!/bin/bash
. ~/src/SETUP.sh
FULLPATH=$(pwd)

echo $HR_TOP

echo "kubectl apply -f $FULLPATH/set434-0-ns.yaml"
kubectl apply -f $FULLPATH/set434-0-ns.yaml

echo $HR

echo "kubectl apply -f $FULLPATH"
kubectl apply -f $FULLPATH
sleep 5

echo $HR

echo "kubectl describe rs -n=chp04-set434"
kubectl describe rs -n=chp04-set434

echo $HR

echo "kubectl get all -n=chp04-set434"
kubectl get all -n=chp04-set434

echo $HR

echo "kubectl delete ns chp04-set434"
kubectl delete ns chp04-set434
