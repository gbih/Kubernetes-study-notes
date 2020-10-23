#!/bin/bash
. ~/src/common/setup.sh
FULLPATH=$(pwd)
echo "12.2.5 Understanding default ClusterRoles and ClusterRoleBindings"
echo $HR_TOP

echo "kubectl get clusterroles"
kubectl get clusterroles

enter

echo "kubectl describe clusterrole admin"
kubectl describe clusterrole admin

enter

echo "kubectl describe clusterrole cluster-admin"
kubectl describe clusterrole cluster-admin

enter

echo "kubectl describe clusterrole edit"
kubectl describe clusterrole edit

enter

echo "kubectl describe clusterrole view"
kubectl describe clusterrole view

enter

echo "kubectl describe clusterrole system:node"
kubectl describe clusterrole system:node

enter

echo "kubectl describe clusterrole system:kube-scheduler"
kubectl describe clusterrole system:kube-scheduler

enter

echo "kubectl describe clusterrole system:node"
kubectl describe clusterrole system:node

enter

echo "kubectl get clusterrolebindings"
kubectl get clusterrolebindings

enter

echo "kubectl describe clusterrolebinding admin"
kubectl describe clusterrolebinding admin

enter

echo "kubectl describe clusterrolebinding cluster-admin"
kubectl describe clusterrolebinding cluster-admin

