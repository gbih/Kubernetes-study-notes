#!/bin/bash
. ~/src/common/setup.sh
FULLPATH=$(pwd)
echo $HR_TOP

echo "kubectl apply -f $FULLPATH/set231-0-ns.yaml"
kubectl apply -f $FULLPATH/set231-0-ns.yaml
echo $HR

sleep 1

echo "kubectl apply -f $FULLPATH"
kubectl apply -f $FULLPATH

sleep 3

echo $HR

echo "kubectl get all -n=chp02-set231-declarative"
kubectl get all -n=chp02-set231-declarative

echo $HR

echo "POD0=\$(kubectl get pods -n=chp02-set231-declarative -o jsonpath={'.items[0].metadata.name'})"
POD0=$(kubectl get pods -n=chp02-set231-declarative -o jsonpath={'.items[0].metadata.name'})
echo ""

while [[ $(kubectl get pods $POD0 -n=chp02-set231-declarative -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}') != "True" ]]
do
kubectl get pods $POD0 -n=chp02-set231-declarative -o custom-columns=\
INITIALIZED:..status.conditions['?(@.type=="Initialized")'].status,\
PODSCHEDULED:..status.conditions['?(@.type=="PodScheduled")'].status,\
READY:..status.conditions['?(@.type=="Ready")'].status,\
CONTAINERSREADY:..status.conditions['?(@.type=="ContainersReady")'].status
 sleep 0.2
done

echo $HR

echo "kubectl get rc kubia-rc -n=chp02-set231-declarative"
kubectl get rc kubia-rc -n=chp02-set231-declarative

echo $HR

echo "CLUSTER_IP=\$(kubectl get service -n=chp02-set231-declarative -o jsonpath='{.items[0].spec.clusterIP}')"
CLUSTER_IP=$(kubectl get service -n=chp02-set231-declarative -o jsonpath='{.items[0].spec.clusterIP}')

echo ""

for i in {1..5}
do
  echo "curl $CLUSTER_IP:8080"
  curl $CLUSTER_IP:8080
  echo "" 
  sleep 0.5
done

echo $HR

echo "kubectl delete -f $FULLPATH"
kubectl delete -f $FULLPATH

echo $HR
