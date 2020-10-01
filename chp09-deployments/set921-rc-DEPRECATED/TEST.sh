#!/bin/bash
. ~/src/SETUP.sh
FULLPATH=$(pwd)

kubectl delete ns chp09-set921 --now

echo "NOTES:"

echo "Automatic rollout with ReplicationController" 
echo "In a separate window, type this:"
echo "kubectl get rc -n=chp09-set921 -o wide -w"
echo $HR

kubectl apply -f $FULLPATH
sleep 1

echo $HR

POD0=$(kubectl get pods -n=chp09-set921 -o jsonpath={'.items[0].metadata.name'})
echo "kubectl wait --for=condition=Ready=True pods/$POD0 -n=chp09-set921 --timeout=20s"
kubectl wait --for=condition=Ready=True pods/$POD0 -n=chp09-set921 --timeout=20s
echo $HR

SVC_IP=$(kubectl get svc/kubia -n=chp09-set921 -o jsonpath={'.status.loadBalancer.ingress[0].ip'})

echo "Test curl on pod"
echo "curl http://$SVC_IP"
curl http://$SVC_IP
echo ""

echo "kubectl get pods -n=chp09-set921 --show-labels"
kubectl get pods -n=chp09-set921 --show-labels
echo ""

echo "kubectl get svc -n=chp09-set921 -o wide"
kubectl get svc -n=chp09-set921 -o wide
echo ""

echo "kubectl get rc -n=chp09-set921 -o wide"
kubectl get rc -n=chp09-set921 -o wide

echo $HR

echo "In a separate terminal window, type this to see the rolling-update change:"
echo ""
echo "while true; do curl $SVC_IP; done"
echo $HR

read -p "Press enter to continue rolling-update:"
echo $HR


echo "default:   --timeout=5m0s"
echo $HR

echo "kubectl rollout kubia-v1 kubia-v2 --image=luksa/kubia:v2 -n=chp09-set921"
kubectl rolling-update kubia-v1 kubia-v2 --image=luksa/kubia:v2 -n=chp09-set921
echo $HR









sleep 5

echo "kubectl get rc -n=chp09-set921 -o wide"
kubectl get rc -n=chp09-set921 -o wide
echo $HR


echo "kubectl get pods -n=chp09-set921 --show-labels"
kubectl get pods -n=chp09-set921 --show-labels
echo $HR

#echo "kubectl get events -n=chp09-set921"
#kubectl get events -n=chp09-set921
#echo $HR

echo "kubectl delete -f $FULLPATH"
kubectl delete ns chp09-set921
echo $HR

