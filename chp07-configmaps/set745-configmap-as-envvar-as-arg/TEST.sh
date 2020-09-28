#!/bin/bash
. ~/src/SETUP.sh
FULLPATH=$(pwd)
echo $HR_TOP

echo "kubectl apply -f $FULLPATH"
kubectl apply -f $FULLPATH
sleep 1
echo $HR

value=$(<set745-1-configmap.yaml)
echo "$value"

enter

value=$(<set745-2-fortune-pod-env-configmap.yaml)
echo "$value"

enter

echo "kubectl wait --for=condition=Ready=True pod/fortune-env-from-configmap -n=chp07-set745 --timeout=20s"
kubectl wait --for=condition=Ready=True pod/fortune-env-from-configmap -n=chp07-set745 --timeout=20s
echo $HR

echo "kubectl exec -it pod/fortune-env-from-configmap -n=chp07-set745 -c=html-generator -- printenv"
kubectl exec -it pod/fortune-env-from-configmap -n=chp07-set745 -c=html-generator -- printenv
echo $HR

enter

echo "kubectl describe pod -n=chp07-set745"
kubectl describe pod -n=chp07-set745
echo $HR

echo "kubectl delete -f $FULLPATH"
kubectl delete -f $FULLPATH
