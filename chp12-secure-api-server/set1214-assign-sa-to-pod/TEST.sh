#!/bin/bash
. ~/src/common/setup.sh
FULLPATH=$(pwd)
echo "12.1.4 Assigning a ServiceAccount to a pod"
echo $HR_TOP

echo "kubectl apply -f $FULLPATH/set1214-0-ns.yaml"
echo "kubectl apply -f $FULLPATH/set1214-1-sa-yaml"
kubectl apply -f $FULLPATH/set1214-0-ns.yaml
kubectl apply -f $FULLPATH/set1214-1-sa.yaml

echo $HR

echo "kubectl get sa -o yaml"
echo ""
kubectl get sa -o yaml


enter

echo "Assigning a ServiceAccount to a pod"
echo "After creating ServiceAccounts, they must be assigned to pods."
echo "This is done by setting the name of the ServiceAccount in the spec.serviceAccountName field"
echo ""


echo "kubectl apply -f $FULLPATH/set1214-3-pod-curl-custom-sa.yaml"
kubectl apply -f $FULLPATH/set1214-3-pod-curl-custom-sa.yaml
echo $HR


echo "kubectl wait --for=condition=Ready pod/curl-custom-sa -n=chp12-set1214"
kubectl wait --for=condition=Ready pod/curl-custom-sa -n=chp12-set1214
echo $HR

echo "kubectl get pods -o wide -n=chp12-set1214"
kubectl get pods -o wide -n=chp12-set1214
echo $HR

echo "kubectl -n=chp12-set1214 exec -it pod/curl-custom-sa -c main -- cat /var/run/secrets/kubernetes.io/serviceaccount/token"
echo ""
kubectl -n=chp12-set1214 exec -it pod/curl-custom-sa -c main -- cat /var/run/secrets/kubernetes.io/serviceaccount/token
echo ""

enter

echo "Talking to the API server with a custom ServiceAccount"
echo ""

echo "kubectl -n=chp12-set1214 exec -it pod/curl-custom-sa -c main -- curl localhost:8001/api/v1/namespaces/chp12-set12/serviceaccounts"
kubectl -n=chp12-set1214 exec -it pod/curl-custom-sa -c main -- curl localhost:8001/api/v1/namespaces/chp12-set12/serviceaccounts
echo ""

echo $HR

echo "kubectl delete -f $FULLPATH"
kubectl delete -f $FULLPATH
