#!/bin/bash
. ~/src/COMMON/SETUP.sh
FULLPATH=$(pwd)
echo $HR_TOP

echo "kubectl apply -f $FULLPATH"
kubectl apply -f $FULLPATH
sleep 1

echo $HR

echo "kubectl get all -n=chp04-set454"
kubectl get all -n=chp04-set454

echo $HR

echo "POD0=\$(kubectl get pods -n=chp04-set454 -o jsonpath={'.items[0].metadata.name'})"
POD0=$(kubectl get pods -n=chp04-set454 -o jsonpath={'.items[0].metadata.name'})
echo $POD0

echo $HR

echo "kubectl wait --for=condition=Ready=True pods/$POD0 -n=chp04-set454 --timeout=20s"
kubectl wait --for=condition=Ready=True pods/$POD0 -n=chp04-set454 --timeout=20s

echo $HR

echo "sleep 15"
sleep 15

echo $HR

echo "kubectl logs $POD0 -n=chp04-set454"
kubectl logs $POD0 -n=chp04-set454

echo $HR

echo "kubectl logs job.batch/multi-completion-batch-job -n=chp04-set454"
kubectl logs job.batch/multi-completion-batch-job -n=chp04-set454

echo $HR

echo "kubectl get all -n=chp04-set454"
kubectl get all -n=chp04-set454

echo $HR

echo "kubectl delete -f $FULLPATH"
kubectl delete -f $FULLPATH
