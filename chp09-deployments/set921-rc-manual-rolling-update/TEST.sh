#!/bin/bash
. ~/src/COMMON/SETUP.sh
FULLPATH=$(pwd)
echo $HR_TOP

echo "NOTES:"

echo "Automatic rollout with ReplicationController" 
echo "In a separate window, type this:"
echo "kubectl get rc -n=chp09-set921 -o wide -w"
echo $HR

echo "kubectl apply -f set921-0-namespace.yaml"
echo "kubectl apply -f set921-1-kubia-rc-v1.yaml"
echo "kubectl apply -f set921-2-kubia-service.yaml"
kubectl apply -f set921-0-namespace.yaml
kubectl apply -f set921-1-kubia-rc-v1.yaml
kubectl apply -f set921-2-kubia-service.yaml
sleep 1

echo $HR

# Need to manually track these pods so we can later delete them one by one
POD0=$(kubectl get pods -n=chp09-set921 -o jsonpath={'.items[0].metadata.name'})
POD1=$(kubectl get pods -n=chp09-set921 -o jsonpath={'.items[1].metadata.name'})
POD2=$(kubectl get pods -n=chp09-set921 -o jsonpath={'.items[2].metadata.name'})

echo "kubectl wait --for=condition=Ready=True pods/$POD0 -n=chp09-set921 --timeout=20s"
kubectl wait --for=condition=Ready=True pods/$POD0 -n=chp09-set921 --timeout=20s
echo $HR


echo "kubectl get all -n=chp09-set921 -o wide --show-labels"
kubectl get all -n=chp09-set921 -o wide --show-labels

echo $HR


SVC_IP=$(kubectl get svc/kubia -n=chp09-set921 -o jsonpath={'.status.loadBalancer.ingress[0].ip'})

echo "Test curl on pod"
echo "curl http://$SVC_IP"
curl http://$SVC_IP
echo ""

echo $HR

echo "In a separate terminal window, type this to see the rolling-update change:"
echo ""
echo "while true; do curl $SVC_IP; done"
echo $HR

read -p "Press enter to continue rolling-update:"
echo $HR

############################
# Update manually

echo "kubectl apply -f set921-3-kubia-rc-v2.yaml"
kubectl apply -f set921-3-kubia-rc-v2.yaml
sleep 3
echo ""
echo "kubectl get all -n=chp09-set921 --show-labels"
kubectl get all -n=chp09-set921 --show-labels

enter

echo "kubectl get all -n=chp09-set921 --show-labels"
kubectl get all -n=chp09-set921 --show-labels

# 1 Scale the new (+1) and old (-1) controllers one by one
echo "kubectl scale --replicas=2 replicationcontroller/kubia-v2 -n=chp09-set921"
echo "kubectl scale --replicas=2 replicationcontroller/kubia-v1 -n=chp09-set921"
kubectl scale --replicas=2 replicationcontroller/kubia-v2 -n=chp09-set921
kubectl scale --replicas=2 replicationcontroller/kubia-v1 -n=chp09-set921
sleep 3
echo ""
echo "kubectl get all -n=chp09-set921 --show-labels"
kubectl get all -n=chp09-set921 --show-labels

enter


# 2 Scale the new (+1) and old (-1) controllers one by one
echo "kubectl scale --replicas=3 replicationcontroller/kubia-v2 -n=chp09-set921"
echo "kubectl scale --replicas=1 replicationcontroller/kubia-v1 -n=chp09-set921"
kubectl scale --replicas=3 replicationcontroller/kubia-v2 -n=chp09-set921
kubectl scale --replicas=1 replicationcontroller/kubia-v1 -n=chp09-set921
sleep 3
echo ""
echo "kubectl get all -n=chp09-set921 --show-labels"
kubectl get all -n=chp09-set921 --show-labels

enter


# 3 Scale the new (+1) and old (-1) controllers one by one
echo "kubectl scale --replicas=0 replicationcontroller/kubia-v1 -n=chp09-set921"
kubectl scale --replicas=0 replicationcontroller/kubia-v1 -n=chp09-set921
sleep 3
echo ""
echo "kubectl get all -n=chp09-set921 --show-labels"
kubectl get all -n=chp09-set921 --show-labels

enter


echo "kubectl get events -n=chp09-set921"
kubectl get events -n=chp09-set921
echo $HR

echo "kubectl delete -f $FULLPATH"
kubectl delete ns chp09-set921
echo $HR

