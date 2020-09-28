#!/bin/bash
. ~/src/SETUP.sh
FULLPATH=$(pwd)

echo $HR_TOP

echo "kubectl apply -f $FULLPATH"
kubectl apply -f $FULLPATH
sleep 5

echo $HR

echo "kubectl get pods -n=chp05-set532"
kubectl get pods -n=chp05-set532

echo $HR

echo "POD2=\$(kubectl get pods -n=chp05-set532 -o jsonpath={'.items[2].metadata.name'})"
POD2=$(kubectl get pods -n=chp05-set532 -o jsonpath={'.items[2].metadata.name'}) 

echo "kubectl wait --for=condition=Ready=True pods/$POD2 -n=chp05-set532 --timeout=30s"
kubectl wait --for=condition=Ready=True pods/$POD2 -n=chp05-set532 --timeout=30s

echo $HR

echo "kubectl get all -n=chp05-set532 --show-labels"
kubectl get all -n=chp05-set532 --show-labels

echo $HR

echo "kubectl get endpoints -n=chp05-set532 -o wide"
kubectl get endpoints -n=chp05-set532 -o wide

echo $HR

echo "kubectl get rc kubia -n=chp05-set532 --show-labels"
kubectl get rc kubia -n=chp05-set532 --show-labels
echo $HR

echo "EXTERNAL_IP=\$(kubectl get svc kubia-loadbalancer -n=chp05-set532 -o jsonpath='{.status.loadBalancer.ingress[0].ip}')" 
EXTERNAL_IP=$(kubectl get svc kubia-loadbalancer -n=chp05-set532 -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
echo $EXTERNAL_IP

echo $HR

echo "curl http://$EXTERNAL_IP"
curl http://$EXTERNAL_IP
curl http://$EXTERNAL_IP
curl http://$EXTERNAL_IP

echo $HR

echo "kubectl delete -f $FULLPATH"
kubectl delete -f $FULLPATH

