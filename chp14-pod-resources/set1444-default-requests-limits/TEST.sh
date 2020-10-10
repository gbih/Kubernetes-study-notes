#!/bin/bash
. ~/src/common/setup.sh
FULLPATH=$(pwd)
echo "14.1.4 Applying default resource requests and limits"
echo $HR_TOP

((i++))


value=$(<set1444-1-limits.yaml)
echo "$value"

enter

echo "$i. Deploy the app"
echo ""

echo "kubectl apply -f $FULLPATH"
kubectl apply -f $FULLPATH/set1444-0-ns.yaml
kubectl apply -f $FULLPATH/set1444-1-limits.yaml
sleep 1

echo $HR

((i++))
echo "$i. Check created resources"
echo ""
echo "kubectl get limitrange -n=chp14-set1444 -o wide"
kubectl get limitrange -n=chp14-set1444 -o wide
echo ""

echo $HR

((i++))
echo "$i. Apply default resource requests and limits"
echo ""
echo "kubectl apply -f $FULLPATH/set1444-2-kubia-manual.yaml"
kubectl apply -f $FULLPATH/set1444-2-kubia-manual.yaml
echo ""

enter

echo "kubectl wait --for=condition=Ready pod/kubia-manual -n=chp14-set1444 --timeout=11s"
kubectl wait --for=condition=Ready pod/kubia-manual -n=chp14-set1444 --timeout=11s

echo $HR

echo "kubectl get pod/kubia-manual -n=chp14-set1444 -o wide"
kubectl get pod/kubia-manual -n=chp14-set1444 -o wide

enter

echo "$i. Inspecting limits that were applied to a pod automatically"
echo ""
echo "kubectl describe pod/kubia-manual -n=chp14-set1444"
kubectl describe pod/kubia-manual -n=chp14-set1444

echo $HR

((i++))
echo "$i. Clean-up"
echo ""
echo "kubectl delete -f $FULLPATH"
kubectl delete -f $FULLPATH
