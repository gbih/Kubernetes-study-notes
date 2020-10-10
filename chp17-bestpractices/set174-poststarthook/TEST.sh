#!/bin/bash
. ~/src/common/setup.sh
FULLPATH=$(pwd)

cat <<- "NOTES"
Tests for Section 17.4 PostStartHook

NOTES


value=$(<set174-1-pod-post-start-hook.yaml)
echo "$value"

enter

kubectl apply -f $FULLPATH/set174-0-ns.yaml
kubectl apply -f $FULLPATH
sleep 1

echo $HR


echo "kubectl wait --for=condition=Ready pods/lifecycle-demo -n=chp17-set174 --timeout=11s"
kubectl wait --for=condition=Ready pods/lifecycle-demo -n=chp17-set174 --timeout=11s

echo $HR

echo "kubectl get pods -n=chp17-set174"
kubectl get pods -n=chp17-set174
echo $HR

# https://kubernetes.io/docs/tasks/configure-pod-container/attach-handler-lifecycle-event/
echo "kubectl exec -it lifecycle-demo -n=chp17-set174 -- cat /usr/share/message"
kubectl exec -it lifecycle-demo -n=chp17-set174 -- cat /usr/share/message
echo $HR

echo "kubectl exec -it lifecycle-demo -n=chp17-set174 -- cat /var/termination-reason"
kubectl exec -it lifecycle-demo -n=chp17-set174 -- cat /var/termination-reason

echo $HR

echo "kubectl logs pod-with-poststart-hook -n=chp17-set174 -c kubia"
kubectl logs pod-with-poststart-hook -n=chp17-set174 -c kubia

echo $HR

echo "kubectl get pods -n=chp17-set174"
kubectl get pods -n=chp17-set174
echo $HR

echo $HR
echo "kubectl delete -f $FULLPATH"
kubectl delete -f $FULLPATH
 
