#!/bin/bash
. ~/src/common/setup.sh
FULLPATH=$(pwd)
echo "Adding individual kernel capabilities to a container"
echo $HR_TOP


value=$(<set1324-1-pod-add-settime-capability.yaml)
echo "$value"

enter

#value=$(<PSP/podsecuritypolicy.yaml)
#echo "$value"

#enter

((i++))

echo "$i. Deploying the app"
echo ""

echo "kubectl apply -f $FULLPATH"
kubectl apply -f $FULLPATH --record
echo $HR

echo "kubectl wait --for=condition=Ready pod/pod-add-settime-capability -n=chp13-set1324 --timeout=21s"
kubectl wait --for=condition=Ready pod/pod-add-settime-capability -n=chp13-set1324 --timeout=21s

echo $HR 

((i++))
echo "$i. Check resources"
echo ""
echo "kubectl get pods -n=chp13-set1324 -o wide"
kubectl get pods -n=chp13-set1324 -o wide --sort-by=.status.podIP
echo ""
echo "kubectl get node"
kubectl get node

enter

((i++))
echo "kubectl -n=chp13-set1324 exec -it pod-add-settime-capability -- -sh -c 'date +%T -s "12:00:00"'"
kubectl -n=chp13-set1324 exec -it pod-add-settime-capability -- sh -c 'date +%T -s "12:00:00"'
echo ""
echo "It seems this is working with privileged:true, but not with this capabilities setting..."
echo ""

echo "kubectl -n=chp13-set1324 exec -it pod-add-settime-capability -- sh -c 'date'"
kubectl -n=chp13-set1324 exec -it pod-add-settime-capability -- sh -c 'date'
echo ""

echo $HR

echo "With a pod with regular privileges, it is not allowed to change the system time:"
echo "kubectl exec -it pod-regular -n=chp13-set1324 -- sh -c 'date +%T -s "12:00:00"'"
kubectl exec -it pod-regular -n=chp13-set1324 -- sh -c 'date +%T -s "12:00:00"'


echo $HR

((i++))
echo "$i. Clean-up"
echo ""
echo "kubectl delete -f $FULLPATH"
kubectl delete -f $FULLPATH
