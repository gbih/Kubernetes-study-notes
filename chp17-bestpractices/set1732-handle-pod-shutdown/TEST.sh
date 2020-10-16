#!/bin/bash
. ~/src/common/setup.sh
FULLPATH=$(pwd)

kubectl apply -f $FULLPATH

echo $HR

echo "kubectl wait --for=condition=Ready=True pods/pod-with-prestop-hook -n=chp17-set1732 --timeout=20s"
kubectl wait --for=condition=Ready=True pods/pod-with-prestop-hook -n=chp17-set1732 --timeout=20s

echo $HR

echo "kubectl get pods -n=chp17-set1732 -o wide"
kubectl get pods -n=chp17-set1732 -o wide

echo $HR

echo "Wait for pod to terminate with exit code 137, otherwise exit early via 'ctrl-c'"
echo ""
echo "kubectl -n=chp17-set1732 exec pod-with-prestop-hook -it -- tail -f /tmp/log/log.txt"
kubectl -n=chp17-set1732 exec pod-with-prestop-hook -it -- tail -f /tmp/log/log.txt

echo $HR

#echo "kubectl delete -f $FULLPATH"
#kubectl delete -f $FULLPATH


