#!/bin/bash
 . ~/src/common/setup.sh
FULLPATH=$(pwd)
echo "Tests for Section 17.6 pre-stop hook" 
echo $HR_TOP

kubectl apply -f $FULLPATH

echo $HR

echo "kubectl wait --for=condition=Ready=True pods/pod-with-prestop-hook -n=chp17-set1726 --timeout=20s"
kubectl wait --for=condition=Ready=True pods/pod-with-prestop-hook -n=chp17-set1726 --timeout=20s

echo "kubectl get pods -n=chp17-set1726 -o wide"
kubectl get pods -n=chp17-set1726 -o wide

echo $HR

echo "Terminate pod in separate terminal via"
echo "kubectl delete -f set1726-pod.yaml"

echo $HR

echo "Run this in a separate terminal, then press enter"
echo "kubectl -n=chp17-set1726 exec pod-with-prestop-hook -it -- tail -f /tmp/log/log.txt"

enter

echo "kubectl delete -f $FULLPATH"
kubectl delete -f $FULLPATH --ignore-not-found
 
