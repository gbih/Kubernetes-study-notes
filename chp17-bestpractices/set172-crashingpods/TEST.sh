#!/bin/bash
. ~/src/common/setup.sh
FULLPATH=$(pwd)

cat <<- "NOTES"
Tests for Section 17.2 Rescheduling of dead or partially dead pods

If a pod's container keeps crashing, the Kubelet will keep restarting it indefinitely.
Such pods are not automatically removed and rescheduled, even if they are part of a ReplicaSet.
The RS Controller doesn't care if the pod is dead -- all it cares about is the number of pods match the desired replica count.
NOTES

kubectl delete -f $FULLPATH --now --ignore-not-found

enter

value=$(<set172-1-replicaset-crashingpod.yaml)
echo "$value"

enter



echo "kubectl apply -f $FULLPATH"
kubectl apply -f $FULLPATH
sleep 2
echo $HR

echo "kubectl get pods -n=chp17-set172" 
kubectl get pods -n=chp17-set172
echo $HR

echo "kubectl -n=chp17-set172 get rs crashing-pods -o wide"
kubectl -n=chp17-set172 get rs crashing-pods -o wide
echo $HR

echo "No action taken by the ReplicaSet Controller, because current replicas match desired replicas."
echo "kubectl describe rs crashing-pods -n=chp17-set172"
kubectl describe rs crashing-pods -n=chp17-set172
echo $HR

POD0=$(kubectl get pods -n=chp17-set172 -o jsonpath={'.items[0].metadata.name'})
#echo "POD0 is $POD0"
#echo ""

echo "The pod status also shows as running."
echo "kubectl describe -n=chp17-set172 pod/$POD0"
kubectl describe -n=chp17-set172 pod/$POD0
echo ""


echo $HR

echo "kubectl delete -f set172-0-ns.yaml"
kubectl delete -f set172-0-ns.yaml


