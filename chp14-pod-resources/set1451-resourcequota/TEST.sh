#!/bin/bash
. ~/src/common/setup.sh
FULLPATH=$(pwd)
echo "Introducing the ResourceQuota object"
echo $HR_TOP

((i++))


value=$(<set1451-1-quota-cpu-memory.yaml)
echo "$value"

enter

echo "$i. Deploy the app"
echo ""

echo "kubectl apply -f $FULLPATH"
kubectl apply -f $FULLPATH/set1451-0-ns.yaml
kubectl apply -f $FULLPATH/set1451-1-quota-cpu-memory.yaml
kubectl apply -f $FULLPATH/set1451-2-limits.yaml
sleep 1

echo $HR

((i++))
echo "$i. Check created resources"
echo ""
echo "kubectl get quota -n=chp14-set1451 -o wide"
kubectl get quota -n=chp14-set1451 -o wide
echo ""

echo $HR

((i++))
echo "$i. Apply default resource requests and limits"
echo ""
echo "kubectl apply -f $FULLPATH/set1451-3-kubia-manual.yaml"
kubectl apply -f $FULLPATH/set1451-3-kubia-manual.yaml
echo ""

enter

#echo "$i. Inspecting limits that were applied to a pod automatically"
#echo ""
#echo "kubectl describe pod/kubia-manual -n=chp14-set1451"
#kubectl describe pod/kubia-manual -n=chp14-set1451

echo "kubectl describe quota -n=chp14-set1451"
echo ""
kubectl describe quota -n=chp14-set1451


echo $HR

((i++))
echo "$i. Clean-up"
echo ""
echo "kubectl delete -f $FULLPATH"
kubectl delete -f $FULLPATH
