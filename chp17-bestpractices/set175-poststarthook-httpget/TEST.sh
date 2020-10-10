#!/bin/bash
. ~/src/common/setup.sh
FULLPATH=$(pwd)

echo "Tests for Section 17.5 PostStartHook HttpGet" 
echo ""

kubectl delete -f $FULLPATH --now --ignore-not-found

echo $HR

kubectl apply -f $FULLPATH

echo "sleep 3"
sleep 3
echo ""

echo "kubectl get pods -n=chp17-set175 -o wide"
kubectl get pods -n=chp17-set175 -o wide
echo ""


kubectl describe pod/pod-with-poststart-hook -n=chp17-set175
echo ""

echo "sleep 20"
sleep 20 
echo ""

kubectl describe pod/pod-with-poststart-hook -n=chp17-set175
echo ""

echo $HR
echo "kubectl delete -f $FULLPATH"
kubectl delete -f $FULLPATH
 
