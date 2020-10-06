#!/bin/bash
. ~/src/common/setup.sh
FULLPATH=$(pwd)

# tput rev; echo "kubectl apply -f $PSPPATH"; tput sgr0

echo "kubectl apply -f $FULLPATH"
kubectl apply -f $FULLPATH
echo $HR_TOP

enter

echo "kubectl get sa -o yaml"
kubectl get sa -o yaml

enter

echo "kubectl get sa foo -o yaml -n=chp12-set121"
kubectl get sa foo -o yaml -n=chp12-set121

enter 

echo "Inspecting the custom ServiceAccount's Secret"
echo ""

TOKEN=$(kubectl get sa foo -n=chp12-set121 -o jsonpath={'.secrets[0].name'})

echo "kubectl describe secret $TOKEN -n=chp12-set121"
kubectl describe secret $TOKEN -n=chp12-set121
echo ""

enter

echo "Assigning a ServiceAccount to a pod"
echo "After creating ServiceAccounts, they must be assigned to pods."
echo "This is done by setting the name of the SA in the spec.serviceAccountName field"
echo ""

echo "kubectl wait --for=condition=Ready pod/curl-custom-sa -n=chp12-set121"
kubectl wait --for=condition=Ready pod/curl-custom-sa -n=chp12-set121
echo ""

echo "kubectl get pods -o wide -n=chp12-set121"
kubectl get pods -o wide -n=chp12-set121
echo ""

echo "kubectl -n=chp12-set121 exec -it curl-custom-sa -c main -- cat /var/run/secrets/kubernetes.io/serviceaccount/token"
kubectl -n=chp12-set121 exec -it curl-custom-sa -c main -- cat /var/run/secrets/kubernetes.io/serviceaccount/token
echo ""

enter

echo "Talking to the API server with a custom ServiceAccount"
echo ""

echo "kubectl -n=chp12-set121 exec -it curl-custom-sa -c main -- curl localhost:8001/api/v1/namespaces/chp12-set12/serviceaccounts"
kubectl -n=chp12-set121 exec -it curl-custom-sa -c main -- curl localhost:8001/api/v1/namespaces/chp12-set12/serviceaccounts
echo ""


echo $HR

echo "kubectl delete -f $FULLPATH"
kubectl delete -f $FULLPATH
