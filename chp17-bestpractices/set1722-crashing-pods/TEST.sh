#!/bin/bash
. ~/src/common/setup.sh
echo "17.2.2 Rescheduling of dead or partially dead pods"
FULLPATH=$(pwd)


echo "kubectl apply -f $FULLPATH"
kubectl apply -f $FULLPATH

enter

echo "kubectl get pods -n=chp17-set1722" 
kubectl get pods -n=chp17-set1722
echo $HR

echo "kubectl -n=chp17-set1722 get rs crashing-pods -o wide"
kubectl -n=chp17-set1722 get rs crashing-pods -o wide
echo $HR

echo "No action taken by the ReplicaSet Controller, because current replicas match desired replicas."
echo ""
echo "kubectl describe rs crashing-pods -n=chp17-set1722"
kubectl describe rs crashing-pods -n=chp17-set1722

enter

POD0=$(kubectl get pods -n=chp17-set1722 -o jsonpath={'.items[0].metadata.name'})
#echo "POD0 is $POD0"
#echo ""

echo "The pod status also shows as running."
echo ""
echo "kubectl describe -n=chp17-set1722 pod/$POD0"
kubectl describe -n=chp17-set1722 pod/$POD0
echo ""

enter

echo "kubectl delete -f set172-0-ns.yaml"
kubectl delete -f set172-0-ns.yaml

