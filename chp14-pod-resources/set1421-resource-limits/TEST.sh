#!/bin/bash
. ~/src/common/setup.sh
FULLPATH=$(pwd)
echo "14.2.1 Setting a hard limit for the amount of resources a container can use"
echo $HR_TOP
((i++))


value=$(<set1421-1-limited-pod.yaml)
echo "$value"

enter

echo "$i. Deploy the app"
echo ""

echo "kubectl apply -f $FULLPATH"
kubectl apply -f $FULLPATH --record
sleep 1
echo ""
echo "kubectl wait --for=condition=Ready pod/limited-pod -n=chp14-set1421 --timeout=11s"
kubectl wait --for=condition=Ready pod/limited-pod -n=chp14-set1421 --timeout=11s

echo $HR

((i++))
echo "$i. Check created resources"
echo ""
echo "kubectl get pods -n=chp14-set1421 -o wide"
kubectl get pods -n=chp14-set1421 -o wide --sort-by=.status.podIP

echo $HR
echo "kubectl get psp"
kubectl get psp
echo $HR

((i++))
echo "$i. Examine CPU and memory usage from within a container"
echo "Hit ctrl-c or q to escape:"
echo ""
echo "kubectl exec -n=chp14-set1421 -it limited-pod -- top"

enter

kubectl exec -n=chp14-set1421 -it limited-pod -- top

enter

((i++))
echo "$i. Inspecting allocated resources on a node with kubectl describe node"
echo "kubectl describe node"
kubectl describe node

echo $HR

((i++))
echo "$i. Clean-up"
echo ""
echo "kubectl delete -f $FULLPATH"
kubectl delete -f $FULLPATH

