#!/bin/bash
. ~/src/common/setup.sh
FULLPATH=$(pwd)
echo $HR_TOP

echo "kubectl apply -f $FULLPATH"
kubectl apply -f $FULLPATH
echo $HR

value=$(<set653-1-mongodb-pv-hostpath.yaml)
echo "$value"
enter

value=$(<set653-2-mongodb-pvc.yaml)
echo "$value"
enter

echo "kubectl get pv -l app=mongodb-pv"
kubectl get pv -l app=mongodb-pv
echo $HR

echo "kubectl get pvc -n=chp06-set653"
kubectl get pvc -n=chp06-set653
echo $HR

PV_RECYCLEPOLICY=$(kubectl get pv  -o jsonpath={'.items[0].spec.persistentVolumeReclaimPolicy'})

echo "Delete PVC to unbind the PV (persistentVolumeReclaimPolicy: $PV_RECYCLEPOLICY)"
echo ""
echo "kubectl delete -f $FULLPATH/set653-2-mongodb-pvc.yaml"
kubectl delete -f $FULLPATH/set653-2-mongodb-pvc.yaml
sleep 3
echo ""

echo "kubectl get pv -l app=mongodb-pv"
kubectl get pv -l app=mongodb-pv
echo $HR

echo "Create PVC again and bind to PV"
echo "kubectl apply -f \$FULLPATH/set653-2-mongodb-pvc.yaml"
kubectl apply -f $FULLPATH/set653-2-mongodb-pvc.yaml

sleep 10

echo $HR

echo "kubectl get pv -l app=mongodb-pv"
kubectl get pv -l app=mongodb-pv

echo $HR

echo "kubectl get pvc -n=chp06-set653"
kubectl get pvc -n=chp06-set653

enter

echo "kubectl get events -n=chp06-set653"
kubectl get events -n=chp06-set653

echo $HR

echo "kubectl delete -f $FULLPATH"
kubectl delete -f $FULLPATH

