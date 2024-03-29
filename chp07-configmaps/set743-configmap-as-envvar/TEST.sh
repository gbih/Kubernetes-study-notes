#!/bin/bash
. ../../SETUP.sh
FULLPATH=$(pwd)
echo "7.4.3 Passing a ConfigMap entry to a container as an environment variable"
echo $HR_TOP

echo "kubectl apply -f $FULLPATH"
kubectl apply -f $FULLPATH
sleep 1

echo $HR

value=$(<set743-1-configmap.yaml)
echo "$value"

enter

value=$(<set743-2-fortune-pod-env-configmap.yaml)
echo "$value"
enter

echo "kubectl wait --for=condition=Ready=True pod/fortune-env-from-configmap -n=chp07-set743 --timeout=20s"
kubectl wait --for=condition=Ready=True pod/fortune-env-from-configmap -n=chp07-set743 --timeout=20s
echo $HR

echo "kubectl get cm -n=chp07-set743 --show-labels"
kubectl get cm -n=chp07-set743 --show-labels
echo $HR


echo "kubectl exec -it pod/fortune-env-from-configmap -n=chp07-set743 -c=html-generator -- printenv"
kubectl exec -it pod/fortune-env-from-configmap -n=chp07-set743 -c=html-generator -- printenv
echo $HR

enter

echo "kubectl describe pod -n=chp07-set743"
kubectl describe pod -n=chp07-set743
echo $HR

echo "kubectl delete -f $FULLPATH"
kubectl delete -f $FULLPATH

