#!/bin/bash
. ~/src/common/setup.sh
FULLPATH=$(pwd)
echo "9.3.6 Blocking rollouts of bad versions"
echo $HR_TOP

echo "kubectl apply -f $FULLPATH"
kubectl apply -f $FULLPATH --record
sleep 11
echo $HR

echo "Check ReplicaSet pod-template-hash"
echo "kubectl get rs -n=chp09-set936 -o jsonpath={'.items[0].metadata.labels.pod-template-hash'}"
kubectl get rs -n=chp09-set936 -o jsonpath={'.items[0].metadata.labels.pod-template-hash'}
echo ""
echo $HR

echo "kubectl get rs -n=chp09-set936 -o wide"
kubectl get rs -n=chp09-set936 -o wide
echo $HR


echo "kubectl get pods -n=chp09-set936 --show-labels"
kubectl get pods -n=chp09-set936 --show-labels
echo $HR

POD_0=$(kubectl get pod -n=chp09-set936 -o jsonpath={'.items[0].metadata.name'})

echo "kubectl wait --for=condition=Ready=True pod/$POD_0 -n=chp09-set936 --timeout=21s"
kubectl wait --for=condition=Ready=True pod/$POD_0 -n=chp09-set936 --timeout=21s
echo $HR

enter

SVC_IP=$(kubectl get svc/kubia -n=chp09-set936 -o jsonpath={'.status.loadBalancer.ingress[0].ip'})


echo "curl $SVC_IP"
counter=1
while [ $counter -le 10 ]
do
  curl http://$SVC_IP 
  sleep 0.5
  ((counter++))
done
echo $HR

echo "kubectl rollout status deployment kubia -n=chp09-set936 --timeout=11s"
kubectl rollout status deployment kubia -n=chp09-set936 --timeout=11s
echo $HR


# Declarative style
echo "Apply deployment with readiness probe"
echo "kubectl apply -f $FULLPATH/set936-2-kubia-deployment-v3-with-readinesscheck.yaml --record"
kubectl apply -f $FULLPATH/set936-2-kubia-deployment-v3-with-readinesscheck.yaml --record
echo $HR




VERSION="3.0"
echo "POD_V3=$(kubectl get pod -l app.kubernetes.io/version=$VERSION -n=chp09-set936 -o jsonpath={'.items[0].metadata.name'})"
POD_V3=$(kubectl get pod -l app.kubernetes.io/version=$VERSION -n=chp09-set936 -o jsonpath={'.items[0].metadata.name'})
echo $POD_V3
echo ""

echo "kubectl wait --for=condition=Ready=True pod/$POD_V3 -n=chp09-set936 --timeout=10s"
kubectl wait --for=condition=Ready=True pod/$POD_V3 -n=chp09-set936 --timeout=10s

enter

echo "kubectl describe pod/$POD_V3 -n=chp09-set936"
kubectl describe pod/$POD_V3 -n=chp09-set936


enter

echo "kubectl get rs -n=chp09-set936"
kubectl get rs -n=chp09-set936
echo $HR

echo "kubectl get pods -n=chp09-set936 --show-labels"
kubectl get pods -n=chp09-set936 --show-labels
echo $HR

echo "kubectl rollout status deployment kubia --timeout=11s -n=chp09-set936"
kubectl rollout status deployment kubia --timeout=11s -n=chp09-set936
echo $HR


echo "kubectl rollout history deployment kubia -n=chp09-set936"
kubectl rollout history deployment kubia -n=chp09-set936

enter

echo "kubectl get events -n=chp09-set936 --sort-by .lastTimestamp"
kubectl get events -n=chp09-set936 --sort-by=.metadata.creationTimestamp
echo $HR


enter


echo "Abort bad rollout"
echo "kubectl rollout undo deployment kubia -n=chp09-set936"
kubectl rollout undo deployment kubia -n=chp09-set936
echo $HR


echo "kubectl get rs -n=chp09-set936"
kubectl get rs -n=chp09-set936
echo $HR

echo "kubectl get pods -n=chp09-set936 --show-labels"
kubectl get pods -n=chp09-set936 --show-labels
echo $HR


echo "kubectl delete ns chp09-set936"
kubectl delete ns chp09-set936
