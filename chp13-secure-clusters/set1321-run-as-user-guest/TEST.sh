#!/bin/bash
. ~/src/common/setup.sh
FULLPATH=$(pwd)


value1=$(<set1321-1-pod-as-user-guest.yaml)
echo "$value1"

echo ""
echo $HR

value2=$(<set1321-2-pod-regular.yaml)
echo "$value2"

enter



((i++))
echo "$i. Deploying the app via StatefulSet"
echo ""

echo "kubectl apply -f $FULLPATH"
kubectl apply -f $FULLPATH --record
#sleep 1
echo ""
echo "kubectl wait --for=condition=Ready ..."
kubectl wait --for=condition=Ready pod/pod-as-user-guest -n=chp13-set1321
kubectl wait --for=condition=Ready pod/pod-regular -n=chp13-set1321

echo $HR
# enter

((i++))
echo "$i. Check resources"
echo ""
echo "kubectl get pods -n=chp13-set1321 -o wide"
kubectl get pods -n=chp13-set1321 -o wide --sort-by=.status.podIP
echo ""
echo "kubectl get node"
kubectl get node
echo ""
echo "kubectl get psp"
kubectl get psp

enter


((i++))
echo "To see the effect of the runAsUser property, run the id command in this new pod."
echo ""
echo "kubectl exec pod-as-user-guest -n=chp13-set1321 -- id"
kubectl exec pod-as-user-guest -n=chp13-set1321 -- id
echo ""
echo "We can see this pod running as the more limited guest user."
echo ""

echo "kubectl exec pod-regular -n=chp13-set1321 -- id"
kubectl exec pod-regular -n=chp13-set1321 -- id
echo ""
echo "Here, this pod with default security options is the root user, and it is a member of multiple other groups."

#enter
echo $HR

((i++))
echo "$i. Clean-up"
echo ""
echo "kubectl delete -f $FULLPATH --now"
kubectl delete -f $FULLPATH --now

