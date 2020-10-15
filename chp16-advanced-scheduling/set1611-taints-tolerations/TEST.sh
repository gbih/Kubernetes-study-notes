#!/bin/bash
. ~/src/common/setup.sh
FULLPATH=$(pwd)
echo "16.1.1 Introducing taints and tolerations"
echo $HR_TOP

echo "kubectl get nodes -o wide"
kubectl get nodes -o wide

echo $HR

echo "kubectl top nodes"
kubectl top nodes

echo $HR

echo "kubectl top pods -A"
kubectl top pods -A

echo $HR

enter

echo "Getting taints, style 1"
echo "kubectl get nodes -o json | jq '.items[].spec.taints'"
kubectl get nodes -o json | jq '.items[].spec.taints'
echo $HR

echo "Alternative 2"
echo "kubectl get nodes -o=custom-columns=NAME:.metadata.name,TAINTS:.spec.taints,LABEL-NAME:.metadata.labels.name,LABEL-ENV:.metadata.labels.env"
kubectl get nodes -o=custom-columns=NAME:.metadata.name,TAINTS:.spec.taints,LABEL-NAME:.metadata.labels.name,LABEL-ENV:.metadata.labels.env

enter



echo "kubectl describe node actionbook-vm"
kubectl describe node actionbook-vm
enter

echo "kubectl describe node -l name=node1-vm"
kubectl describe node -l name=node1-vm

echo ""
