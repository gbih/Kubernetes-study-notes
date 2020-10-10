#!/bin/bash
. ~/src/common/setup.sh
FULLPATH=$(pwd)
echo "12.2.4 Using ClusterRoles and ClusterRoleBindings"
echo $HR_TOP

echo "kubectl apply -f $FULLPATH"
kubectl apply -f $FULLPATH

echo $HR

echo "kubectl describe clusterrole pv-reader"
echo ""
kubectl describe clusterrole pv-reader
echo $HR

echo "kubectl get clusterrole pv-reader -o json | jq 'del(.metadata.managedFields, .metadata.annotations, .metadata.selfLink, .metadata.uid, .metadata.resourceVersion)' | yq r -P -"
echo ""
kubectl get clusterrole pv-reader -o json | jq 'del(.metadata.managedFields, .metadata.annotations, .metadata.selfLink, .metadata.uid, .metadata.resourceVersion)' | yq r -P -

enter

echo "kubectl get clusterrole"
kubectl get clusterrole

enter

echo "kubectl get clusterrolebinding"
kubectl get clusterrolebinding

enter

echo "kubectl describe clusterrole view"
kubectl describe clusterrole view

enter

echo "kubectl describe clusterrole admin"
kubectl describe clusterrole admin

enter

echo "kubectl delete -f $FULLPATH"
kubectl delete -f $FULLPATH

