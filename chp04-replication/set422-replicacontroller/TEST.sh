#!/bin/bash
. ~/src/COMMON/SETUP.sh
FULLPATH=$(pwd)

echo $HR_TOP

echo "kubectl apply -f $FULLPATH/set422-0-ns.yaml"
kubectl apply -f $FULLPATH/set422-0-ns.yaml
sleep 1

echo $HR

echo "kubectl apply -f $FULLPATH"
kubectl apply -f $FULLPATH
sleep 1

echo $HR

echo "kubectl get all -n=chp04-set422"
kubectl get all -n=chp04-set422

echo $HR

echo "kubectl describe rc -n=chp04-set422"
kubectl describe rc -n=chp04-set422

echo $HR

echo "POD0=\$(kubectl get pods -n=chp04-set422 -o jsonpath={'.items[0].metadata.name'})"
POD0=$(kubectl get pods -n=chp04-set422 -o jsonpath={'.items[0].metadata.name'})

echo "kubectl wait --for=condition=Ready=True pod/$POD0 -n=chp04-set422 --timeout=11s"
kubectl wait --for=condition=Ready=True pod/$POD0 -n=chp04-set422 --timeout=11s

echo $HR

echo "We cannot use rollout status on replicationcontroller:"
echo ""
echo "kubectl rollout status replicationcontroller kubia -n=chp04-set422"
kubectl rollout status replicationcontroller kubia -n=chp04-set422
echo $HR


echo "kubectl delete pod/$POD0 -n=chp04-set422"
kubectl delete pod/$POD0 -n=chp04-set422

#echo "kubectl wait --for=condition=Terminated=True pod/$POD0 -n=chp04-set422 --timeout=20s"
#kubectl wait --for=condition=Terminatd=True pod/$POD0 -n=chp04-set422 --timeout=20s

echo $HR

echo "kubectl get all -n=chp04-set422"
kubectl get all -n=chp04-set422
echo ""

echo $HR

echo "kubectl delete -F $FULLPATH"
kubectl delete -f $FULLPATH

