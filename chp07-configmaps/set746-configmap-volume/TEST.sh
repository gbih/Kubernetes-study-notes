#!/bin/bash
. ../../SETUP.sh
FULLPATH=$(pwd)
echo $HR_TOP

echo "kubectl apply -f $FULLPATH"
kubectl apply -f $FULLPATH
sleep 3
echo $HR

value=$(<set746-1-configmap-volume.yaml)
echo "$value"

enter

value=$(<set746-2-fortune-pod-env-configmap.yaml)
echo "$value"

enter

value=$(<set746-3-service.yaml)
echo "$value"

enter

echo "kubectl wait --for=condition=Ready=True pod/fortune-configmap-volume -n=chp07-set746 --timeout=20s"
kubectl wait --for=condition=Ready=True pod/fortune-configmap-volume -n=chp07-set746 --timeout=20s
echo $HR

echo "kubectl get all -n=chp07-set746 --show-labels"
kubectl get all -n=chp07-set746 --show-labels
echo $HR

CLUSTER_IP=$(kubectl get service/fortune-configmap-volume -n=chp07-set746 -o jsonpath={'.spec.clusterIP'})

echo "Verify Nginx is using the mounted config file."
echo "We test if the nginx response has compression enabled."
echo ""
echo 'curl -H "Accept-Encoding: gzip" -I $CLUSTER_IP'
curl -H "Accept-Encoding: gzip" -I $CLUSTER_IP

enter

echo "kubectl describe configmap fortune-config -n=chp07-set746"
echo ""
kubectl describe configmap fortune-config -n=chp07-set746
echo $HR

enter

echo "kubectl describe pod/fortune-configmap-volume -n=chp07-set746"
echo ""
kubectl describe pod/fortune-configmap-volume -n=chp07-set746

echo $HR

echo "kubectl delete -f $FULLPATH"
kubectl delete -f $FULLPATH

