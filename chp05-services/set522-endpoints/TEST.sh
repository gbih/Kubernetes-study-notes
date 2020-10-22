#!/bin/bash
. ~/src/common/setup.sh
echo "5.2.2 Manually configuring service endpoints"
FULLPATH=$(pwd)

echo "kubectl apply -f $FULLPATH/set522-0-ns.yaml"
echo "kubectl apply -f $FULLPATH/set522-1-external-service.yaml"
echo "kubectl apply -f $FULLPATH/set522-2-endpoints.yaml"

kubectl apply -f $FULLPATH/set522-0-ns.yaml
kubectl apply -f $FULLPATH/set522-1-external-service.yaml
kubectl apply -f $FULLPATH/set522-2-endpoints.yaml

sleep 2

echo $HR

value=$(<set522-1-external-service.yaml)
echo "$value"

enter

value=$(<set522-2-endpoints.yaml)
echo "$value"

enter

value=$(<set522-3-pod.yaml)
echo "$value"

enter


echo "kubectl get all -n=chp05-set522 -o wide"
kubectl get all -n=chp05-set522 -o wide
echo $HR


echo "kubectl describe svc external-service -n=chp05-set522"
kubectl describe svc external-service -n=chp05-set522
echo $HR

echo "kubectl get endpoints -n=chp05-set522"
kubectl get endpoints -n=chp05-set522
echo $HR

echo "kubectl apply -f $FULLPATH/set522-3-pod.yaml"
kubectl apply -f $FULLPATH/set522-3-pod.yaml
echo ""
sleep 1

echo "kubectl wait --for=condition=Ready=True pod/kubia -n=chp05-set522"
kubectl wait --for=condition=Ready=True pod/kubia -n=chp05-set522
echo ""

echo "kubectl get pods -n=chp05-set522 -o wide --show-labels"
kubectl get pods -n=chp05-set522 -o wide --show-labels

enter

echo "kubectl -n=chp05-set522 exec kubia -- env"
kubectl -n=chp05-set522 exec kubia -- env

echo $HR

#echo "kubectl delete -f $FULLPATH"
#kubectl delete -f $FULLPATH

echo "kubectl delete ns chp05-set522"
kubectl delete ns chp05-set522
