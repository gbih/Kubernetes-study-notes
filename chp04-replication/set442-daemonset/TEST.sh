#!/bin/bash
. ~/src/common/setup.sh
FULLPATH=$(pwd)

echo $HR_TOP

echo "kubectl get nodes --show-labels"
kubectl get nodes --show-labels
echo ""

echo "kubectl label nodes actionbook-vm disk=ssd"
kubectl label nodes actionbook-vm disk=ssd
echo ""

echo "kubectl get nodes -l disk=ssd --show-labels"
kubectl get nodes -l disk=ssd --show-labels

echo $HR

echo "kubectl apply -f $FULLPATH"
kubectl apply -f $FULLPATH
sleep 5

echo $HR

echo "kubectl get ds -n=chp04-set442"
kubectl get ds -n=chp04-set442

echo $HR

echo "kubectl get all -n=chp04-set442"
kubectl get all -n=chp04-set442

echo $HR

echo "kubectl describe ds -n=chp04-set442"
kubectl describe ds -n=chp04-set442

echo $HR

echo "kubectl label nodes actionbook-vm disk-"
kubectl label nodes actionbook-vm disk-
echo ""

echo $HR

echo "kubectl delete -f $FULLPATH"
kubectl delete -f $FULLPATH
