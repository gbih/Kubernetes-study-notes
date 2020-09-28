#!/bin/bash
. ~/src/SETUP.sh
FULLPATH=$(pwd)
echo $HR_TOP

echo "kubectl apply -f $FULLPATH"
kubectl apply -f $FULLPATH

sleep 3

echo $HR

echo "POD0=\$(kubectl get pod -n=chp05-set523 -o jsonpath={'.items[0].metadata.name'})"
POD0=$(kubectl get pod -n=chp05-set523 -o jsonpath={'.items[0].metadata.name'})

echo "kubectl wait --for=condition=Ready pod/$POD0 -n=chp05-set523 --timeout=20s"
kubectl wait --for=condition=Ready pod/$POD0 -n=chp05-set523 --timeout=20s

echo $HR

echo "kubectl get all -n=chp05-set523"
kubectl get all -n=chp05-set523
echo ""

echo "kubectl get endpoints -n=chp05-set523"
kubectl get endpoints -n=chp05-set523
echo "There should not be any endpoints here, since the type is ExternalName, not ClusterIP"

echo $HR

echo "kubectl exec -it $POD0 -n=chp05-set523 -- cat /etc/resolv.conf"
kubectl exec -it $POD0 -n=chp05-set523 -- cat /etc/resolv.conf

echo $HR

echo "Try to access the external-service"
echo "kubectl exec -it $POD0 -n=chp05-set523 -- curl http://external-service.chp05-set523.svc.cluster.local?format=json"
kubectl exec -it $POD0 -n=chp05-set523 -- curl http://external-service.chp05-set523.svc.cluster.local?format=json
echo ""

echo $HR

echo "kubectl delete -f $FULLPATH"
kubectl delete -f $FULLPATH

