#!/bin/bash
. ~/src/common/setup.sh
FULLPATH=$(pwd)
echo "6.6.3 Dynamic provisioning without specifying a storage class"
echo $HR_TOP

echo "kubectl apply -f $FULLPATH"
kubectl apply -f $FULLPATH
echo $HR

#value=$(<set663-1-storageclass.yaml)
#echo "$value"
#enter

value=$(<set663-1-mongodb-pvc-nostorageclass.yaml)
echo "$value"
enter

#value=$(<set663-3-mongodb-pvc.yaml)
#echo "$value"
#enter

echo "kubectl get sc"
kubectl get sc
echo $HR


#echo "kubectl get pvc mongodb-pvc -n=chp06-set663 --show-labels"
#kubectl get pvc mongodb-pvc -n=chp06-set663 --show-labels
#echo $HR

echo "kubectl get pvc mongodb-pvc-default -n=chp06-set663"
kubectl get pvc mongodb-pvc-default -n=chp06-set663
echo $HR

#echo "kubectl describe pvc -n=chp06-set663"
#kubectl describe pvc -n=chp06-set663
#echo $HR

echo "kubectl get pv"
echo "Note: Resources such as pvc-... are dynamically allocated PersistentVolumes"
kubectl get pv
echo $HR

echo "kubectl get events -n=chp06-set663"
kubectl get events -n=chp06-set663
echo $HR

enter

echo "kubectl describe sc"
kubectl describe sc

echo $HR

echo "kubectl describe pv"
kubectl describe pv

enter

echo "kubectl describe pvc -n=chp06-set663"
kubectl describe pvc -n=chp06-set663

enter

echo "kubectl delete -f $FULLPATH"
kubectl delete -f $FULLPATH
