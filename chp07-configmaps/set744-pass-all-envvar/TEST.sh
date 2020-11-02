#!/bin/bash
. ~/src/common/setup.sh
FULLPATH=$(pwd)
echo "7.4.4 Passing all entries of a ConfigMap as environment variables at once"
echo $HR_TOP

echo "kubectl apply -f $FULLPATH"
kubectl apply -f $FULLPATH
sleep 1
echo $HR


value=$(<set744-1-configmap.yaml)
echo "$value"

enter

value=$(<set744-2-fortune-pod-env-configmap.yaml)
echo "$value"

enter


echo "kubectl wait --for=condition=Ready=True pod/fortune-env-from-configmap -n=chp07-set744 --timeout=20s"
kubectl wait --for=condition=Ready=True pod/fortune-env-from-configmap -n=chp07-set744 --timeout=20s
echo $HR

echo "kubecl get cm -n=chp07-set744"
kubectl get cm -n=chp07-set744
echo $HR

echo "kubectl exec -it pod/fortune-env-from-configmap -n=chp07-set744 -c=html-generator -- printenv"
kubectl exec -it pod/fortune-env-from-configmap -n=chp07-set744 -c=html-generator -- printenv
echo $HR


enter

echo "kubectl describe pod -n=chp07-set744"
kubectl describe pod -n=chp07-set744
echo $HR


echo "kubectl delete -f $FULLPATH"
kubectl delete -f $FULLPATH
