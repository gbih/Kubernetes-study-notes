#!/bin/bash
. ~/src/common/setup.sh
FULLPATH=$(pwd)
echo "Creating pods with resource requests"
echo $HR_TOP

((i++))

value=$(<set141-2-requests-pod.yaml)
echo "$value"

enter

echo "$i. Deploy the app"
echo ""

echo "kubectl apply -f $FULLPATH"
kubectl apply -f ../PSP
kubectl apply -f $FULLPATH --record


sleep 1
echo ""
echo "kubectl wait --for=condition=Ready pod/requests-pod -n=chp14-set1410 --timeout=11s"
kubectl wait --for=condition=Ready pod/requests-pod -n=chp14-set1410 --timeout=11s

echo $HR

((i++))
echo "$i. Check created resources"
echo ""
echo "kubectl get pods -n=chp14-set1410"
kubectl get pods -n=chp14-set1410 --sort-by=.status.podIP

echo $HR

((i++))
echo "$i. Examine CPU and memory usage from within a container"
echo "Hit ctrl-c or q to escape:"
echo ""

echo "kubectl exec -n=chp14-set1410 -it requests-pod top"
enter

kubectl exec -n=chp14-set1410 -it requests-pod top

echo ""
echo "We have 1 CPU core allocated to this Multipass VM, for reference."
echo "Hence, if the process is shown consuming 90%, it is consuming 90% of the whole CPU."
echo "This exceeds the 200 milicores we requested in the pod spec."
echo "This is expected, because requests do not limit the amount of CPU a container can use."
echo "We need to specify a CPU limit to do that."


#enter
echo $HR

((i++))
echo "$i. Clean-up"
echo ""
echo "kubectl delete -f $FULLPATH"
kubectl delete -f $FULLPATH
kubectl delete -f ../PSP
