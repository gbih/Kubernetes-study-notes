#!/bin/bash
. ~/src/common/setup.sh
FULLPATH=$(pwd)
echo "4.5.2 Defining a Job resource"
echo $HR_TOP

echo "kubectl apply -f $FULLPATH"
kubectl apply -f $FULLPATH
sleep 2

echo $HR

echo "kubectl get jobs -n=chp04-set452"
kubectl get jobs -n=chp04-set452

echo $HR

echo "kubectl get pods -n=chp04-set452 --show-labels"
kubectl get pods -n=chp04-set452 --show-labels

echo $HR

echo "POD0=\$(kubectl get pods -n=chp04-set452 -o jsonpath={'.items[0].metadata.name'})"
POD0=$(kubectl get pods -n=chp04-set452 -o jsonpath={'.items[0].metadata.name'})

echo $HR

echo "sleep 10"
sleep 10

echo $HR

echo "kubectl logs $POD0 -n=chp04-set452"
kubectl logs $POD0 -n=chp04-set452

echo $HR

echo "kubectl get all -n=chp04-set452"
kubectl get all -n=chp04-set452

echo $HR

echo "kubectl delete ns chp04-set452"
kubectl delete ns chp04-set452

