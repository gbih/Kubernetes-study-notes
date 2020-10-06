#!/bin/bash
. ~/src/COMMON/SETUP.sh
FULLPATH=$(pwd)

echo $HR_TOP

echo "kubectl apply -f $FULLPATH/set432-0-ns.yaml"
kubectl apply -f $FULLPATH/set432-0-ns.yaml

echo $HR

echo "kubectl apply -f $FULLPATH"
kubectl apply -f $FULLPATH
sleep 3

echo $HR

echo "kubectl get all -n=chp04-set432"
kubectl get all -n=chp04-set432

echo $HR

echo "kubectl describe rs/kubia -n=chp04-set432"
kubectl describe rs/kubia -n=chp04-set432
echo ""

echo $HR

echo "kubectl delete -f $FULLPATH"
kubectl delete -f $FULLPATH
