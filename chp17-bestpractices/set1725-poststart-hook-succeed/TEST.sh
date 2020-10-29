#!/bin/bash
. ~/src/common/setup.sh
FULLPATH=$(pwd)
echo "17.2.4 Using a Post-start container lifecycle hook"
echo $HR_TOP

value=$(<set1725-2-lifecycle-events.yaml)
echo "$value"

enter

#kubectl apply -f $FULLPATH/set1725-0-ns.yaml
#sleep 1 
kubectl apply -f $FULLPATH

echo $HR

echo "kubectl wait --for=condition=Ready pods/lifecycle-demo -n=chp17-set1725 --timeout=11s"
kubectl wait --for=condition=Ready pods/lifecycle-demo -n=chp17-set1725 --timeout=11s

#enter
echo $HR

echo "kubectl get pods -n=chp17-set1725"
kubectl get pods -n=chp17-set1725
echo $HR

echo "Verify the postStart handler created the message file"
echo ""
echo "kubectl exec -it lifecycle-demo -n=chp17-set1725 -- cat /usr/share/message"
kubectl exec -it lifecycle-demo -n=chp17-set1725 -- cat /usr/share/message
echo $HR

#enter

echo "kubectl delete -f $FULLPATH"
kubectl delete -f $FULLPATH
 
