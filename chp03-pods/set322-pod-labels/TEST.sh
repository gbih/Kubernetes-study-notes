#!/bin/bash
. ~/src/SETUP.sh
FULLPATH=$(pwd)

echo $HR_TOP

echo "kubectl get nodes --show-labels"
kubectl get nodes --show-labels
echo ""

echo "kubectl label nodes actionbook-vm gpu=true"
kubectl label nodes actionbook-vm gpu=true
echo ""

echo "kubectl get nodes -l gpu=true --show-labels"
kubectl get nodes -l gpu=true --show-labels

echo $HR

echo "kubectl apply -f $FULLPATH/set322-0-namespace.yaml"
kubectl apply -f $FULLPATH/set322-0-namespace.yaml
echo $HR

sleep 1

echo "kubectl apply -f $FULLPATH"
kubectl apply -f $FULLPATH
echo $HR

echo "kubectl wait --for=condition=Ready=True pods/kubia-manual -n=chp03-set322 --timeout=20s"
kubectl wait --for=condition=Ready=True pods/kubia-manual -n=chp03-set322 --timeout=20s
echo ""

echo "kubectl wait --for=condition=Ready=True pods/kubia-manual-v2 -n=chp03-set322 --timeout=20s"
kubectl wait --for=condition=Ready=True pods/kubia-manual-v2 -n=chp03-set322 --timeout=20s
echo ""

echo "kubectl wait --for=condition=Ready=True pods/kubia-gpu -n=chp03-set322 --timeout=20s"
kubectl wait --for=condition=Ready=True pods/kubia-gpu -n=chp03-set322 --timeout=20s

echo $HR

echo "kubectl get pods -n=chp03-set322 --show-labels"
kubectl get pods -n=chp03-set322 --show-labels

echo $HR

sleep 1

echo "kubectl get pods -n=chp03-set322 -l creation_method,env --show-labels"
kubectl get pods -n=chp03-set322 -l creation_method,env --show-labels
echo $HR

echo "kubectl get pod -l env -n=chp03-set322 --show-labels"
kubectl get pod -l env -n=chp03-set322 --show-labels

echo $HR

echo "kubectl get pods -l '!env' -n=chp03-set322 --show-labels"
kubectl get pods -l '!env' -n=chp03-set322 --show-labels

echo $HR

echo "CLUSTER_IP=\$(kubectl get service -n=chp03-set322 -o jsonpath='{.items[0].spec.clusterIP}')"
CLUSTER_IP=$(kubectl get service -n=chp03-set322 -o jsonpath='{.items[0].spec.clusterIP}')

echo ""

for i in {1..5}
do
  echo "curl $CLUSTER_IP:8080"
  curl $CLUSTER_IP:8080
  echo "" 
  sleep 0.5
done

echo $HR

echo "kubectl logs kubia-manual -c kubia -n=chp03-set322"
kubectl logs kubia-manual -c kubia -n=chp03-set322
echo $HR

echo "kubectl logs kubia-manual-v2 -c kubia -n=chp03-set322"
kubectl logs kubia-manual-v2 -c kubia -n=chp03-set322
echo $HR


echo "kubectl get events -n=chp03-set322"
kubectl get events -n=chp03-set322
echo $HR


echo "kubectl label nodes actionbook-vm gpu-"
kubectl label nodes actionbook-vm gpu-
echo ""

echo "kubectl delete pod -l creation_method=manual -n=chp03-set322"
kubectl delete pod -l creation_method=manual -n=chp03-set322
echo ""

echo "kubectl delete ns chp03-set322"
kubectl delete ns chp03-set322

