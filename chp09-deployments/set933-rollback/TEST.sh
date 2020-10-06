#!/bin/bash
. ~/src/common/setup.sh
FULLPATH=$(pwd)
echo $HR_TOP

kubectl apply -f $FULLPATH/set933-0-ns.yaml
kubectl apply -f $FULLPATH/set933-1-kubia-deployment-v1.yaml --record
kubectl apply -f $FULLPATH/set933-2-service.yaml
sleep 1
echo $HR


echo "Check ReplicaSet pod-template-hash"
echo "kubectl get rs -n=chp09-set933 -o jsonpath={'.items[0].metadata.labels.pod-template-hash'}"
kubectl get rs -n=chp09-set933 -o jsonpath={'.items[0].metadata.labels.pod-template-hash'}
echo ""
echo $HR

echo "kubectl get rs -n=chp09-set933 -o wide --show-labels"
kubectl get rs -n=chp09-set933 -o wide --show-labels
echo $HR

echo "kubectl get pods -n=chp09-set933 --show-labels"
kubectl get pods -n=chp09-set933 --show-labels
echo $HR

echo "POD_0=\$(kubectl get pod -n=chp09-set933 -o jsonpath={'.items[0].metadata.name'})"
POD_0=$(kubectl get pod -n=chp09-set933 -o jsonpath={'.items[0].metadata.name'})

echo "kubectl wait --for=condition=Ready=True pod/$POD_0 -n=chp09-set933 --timeout=21s"
kubectl wait --for=condition=Ready=True pod/$POD_0 -n=chp09-set933 --timeout=21s
echo ""

echo " SVC_IP=\$(kubectl get svc/kubia -n=chp09-set933 -o jsonpath={'.status.loadBalancer.ingress[0].ip'})"
SVC_IP=$(kubectl get svc/kubia -n=chp09-set933 -o jsonpath={'.status.loadBalancer.ingress[0].ip'})

echo $HR

echo "curl $SVC_IP"
counter=1
while [ $counter -le 10 ]
do
  curl http://$SVC_IP 
  sleep 0.7
  ((counter++))
done
echo ""

echo $HR

echo "kubectl rollout status deployment kubia -n=chp09-set933"
kubectl rollout status deployment kubia -n=chp09-set933

# Imperative style
#echo "kubectl set image deployment kubia nodejs=luksa/kubia:v2 -n=chp09-set933"
#kubectl set image deployment kubia nodejs=luksa/kubia:v2 -n=chp09-set933
#echo ""

echo $HR

# Declarative style
echo "kubectl apply -f $FULLPATH/set933-3-kubia-deployment-v3.yaml --record"
kubectl apply -f $FULLPATH/set933-3-kubia-deployment-v3.yaml --record
echo $HR

echo "Rollout to BAD deployment:"
echo "kubectl rollout status deployment kubia -n=chp09-set933"
kubectl rollout status deployment kubia -n=chp09-set933
echo $HR

echo "kubectl get rs -n=chp09-set933 -o wide"
kubectl get rs -n=chp09-set933 -o wide
echo $HR

echo "kubectl get pods -n=chp09-set933 --show-labels"
kubectl get pods -n=chp09-set933 --show-labels
echo $HR

echo "curl $SVC_IP"
counter=1
while [ $counter -le 30 ]
do
  curl http://$SVC_IP 
  sleep 0.7
  ((counter++))
done
echo $HR

echo "Rollback to OK deployment:"
echo "kubectl rollout undo deployment kubia --to-revision=1 -n=chp09-set933"
kubectl rollout undo deployment kubia --to-revision=1 -n=chp09-set933
echo $HR

echo "curl $SVC_IP"
counter=1
while [ $counter -le 30 ]
do
  curl http://$SVC_IP 
  sleep 0.7
  ((counter++))
done
echo $HR

echo "kubectl rollout history deployment kubia -n=chp09-set933"
kubectl rollout history deployment kubia -n=chp09-set933
echo $HR

echo "kubectl delete ns chp09-set933"
kubectl delete ns chp09-set933
