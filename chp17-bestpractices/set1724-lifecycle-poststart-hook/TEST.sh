#!/bin/bash
. ~/src/common/setup.sh
FULLPATH=$(pwd)

cat <<- "NOTES"
Tests for Section 17.4 PostStartHook

NOTES


value=$(<set1724-1-pod-post-start-hook.yaml)
echo "$value"

enter

kubectl apply -f $FULLPATH/set1724-0-ns.yaml
kubectl apply -f $FULLPATH
kubectl apply -f $FULLPATH/setup-psp.yaml
kubectl apply -f $FULLPATH/setup-sa.yaml
kubectl apply -f $FULLPATH/setup-role-rolebinding.yaml

echo $HR

echo "kubectl wait --for=condition=Ready pods/lifecycle-demo -n=chp17-set1724 --timeout=11s"
kubectl wait --for=condition=Ready pods/lifecycle-demo -n=chp17-set1724 --timeout=11s

enter

echo "kubectl get pods -n=chp17-set1724"
kubectl get pods -n=chp17-set1724
echo $HR

# https://kubernetes.io/docs/tasks/configure-pod-container/attach-handler-lifecycle-event/
echo "kubectl exec -it lifecycle-demo -n=chp17-set1724 -- cat /usr/share/message"
kubectl exec -it lifecycle-demo -n=chp17-set1724 -- cat /usr/share/message
echo $HR

echo "kubectl exec -it lifecycle-demo -n=chp17-set1724 -- cat /var/termination-reason"
kubectl exec -it lifecycle-demo -n=chp17-set1724 -- cat /var/termination-reason

enter

echo "kubectl logs pod-with-poststart-hook -n=chp17-set1724 -c kubia"
kubectl logs pod-with-poststart-hook -n=chp17-set1724 -c kubia

echo $HR

echo "kubectl get pods -n=chp17-set1724"
kubectl get pods -n=chp17-set1724

enter

echo "kubectl delete -f $FULLPATH"
kubectl delete -f $FULLPATH
 
