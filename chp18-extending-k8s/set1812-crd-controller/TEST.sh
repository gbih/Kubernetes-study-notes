#!/bin/bash
. ~/src/common/setup.sh
echo "18.1.2 Automating custom resources with custom controllers"
echo $HR_TOP
FULLPATH=$(pwd)

echo "kubectl apply -f $FULLPATH/set1812-0-ns.yaml"
kubectl apply -f $FULLPATH/set1812-0-ns.yaml
echo $HR


# Need this order, at least PSP/RBAC before the crd stuff.

echo "kubectl apply -f $FULLPATH/setup-sa.yaml"
#echo "kubectl apply -f $FULLPATH/setup-psp.yaml"
#echo "kubectl apply -f $FULLPATH/setup-role-rolebinding.yaml"
echo "kubectl apply -f $FULLPATH/setup-clusterrole-clusterrolebinding.yaml"

kubectl apply -f $FULLPATH/setup-sa.yaml
#kubectl apply -f $FULLPATH/setup-psp.yaml
#kubectl apply -f $FULLPATH/setup-role-rolebinding.yaml
kubectl apply -f $FULLPATH/setup-clusterrole-clusterrolebinding.yaml

enter

echo "kubectl apply -f $FULLPATH/set1812-1-crd-website.yaml"
kubectl apply -f $FULLPATH/set1812-1-crd-website.yaml
enter

echo "kubectl apply -f $FULLPATH/set1812-2-website-controller.yaml"
kubectl apply -f $FULLPATH/set1812-2-website-controller.yaml
echo $HR

echo "kubectl rollout status deployment website-controller -n=chp18-set1812"
kubectl rollout status deployment website-controller -n=chp18-set1812
enter

echo "kubectl apply -f $FULLPATH/set1812-3-website-kubia.yaml"
kubectl apply -f $FULLPATH/set1812-3-website-kubia.yaml
enter

kubectl apply -f $FULLPATH
enter

echo "kubectl get website kubia -n=chp18-set1812 -o yaml"
kubectl get website kubia -n=chp18-set1812 -o yaml
echo $HR

echo "kubectl get all -n=chp18-set1812"
kubectl get all -n=chp18-set1812
echo $HR

echo "Press enter to start deleting objects"

enter

echo "kubectl delete website kubia -n=chp18-set1812"
kubectl delete website kubia -n=chp18-set1812

enter

echo "kubectl delete -f $FULLPATH"
kubectl delete -f $FULLPATH --ignore-not-found

