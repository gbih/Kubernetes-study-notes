#!/bin/bash
. ~/src/common/setup.sh
FULLPATH=$(pwd)
echo $HR_TOP


echo "kubectl apply -f $FULLPATH/set121-0-ns.yaml"
echo "kubectl apply -f $FULLPATH/set121-1-sa.yaml"
echo "kubectl apply -f $FULLPATH/set121-2-sa-image-pull-secrets.yaml"

kubectl apply -f $FULLPATH/set121-0-ns.yaml
kubectl apply -f $FULLPATH/set121-1-sa.yaml
kubectl apply -f $FULLPATH/set121-2-sa-image-pull-secrets.yaml

enter

echo "kubectl get sa -o yaml"
echo ""
kubectl get sa -o yaml
enter


echo "kubectl get sa foo -o json -n=chp12-set121 | jq 'del(.metadata.managedFields, .metadata.annotations, .metadata.apiVersion)' | yq r -P -"
echo ""
kubectl get sa foo -o json -n=chp12-set121 | jq 'del(.metadata.managedFields, .metadata.annotations, .metadata.apiVersion)' | yq r -P -
enter 



echo "Inspecting the custom ServiceAccount's Secret"
echo ""
echo "SECRET=\$(kubectl get sa foo -n=chp12-set121 -o jsonpath={'.secrets[0].name'})"
SECRET=$(kubectl get sa foo -n=chp12-set121 -o jsonpath={'.secrets[0].name'})
echo ""
echo "kubectl describe secret $SECRET -n=chp12-set121"
kubectl describe secret $SECRET -n=chp12-set121
enter

echo "Examine decoded contents of JWT"
echo ""
echo "JWT=\$(kubectl get secret $SECRET -n=chp12-set121 -o jsonpath={.data.token} | base64 --decode)"
JWT=$(kubectl get secret $SECRET -n=chp12-set121 -o jsonpath={.data.token} | base64 --decode)
echo ""


echo "JWT Header:"
#jq -R 'split(".") | .[0] | @base64d | fromjson' <<< "$JWT"
jq -R 'gsub("-";"+") | gsub("_";"/") | split(".") | .[0] | @base64d | fromjson' <<< "$JWT"
echo ""

echo "JWT Payload:"
#jq -R 'split(".") | .[1] | @base64d | fromjson' <<< $JWT
jq -R 'gsub("-";"+") | gsub("_";"/") | split(".") | .[1] | @base64d | fromjson' <<< "$JWT"
echo ""

echo "JWT Signature:"
#jq -R 'split(".") | .[2]' <<< $JWT
jq -R 'gsub("-";"+") | gsub("_";"/") | split(".") | .[2]' <<< "$JWT"

enter

echo "Assigning a ServiceAccount to a pod"
echo "After creating ServiceAccounts, they must be assigned to pods."
echo "This is done by setting the name of the ServiceAccount in the spec.serviceAccountName field"
echo ""


echo "kubectl apply -f $FULLPATH/set121-3-pod-curl-custom-sa.yaml"
kubectl apply -f $FULLPATH/set121-3-pod-curl-custom-sa.yaml
echo $HR


echo "kubectl wait --for=condition=Ready pod/curl-custom-sa -n=chp12-set121"
kubectl wait --for=condition=Ready pod/curl-custom-sa -n=chp12-set121
echo $HR

echo "kubectl get pods -o wide -n=chp12-set121"
kubectl get pods -o wide -n=chp12-set121
echo $HR

echo "kubectl -n=chp12-set121 exec -it pod/curl-custom-sa -c main -- cat /var/run/secrets/kubernetes.io/serviceaccount/token"
echo ""
kubectl -n=chp12-set121 exec -it pod/curl-custom-sa -c main -- cat /var/run/secrets/kubernetes.io/serviceaccount/token
echo ""

enter

echo "Talking to the API server with a custom ServiceAccount"
echo ""

echo "kubectl -n=chp12-set121 exec -it pod/curl-custom-sa -c main -- curl localhost:8001/api/v1/namespaces/chp12-set12/serviceaccounts"
kubectl -n=chp12-set121 exec -it pod/curl-custom-sa -c main -- curl localhost:8001/api/v1/namespaces/chp12-set12/serviceaccounts
echo ""

echo $HR

echo "kubectl delete -f $FULLPATH"
kubectl delete -f $FULLPATH
