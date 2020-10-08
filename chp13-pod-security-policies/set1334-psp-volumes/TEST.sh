#!/bin/bash
. ~/src/common/setup.sh
FULLPATH=$(pwd)
echo "Constraining the types of volumes pods can use"
echo $HR_TOP

((i++))


value=$(<set1334-1-psp-volumes.yaml)
echo "$value"

enter

value=$(<set1334-2-emptyDir.yaml)
echo "$value"

enter

echo "cat /var/snap/microk8s/current/args/kube-apiserver"
echo ""
cat /var/snap/microk8s/current/args/kube-apiserver
echo ""
echo "See more options here: https://kubernetes.io/docs/reference/command-line-tools-reference/kube-apiserver/"

enter

echo "$i. Deploying the app"
echo ""

echo "kubectl apply -f $FULLPATH"
kubectl apply -f $FULLPATH/set1334-0-ns.yaml
kubectl apply -f $FULLPATH/set1334-1-psp-volumes.yaml
sleep 2

echo $HR 

((i++))
echo "$i. Check objects"
echo ""

echo "kubectl get all -n=chp13-set1334 -o wide"
kubectl get all -n=chp13-set1334 -o wide
echo ""

echo "kubectl get psp"
kubectl get psp

echo $HR

((i++))
echo "kubectl apply -f $FULLPATH/set1334-2-emptyDir.yaml"
echo ""
kubectl apply -f $FULLPATH/set1334-2-emptyDir.yaml


echo $HR

((i++))
echo "$i. Clean-up"
echo ""
echo "kubectl delete -f $FULLPATH"
kubectl delete -f $FULLPATH --ignore-not-found
