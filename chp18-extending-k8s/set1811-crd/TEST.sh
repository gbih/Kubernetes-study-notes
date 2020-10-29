#!/bin/bash
. ~/src/common/setup.sh
echo "18.1.1 Introducing CustomResourceDefinitions"
echo $HR_TOP
FULLPATH=$(pwd)

echo "kubectl apply -f $FULLPATH/set1811-0-ns.yaml"
kubectl apply -f $FULLPATH/set1811-0-ns.yaml

echo $HR

echo "Create a CustomResourceDefinition"
echo ""
echo "kubectl apply -f $FULLPATH/set1811-1-crd-website.yaml"
kubectl apply -f $FULLPATH/set1811-1-crd-website.yaml
echo $HR

echo "kubectl get crd"
kubectl get crd

enter

echo "Create custom object"
echo ""
echo "kubectl apply -f $FULLPATH/set1811-2-website-kubia.yaml"
kubectl apply -f $FULLPATH/set1811-2-website-kubia.yaml

enter

echo "kubectl get website kubia -n=chp18-set1811 -o yaml"
kubectl get website kubia -n=chp18-set1811 -o yaml

enter

echo "kubectl delete website kubia -n=chp18-set1811"
kubectl delete website kubia -n=chp18-set1811

enter

echo "kubectl delete -f $FULLPATH"
kubectl delete -f $FULLPATH --ignore-not-found

