#!/bin/bash
. ~/src/COMMON/SETUP.sh
FULLPATH=$(pwd)

echo $HR_TOP

kubectl apply -f $FULLPATH
sleep 1

echo $HR

value=$(<set722-1-fortune-pod-args.yaml)
echo "$value"
enter


echo "kubectl wait --for=condition=Ready=True pod/fortune2s -n=chp07-set722 --timeout=20s"
kubectl wait --for=condition=Ready=True pod/fortune2s -n=chp07-set722 --timeout=20s
echo $HR

echo "kubectl get pods -n=chp07-set722 --show-labels"
kubectl get pods -n=chp07-set722 --show-labels
echo $HR

POD_IP=$(kubectl get pod/fortune2s -n=chp07-set722 -o jsonpath='{.status.podIP}')

POD_NAME=$(kubectl get pod/fortune2s -n=chp07-set722 -o jsonpath='{.spec.containers[0].name}')

echo "Container with args: $POD_NAME"

POD_ARGS=$(kubectl get pod/fortune2s -n=chp07-set722 -o jsonpath='{.spec.containers[0].args[0]}')

echo "Args: $POD_ARGS"

echo $HR

echo "curl $POD_IP"
curl $POD_IP
echo ""
sleep 2

echo "curl $POD_IP"
curl $POD_IP
echo ""
sleep 2

echo "curl $POD_IP"
curl $POD_IP

echo $HR

echo "kubectl delete -f $FULLPATH"
kubectl delete -f $FULLPATH
