#!/bin/bash
. ~/src/common/setup.sh
FULLPATH=$(pwd)
echo "17.2.4 Using a Post-start container lifecycle hook"
echo "This is an example of a failing hook"
echo $HR_TOP

value=$(<set1724-1-pod-post-start-hook-httpget.yaml)
echo "$value"

enter

kubectl apply -f $FULLPATH/set1724-0-ns.yaml
sleep 1 
kubectl apply -f $FULLPATH

echo $HR

echo "kubectl get pods -n=chp17-set1724"
kubectl get pods -n=chp17-set1724
echo $HR


enter

echo "kubectl delete -f $FULLPATH"
kubectl delete -f $FULLPATH
 
