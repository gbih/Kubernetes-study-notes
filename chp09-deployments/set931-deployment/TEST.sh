#!/bin/bash
. ~/src/SETUP.sh
FULLPATH=$(pwd)
echo $HR_TOP

kubectl apply -f $FULLPATH/set931-0-ns.yaml --record
kubectl apply -f $FULLPATH/set931-1-kubia-deployment-v1.yaml --record
kubectl apply -f $FULLPATH/set931-2-service.yaml --record
echo $HR

POD0=$(kubectl get pods -n=chp09-set931 -o jsonpath={'.items[0].metadata.name'})
kubectl wait --for=condition=Ready=True pods/$POD0 -n=chp09-set931
echo $HR

echo "kubectl get all -n=chp09-set931 --show-labels"
kubectl get all -n=chp09-set931 --show-labels
echo $HR

echo "Check ReplicaSet pod-template-hash"
POD_TEMPLATE_HASH=$(kubectl get rs -n=chp09-set931 -o jsonpath={'.items[0].metadata.labels.pod-template-hash'})
echo $POD_TEMPLATE_HASH
echo $HR

enter

echo "kubectl get rs -n=chp09-set931 -o wide"
kubectl get rs -n=chp09-set931 -o wide
echo ""

echo "kubectl get pods -n=chp09-set931 --show-labels"
kubectl get pods -n=chp09-set931 --show-labels
echo $HR

echo "SVC_IP=\$(kubectl get svc/kubia -n=chp09-set931 -o jsonpath={'.status.loadBalancer.ingress[0].ip'})"
SVC_IP=$(kubectl get svc/kubia -n=chp09-set931 -o jsonpath={'.status.loadBalancer.ingress[0].ip'})
echo ""

echo "curl http://$SVC_IP"
curl http://$SVC_IP
echo $HR

echo "kubectl rollout status deployment kubia -n=chp09-set931"
kubectl rollout status deployment kubia -n=chp09-set931
echo $HR

enter

echo "kubectl patch deployment kubia -p '{\"spec\": {\"minReadySeconds\": 3}}' -n=chp09-set931"
kubectl patch deployment kubia -p '{"spec": {"minReadySeconds": 3}}' -n=chp09-set931
sleep 1
echo $HR

# Imperative style
#echo "kubectl set image deployment kubia nodejs=luksa/kubia:v2 -n=chp09-set931"
#kubectl set image deployment kubia nodejs=luksa/kubia:v2 -n=chp09-set931
#echo ""

# Declarative style
echo "kubectl apply -f $FULLPATH/set931-3-kubia-deployment-v2.yaml --record"
kubectl apply -f $FULLPATH/set931-3-kubia-deployment-v2.yaml --record
sleep 1
echo $HR

echo "kubectl rollout status deployment kubia -n=chp09-set931"
kubectl rollout status deployment kubia -n=chp09-set931
echo $HR

enter

echo "kubectl get rs -n=chp09-set931 -o wide"
kubectl get rs -n=chp09-set931 -o wide
echo $HR

echo "kubectl get pods -n=chp09-set931 --show-labels"
kubectl get pods -n=chp09-set931 --show-labels
echo $HR

echo "Check ReplicaSet pod-template-hash"
POD_TEMPLATE_HASH=$(kubectl get rs -n=chp09-set931 -o jsonpath={'.items[0].metadata.labels.pod-template-hash'})
echo $POD_TEMPLATE_HASH
echo $HR

echo "kubectl delete ns chp09-set931"
kubectl delete ns chp09-set931

