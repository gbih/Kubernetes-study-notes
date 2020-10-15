#!/bin/bash
. ~/src/common/setup.sh
FULLPATH=$(pwd)
echo "16.3.2 Deploying pods in the same rack, availability zone, or geographic region"
echo $HR_TOP

# Control-plane node
echo "Control-plane node"
echo "kubectl taint node actionbook-vm node-type=master:NoSchedule"
kubectl taint node actionbook-vm node-type=master:NoSchedule

echo $HR

echo "kubectl label node -l name=node1-vm rack=rack1"
kubectl label node -l name=node1-vm rack=rack1
echo ""

echo "kubectl label node -l name=node2-vm rack=rack2"
kubectl label node -l name=node2-vm rack=rack2

echo $HR

echo "kubectl get node -L rack"
kubectl get node -L rack

enter

echo "kubectl apply -f $FULLPATH"
kubectl apply -f $FULLPATH

enter

echo "Getting taints, style 1"
echo "kubectl get nodes -o json | jq '.items[].spec.taints'"
kubectl get nodes -o json | jq '.items[].spec.taints'
echo $HR

echo "Alternative 2"
echo "kubectl get nodes -o=custom-columns=NAME:.metadata.name,TAINTS:.spec.taints,LABEL-NAME:.metadata.labels.name,LABEL-ENV:.metadata.labels.env"
kubectl get nodes -o=custom-columns=NAME:.metadata.name,TAINTS:.spec.taints,LABEL-NAME:.metadata.labels.name,LABEL-ENV:.metadata.labels.env

enter

echo "kubectl wait --for=condition=Ready=True pods/curl-restrictive -n=chp16-set1632 --timeout=10s"
kubectl wait --for=condition=Ready=True pods/curl-restrictive -n=chp16-set1632 --timeout=10s

enter

echo "kubectl rollout status deployment backend -n=chp16-set1632"
kubectl rollout status deployment backend -n=chp16-set1632

echo $HR

echo "Check PSP is set-up correctly by accessing API server."
echo "We use RoleBinding with Role resource and ServiceAccount"
echo ""

echo "kubectl exec -it curl-restrictive -n chp16-set1632 -- curl localhost:8001/api/v1/namespaces/chp16-set1632/services | jq 'del(.metadata.uid, .items[].metadata.managedFields, .items[].metadata.annotations, .status)' | yq r -P -"
echo ""

kubectl exec -it curl-restrictive -n chp16-set1632 -- curl localhost:8001/api/v1/namespaces/chp16-set1632/services | jq 'del(.metadata.uid, .items[].metadata.managedFields, .items[].metadata.annotations, .status)' | yq r -P -


echo $HR

echo "Press enter to delete taints and objects"

enter
echo "Remove taints"
echo "kubectl taint node actionbook-vm node-type=master:NoSchedule-"
kubectl taint node actionbook-vm node-type=master:NoSchedule-

echo $HR

echo "Remove labels"

echo "kubectl label node -l name=node1-vm rack-"
echo "kubectl label node -l name=node2-vm rack-"
kubectl label node -l name=node1-vm rack-
kubectl label node -l name=node2-vm rack-

echo $HR

echo "kubectl delete -f $FULLPATH"
kubectl delete -f $FULLPATH --ignore-not-found

