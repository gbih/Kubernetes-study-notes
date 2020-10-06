#!/bin/bash
. ~/src/common/setup.sh
FULLPATH=$(pwd)
echo $HR_TOP

echo "kubectl apply -f $FULLPATH"
kubectl apply -f $FULLPATH
sleep 1

echo $HR

value=$(<set731-1-fortune-pod-args.yaml)
echo "$value"
enter


echo "kubectl wait --for=condition=Ready=True pod/fortune2s -n=chp07-set731 --timeout=20s"
kubectl wait --for=condition=Ready=True pod/fortune2s -n=chp07-set731 --timeout=20s
echo ""


echo "kubectl get pods -n=chp07-set731 --show-labels"
kubectl get pods -n=chp07-set731 --show-labels
echo $HR

POD_IP=$(kubectl get pod/fortune2s -n=chp07-set731 -o jsonpath='{.status.podIP}')

POD_NAME=$(kubectl get pod/fortune2s -n=chp07-set731 -o jsonpath='{.spec.containers[0].name}')
echo "Container with Env Var: $POD_NAME"

POD_ENV_NAME=$(kubectl get pod/fortune2s -n=chp07-set731 -o jsonpath='{.spec.containers[0].env[0].name}')
echo "Env Var Name: $POD_ENV_NAME"

POD_ENV_VALUE=$(kubectl get pod/fortune2s -n=chp07-set731 -o jsonpath='{.spec.containers[0].env[0].value}')
echo "Env Var Value: $POD_ENV_VALUE"
echo $HR

echo "kubectl exec -it pod/fortune2s -c=html-generator -n=chp07-set731 -- printenv"
kubectl exec -it pod/fortune2s -c=html-generator -n=chp07-set731 -- printenv

echo $HR

echo "Container script is generated every 1 second"
echo "curl $POD_IP"
curl $POD_IP
echo ""
sleep 1

echo "curl $POD_IP"
curl $POD_IP

echo $HR

echo "kubectl delete -f $FULLPATH"
kubectl delete -f $FULLPATH
