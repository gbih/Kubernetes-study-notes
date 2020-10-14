#!/bin/bash
. ~/src/common/setup.sh
FULLPATH=$(pwd)
echo "16.1.1 Introducing taints and tolerations"
echo $HR_TOP

kubectl get nodes
echo $HR
kubectl top nodes
echo $HR
kubectl top pods -A
echo $HR

enter

echo "kubectl describe node actionbook-vm"
kubectl describe node actionbook-vm
enter

echo "kubectl describe node -l name=node1-vm"
kubectl describe node -l name=node1-vm
enter
