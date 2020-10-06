#!/bin/bash
. ~/src/common/setup.sh
FULLPATH=$(pwd)

echo $HR_TOP

kubectl apply -f $FULLPATH
echo $HR

value=$(<set531-1-kubia-rc.yaml)
echo "$value"

enter

value=$(<set531-2-kubia-svc-nodeport.yaml)
echo "$value"

enter

echo "POD2=\$(kubectl get pods -n=chp05-set531 -o jsonpath={'.items[2].metadata.name'})"

POD0=$(kubectl get pods -n=chp05-set531 -o jsonpath={'.items[0].metadata.name'})
POD1=$(kubectl get pods -n=chp05-set531 -o jsonpath={'.items[1].metadata.name'})
POD2=$(kubectl get pods -n=chp05-set531 -o jsonpath={'.items[2].metadata.name'})

echo "kubectl wait --for=condition=Ready=True pods/$POD2 -n=chp05-set531 --timeout=30s"
kubectl wait --for=condition=Ready=True pods/$POD2 -n=chp05-set531 --timeout=30s

echo $HR

echo "kubectl get all -n=chp05-set531 --show-labels -o wide"
kubectl get all -n=chp05-set531 --show-labels -o wide

echo $HR

echo "kubectl get endpoints -n=chp05-set531 --show-labels"
kubectl get endpoints -n=chp05-set531 --show-labels

echo $HR

echo "kubectl get rc kubia -n=chp05-set531 --show-labels"
kubectl get rc kubia -n=chp05-set531 --show-labels

echo $HR

echo "curl http://localhost:30123"
curl http://localhost:30123
echo ""

echo "NODE_IP=\$(kubectl get nodes -o jsonpath='{.items[*].status.addresses[?(@.type=="InternalIP")].address}')"
NODE_IP=$(kubectl get nodes -o jsonpath='{.items[*].status.addresses[?(@.type=="InternalIP")].address}')
echo ""

echo "http://$NODE_IP:30123 (this also works in a browser)"
curl $NODE_IP:30123

echo $HR

echo "kubectl delete -f $FULLPATH"
kubectl delete -f $FULLPATH
