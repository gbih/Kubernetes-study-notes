#!/bin/bash
. ~/src/SETUP.sh
FULLPATH=$(pwd)

((i++))

cat <<- "NOTES"
NOTES: 
Constraining the types of volumes pods can use

The last thing a PodSecurityPolicy resource can do is define which volume types users can add to their pods. At the minimum, a PodSecurityPolicy should allow using at least the emptyDir, configMap, secret, downwardAPI, and the persistentVolume- Claim volumes. The pertinent part of such a PodSecurityPolicy resource is shown in the following listing.

If multiple PodSecurityPolicy resources are in place, pods can use any volume type defined in any of the policies (the union of all volumes lists is used).
NOTES

enter

value=$(<set1334-1-psp-volumes.yaml)
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
echo "$i. Check objects and node"
echo ""

echo "kubectl get all -n=chp13-set1334 -o wide"
kubectl get all -n=chp13-set1334 -o wide
echo ""

echo "kubectl get node"
kubectl get node
echo ""

echo "kubectl get psp"
kubectl get psp

echo $HR

((i++))
echo "kubectl apply -f $FULLPATH/set1334-2-emptyDir.yaml"
kubectl apply -f $FULLPATH/set1334-2-emptyDir.yaml


echo $HR

((i++))
echo "$i. Clean-up"
echo ""
echo "kubectl delete -f $FULLPATH"
kubectl delete -f $FULLPATH
