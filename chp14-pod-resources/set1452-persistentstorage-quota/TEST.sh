#!/bin/bash
. ~/src/common/setup.sh
FULLPATH=$(pwd)
echo "Introducing the ResourceQuota object"
echo $HR_TOP

((i++))

value=$(<set1452-1-quota-storage.yaml)
echo "$value"

enter

echo "$i. Deploy the app"
echo ""

echo "kubectl apply -f $FULLPATH"
kubectl apply -f $FULLPATH/set1452-0-ns.yaml
kubectl apply -f $FULLPATH/set1452-1-quota-storage.yaml
sleep 1

echo $HR

((i++))
echo "$i. Check created resources"
echo ""
echo "kubectl get resourcequota/storage -n=chp14-set1452"
kubectl get resourcequota/storage -n=chp14-set1452
echo ""

echo "kubectl describe resourcequota/storage -n=chp14-set1452"
kubectl describe resourcequota/storage -n=chp14-set1452

enter

((i++))
echo "$i. Create StorageClass with resourcequota"
echo ""

echo "kubectl apply -f $FULLPATH/set1452-2-storageclass-fast-hostpath.yaml"
kubectl apply -f $FULLPATH/set1452-2-storageclass-fast-hostpath.yaml
echo $HR

((i++))

echo "$i. Inspect StorageClass"
echo ""
echo "kubectl describe storageclass fast -n=chp14-set1452"
kubectl describe storageclass fast -n=chp14-set1452

enter

((i++))
echo "$i. This PVC is too big, should fail with above resourcequota"
echo "kubectl apply -f $FULLPATH/set1452-3-mongodb-pvc-toobig.yaml"
echo ""
kubectl apply -f $FULLPATH/set1452-3-mongodb-pvc-toobig.yaml

echo $HR


((i++))
echo "$i. This PVC is ok, should be created with above resourcequota"
echo ""
echo "kubectl apply -f $FULLPATH/set1452-4-mongodb-pvc-ok.yaml"
kubectl apply -f $FULLPATH/set1452-4-mongodb-pvc-ok.yaml
echo ""

sleep 2


echo "kubectl get persistentvolumeclaim/mongodb-pvc-ok -n=chp14-set1452"
kubectl get persistentvolumeclaim/mongodb-pvc-ok -n=chp14-set1452
echo $HR

((i++))
echo "$i. Clean-up"
echo ""
echo "kubectl delete -f $FULLPATH"
kubectl delete -f $FULLPATH --ignore-not-found
