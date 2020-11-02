#!/bin/bash
. ~/src/common/setup.sh
echo "18.1.1b CRD with RBAC and ServiceAccount"
echo $HR_TOP
FULLPATH=$(pwd)

echo "kubectl apply -f set1811b-0-ns.yaml"
kubectl apply -f set1811b-0-ns.yaml

echo $HR

echo "kubectl apply -f set1811b-1-sa.yaml"
kubectl apply -f set1811b-1-sa.yaml

echo $HR

echo "kubectl apply -f set1811b-2-crd-website.yaml"
kubectl apply -f set1811b-2-crd-website.yaml
echo ""
echo "kubectl api-resources --api-group extensions.example.com"
kubectl api-resources --api-group extensions.example.com

echo $HR

echo "kubectl apply -f set1811b-3-website-kubia.yaml"
kubectl apply -f set1811b-3-website-kubia.yaml
echo ""
echo "kubectl get websites -n chp18-set1811b"
kubectl get websites -n chp18-set1811b

echo $HR

echo "Check Authorization in behalf of the ServiceAccount"

echo "kubectl auth can-i get websites.extensions.example.com --as=system:serviceaccount:chp18-set1811b:crd-reader"
kubectl auth can-i get websites.extensions.example.com --as=system:serviceaccount:chp18-set1811b:crd-reader

enter

echo "kubectl apply -f set1811b-4-clusterrole.yaml"
kubectl apply -f set1811b-4-clusterrole.yaml
echo ""
echo "kubectl get clusterrole example.com:website:reader"
kubectl get clusterrole example.com:website:reader

echo $HR

echo "kubectl apply -f set1811b-5-clusterrolebinding.yaml"
kubectl apply -f set1811b-5-clusterrolebinding.yaml
echo ""
echo "kubectl get clusterrolebinding example.com:website:crd-reader"
kubectl get clusterrolebinding example.com:website:crd-reader

echo $HR

echo "kubectl auth can-i get websites.extensions.example.com --as=system:serviceaccount:chp18-set1811b:crd-reader"
kubectl auth can-i get websites.extensions.example.com --as=system:serviceaccount:chp18-set1811b:crd-reader

echo $HR

echo "delete all resources"

enter

echo "kubectl delete -f $FULLPATH"
kubectl delete -f $FULLPATH

