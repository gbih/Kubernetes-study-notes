#!/bin/bash
. ~/src/COMMON/SETUP.sh
FULLPATH=$(pwd)
echo $HR_TOP

echo "kubectl apply -f $FULLPATH"
kubectl apply -f $FULLPATH/set935-0-ns.yaml
kubectl apply -f $FULLPATH/set935-1-kubia-deployment-v3.yaml --record
kubectl apply -f $FULLPATH/set935-2-service.yaml
sleep 1
echo $HR

echo "kubectl get rs -n=chp09-set935 -o jsonpath={'.items[0].metadata.labels.pod-template-hash'}"
kubectl get rs -n=chp09-set935 -o jsonpath={'.items[0].metadata.labels.pod-template-hash'}
echo ""
echo $HR

echo "kubectl get rs -n=chp09-set935 -o wide"
kubectl get rs -n=chp09-set935 -o wide
echo $HR

echo "kubectl get pods -n=chp09-set935 --show-labels"
kubectl get pods -n=chp09-set935 --show-labels
echo $HR

POD_0=$(kubectl get pod -n=chp09-set935 -o jsonpath={'.items[0].metadata.name'})

echo "kubectl wait --for=condition=Ready=True pod/$POD_0 -n=chp09-set935 --timeout=21s"
kubectl wait --for=condition=Ready=True pod/$POD_0 -n=chp09-set935 --timeout=21s
echo ""

SVC_IP=$(kubectl get svc/kubia -n=chp09-set935 -o jsonpath={'.status.loadBalancer.ingress[0].ip'})


echo "kubectl rollout status deployment kubia -n=chp09-set935"
kubectl rollout status deployment kubia -n=chp09-set935
echo $HR


echo "curl $SVC_IP"
counter=1
while [ $counter -le 20 ]
do
  curl http://$SVC_IP 
  sleep 0.3
  ((counter++))
done
echo $HR


# Imperative style
#echo "kubectl set image deployment kubia nodejs=luksa/kubia:v2 -n=chp09-set935"
#kubectl set image deployment kubia nodejs=luksa/kubia:v2 -n=chp09-set935
#echo ""

# Declarative style
echo "kubectl apply -f $FULLPATH/set935-3-kubia-deployment-v4.yaml --record"
kubectl apply -f $FULLPATH/set935-3-kubia-deployment-v4.yaml --record
sleep 1

echo $HR

VERSION="4.0"
echo "POD_V4=$(kubectl get pod -l app.kubernetes.io/version=$VERSION -n=chp09-set935 -o jsonpath={'.items[0].metadata.name'})"
POD_V4=$(kubectl get pod -l app.kubernetes.io/version=$VERSION -n=chp09-set935 -o jsonpath={'.items[0].metadata.name'})
echo $POD_V4
echo ""

echo "kubectl wait --for=condition=Ready=True pod/$POD_V4 -n=chp09-set935 --timeout=21s"
kubectl wait --for=condition=Ready=True pod/$POD_V4 -n=chp09-set935 --timeout=21s

echo $HR

echo "kubectl rollout pause deployment kubia -n=chp09-set935"
kubectl rollout pause deployment kubia -n=chp09-set935
echo $HR

enter

echo "kubectl get rs -n=chp09-set935 -o wide"
kubectl get rs -n=chp09-set935 -o wide
echo $HR

echo "kubectl get pods -n=chp09-set935 --show-labels"
kubectl get pods -n=chp09-set935 --show-labels
echo $HR

echo "Test curl on the v4.0 pod"
echo "POD_V4_IP=\$(kubectl get pods/$POD_V4 -n=chp09-set935 -o jsonpath={'.status.podIP'})"
POD_V4_IP=$(kubectl get pods/$POD_V4 -n=chp09-set935 -o jsonpath={'.status.podIP'})
echo "POD_V4_IP is $POD_V4_IP"

echo ""

echo "curl $POD_V4_IP"
echo ""
counter=1
while [ $counter -le 10 ]
do
  curl http://$POD_V4_IP:8080
  sleep 0.5
  ((counter++))
done
echo $HR

echo "kubectl rollout resume deployment kubia -n=chp09-set935"
kubectl rollout resume deployment kubia -n=chp09-set935
echo $HR

echo "kubectl rollout status deployment kubia -n=chp09-set935 -w"
kubectl rollout status deployment kubia -n=chp09-set935 -w
echo $HR

echo "kubectl get pods -n=chp09-set935 --show-labels"
kubectl get pods -n=chp09-set935 --show-labels

echo $HR

echo "kubectl rollout history deployment kubia -n=chp09-set935"
kubectl rollout history deployment kubia -n=chp09-set935
echo $HR

echo "kubectl delete -f $FULLPATH/set935-0-ns.yaml"
kubectl delete -f $FULLPATH/set935-0-ns.yaml
