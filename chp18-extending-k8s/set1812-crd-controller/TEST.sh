#!/bin/bash
. ~/src/common/setup.sh
echo "18.1.2 Automating custom resources with custom controllers"
echo $HR_TOP
FULLPATH=$(pwd)

echo "Create objects"
kubectl apply -f $FULLPATH/set1812-0-ns.yaml
kubectl apply -f $FULLPATH/set1812-1-sa.yaml
kubectl apply -f $FULLPATH/set1812-2-psp.yaml
kubectl apply -f $FULLPATH/set1812-3-customrole.yaml
kubectl apply -f $FULLPATH/set1812-4-customrolebinding.yaml


echo "kubectl apply -f $FULLPATH/set1812-5-website-crd.yaml"
kubectl apply -f $FULLPATH/set1812-5-website-crd.yaml

echo "kubectl apply -f $FULLPATH/set1812-6-website-controller.yaml"
kubectl apply -f $FULLPATH/set1812-6-website-controller.yaml

echo "kubectl rollout status deployment website-controller -n=chp18-set1812"
kubectl rollout status deployment website-controller -n=chp18-set1812
echo $HR

echo "kubectl apply -f $FULLPATH/set1812-7-website-kubia.yaml"
kubectl apply -f $FULLPATH/set1812-7-website-kubia.yaml
echo $HR

echo "kubectl get all -n=chp18-set1812"
kubectl get all -n=chp18-set1812
echo $HR

echo "RBAC TESTS:"
echo "kubectl auth --as=system:serviceaccount:chp18-set1812:website-controller can-i get websites.extensions.example.com"
kubectl auth --as=system:serviceaccount:chp18-set1812:website-controller can-i get websites.extensions.example.com
echo $HR

echo "kubectl auth --as=system:serviceaccount:chp18-set1812:website-controller can-i create pods"
kubectl auth --as=system:serviceaccount:chp18-set1812:website-controller can-i create pods
echo $HR

echo "kubectl auth --as=system:serviceaccount:chp18-set1812:website-controller can-i create deployments"
kubectl auth --as=system:serviceaccount:chp18-set1812:website-controller can-i create deployments
echo $HR

echo "kubectl auth --as=system:serviceaccount:chp18-set1812:website-controller can-i create replicasets"
kubectl auth --as=system:serviceaccount:chp18-set1812:website-controller can-i create replicasets
echo $HR

echo "Press enter to start deleting objects"

enter

echo "kubectl delete -f $FULLPATH"
kubectl delete -f $FULLPATH --ignore-not-found
