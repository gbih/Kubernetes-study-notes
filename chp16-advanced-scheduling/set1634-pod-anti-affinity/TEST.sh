#!/bin/bash
. ~/src/common/setup.sh
FULLPATH=$(pwd)
echo "16.3.4 Scheduling pods away from each other with pod anti-affinity"
echo $HR_TOP

# Control-plane node
echo "Control-plane node"
echo "kubectl taint node actionbook-vm node-type=master:NoSchedule"
kubectl taint node actionbook-vm node-type=master:NoSchedule

echo $HR
echo "kubectl label node -l name=node1-vm availability-zone=zone1"
kubectl label node -l name=node1-vm availability-zone=zone1
echo ""

echo "kubectl label node -l name=node1-vm share-type=dedicated"
kubectl label node -l name=node1-vm share-type=dedicated
echo ""

echo "kubectl label node -l name=node2-vm availability-zone=zone2"
kubectl label node -l name=node2-vm availability-zone=zone2
echo ""

echo "kubectl label node -l name=node2-vm share-type=shared"
kubectl label node -l name=node2-vm share-type=shared

echo $HR

echo "kubectl get node -L availability-zone -L share-type"
kubectl get node -L availability-zone -L share-type

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



echo "kubectl wait --for=condition=Ready=True pods/curl-restrictive -n=chp16-set1634 --timeout=10s"
kubectl wait --for=condition=Ready=True pods/curl-restrictive -n=chp16-set1634 --timeout=10s

enter

echo "kubectl rollout status deployment backend -n=chp16-set1634"
kubectl rollout status deployment backend -n=chp16-set1634

echo $HR

echo "Check PSP is set-up correctly by accessing API server."
echo "We use RoleBinding with Role resource and ServiceAccount"
echo ""

echo "kubectl exec -it curl-restrictive -n chp16-set1634 -- curl localhost:8001/api/v1/namespaces/chp16-set1634/services | jq 'del(.metadata.uid, .items[].metadata.managedFields, .items[].metadata.annotations, .status)' | yq r -P -"
echo ""

kubectl exec -it curl-restrictive -n chp16-set1634 -- curl localhost:8001/api/v1/namespaces/chp16-set1634/services | jq 'del(.metadata.uid, .items[].metadata.managedFields, .items[].metadata.annotations, .status)' | yq r -P -


echo $HR

echo "Press enter to delete taints and objects"

enter
echo "Remove taints"
echo "kubectl taint node actionbook-vm node-type=master:NoSchedule-"
kubectl taint node actionbook-vm node-type=master:NoSchedule-

echo $HR

echo "Remove labels"

echo "kubectl label node -l name=node1-vm availability-zone-"
echo "kubectl label node -l name=node1-vm share-type-"
echo "kubectl label node -l name=node2-vm availability-zone-"
echo "kubectl label node -l name=node2-vm share-type-"

kubectl label node -l name=node1-vm availability-zone-
kubectl label node -l name=node1-vm share-type-
kubectl label node -l name=node2-vm availability-zone-
kubectl label node -l name=node2-vm share-type-

echo $HR

echo "kubectl delete -f $FULLPATH"
kubectl delete -f $FULLPATH --ignore-not-found

