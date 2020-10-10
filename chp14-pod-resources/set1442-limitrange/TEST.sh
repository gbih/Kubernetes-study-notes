#!/bin/bash
. ~/src/common/setup.sh
FULLPATH=$(pwd)
echo "Creating a LimitRange object"
echo $HR_TOP

((i++))


value=$(<set1442-1-limitrange.yaml)
echo "$value"

enter

echo "$i. Deploy the app"
echo ""

echo "kubectl apply -f $FULLPATH"
kubectl apply -f $FULLPATH/set1442-0-ns.yaml
kubectl apply -f $FULLPATH/set1442-1-limitrange.yaml
kubectl apply -f $FULLPATH/psp.yaml
sleep 1

echo $HR

((i++))
echo "$i. Check created resources"
echo ""
echo "kubectl get limitrange -n=chp14-set1442 -o wide"
kubectl get limitrange -n=chp14-set1442 -o wide

echo $HR


((i++))
echo "$i. Enforce Resource Limits"
echo ""

echo "kubectl apply -f $FULLPATH/set1442-2-pod-too-big.yaml"
kubectl apply -f $FULLPATH/set1442-2-pod-too-big.yaml
echo ""
echo "The pod's single container is requesting two CPUs, which is more than the maximum
you set in the LimitRange earlier."


echo $HR

((i++))
echo "$i. Clean-up"
echo ""
echo "kubectl delete -f $FULLPATH"
kubectl delete -f $FULLPATH --ignore-not-found
