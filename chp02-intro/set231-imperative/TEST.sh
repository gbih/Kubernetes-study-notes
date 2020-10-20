#!/bin/bash
. ~/src/common/setup.sh
echo "2.3.1 Deploying your Node.js app, imperative-style"
echo $HR_TOP

echo "kubectl create namespace chp02-set231-imperative"
kubectl create namespace chp02-set231-imperative
echo $HR
sleep 1

echo "kubectl create deployment kubia --image=georgebaptista/kubia -n=chp02-set231-imperative"
kubectl create deployment kubia --image=georgebaptista/kubia -n=chp02-set231-imperative
echo $HR

kubectl rollout status deployment/kubia -n=chp02-set231-imperative
echo $HR

echo "kubectl get pods -n=chp02-set231-imperative"
kubectl get pods -n=chp02-set231-imperative
echo $HR

echo "kubectl expose deployment kubia --type=LoadBalancer --port 8080 -n=set231-imperative"
kubectl expose deployment kubia --type=LoadBalancer --port 8080 -n=chp02-set231-imperative
echo $HR
sleep 3

echo "kubectl get services -n=chp02-set231-imperative"
kubectl get services -n=chp02-set231-imperative
echo $HR

echo "CLUSTER_IP=\$(kubectl get service -n=chp02-set231-imperative -o jsonpath='{.items[0].spec.clusterIP}')"
CLUSTER_IP=$(kubectl get service -n=chp02-set231-imperative -o jsonpath='{.items[0].spec.clusterIP}')

echo "curl $CLUSTER_IP:8080"
curl $CLUSTER_IP:8080
echo ""

echo $HR


echo "kubectl scale deployment kubia --replicas=3 -n=chp02-set231-imperative"
kubectl scale deployment kubia --replicas=3 -n=chp02-set231-imperative
echo $HR
sleep 3

echo "kubectl get pods -n=chp02-set231-imperative"
kubectl get pods -n=chp02-set231-imperative
echo $HR

for i in {1..5}
do
  echo "curl $CLUSTER_IP:8080"
  curl $CLUSTER_IP:8080
  echo "" 
  sleep 0.5
done

echo $HR

kubectl get pods -o wide -n=chp02-set231-imperative

echo $HR

echo "POD1_NAME=$(kubectl get pod -n=chp02-set231-imperative -o jsonpath='{.items[0].metadata.name}')"
POD1_NAME=$(kubectl get pod -n=chp02-set231-imperative -o jsonpath='{.items[0].metadata.name}')

echo "kubectl describe pod $POD1_NAME -n=chp02-set231-imperative"
kubectl describe pod $POD1_NAME -n=chp02-set231-imperative

echo $HR

echo "kubectl delete namespace chp02-set231-imperative"
kubectl delete namespace chp02-set231-imperative
