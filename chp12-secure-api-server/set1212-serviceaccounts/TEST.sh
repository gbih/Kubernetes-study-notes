#!/bin/bash
. ~/src/common/setup.sh
FULLPATH=$(pwd)
echo "12.1.2 Introducing ServiceAccounts"
echo $HR_TOP

echo "Check set-up of kube-api server"
echo ""
echo "ps ax | grep kube-api"
ps ax | grep kube-api

enter

echo "cat /var/snap/microk8s/current/args/kube-apiserver"
echo ""
cat /var/snap/microk8s/current/args/kube-apiserver

enter

echo "Check how this API call is authenticated:"
echo ""
echo "kubectl apply -f $FULLPATH/set1212-0-ns.yaml --v=6"
kubectl apply -f $FULLPATH/set1212-0-ns.yaml --v=6

enter

echo "kubectl apply -f $FULLPATH/set1212-1-sa.yaml"
echo "kubectl apply -f $FULLPATH/set1212-2-sa-image-pull-secrets.yaml"

kubectl apply -f $FULLPATH/set1212-0-ns.yaml
kubectl apply -f $FULLPATH/set1212-1-sa.yaml
kubectl apply -f $FULLPATH/set1212-2-sa-image-pull-secrets.yaml

enter

echo "kubectl get sa -o yaml"
echo ""
kubectl get sa -o yaml

echo $HR

echo "kubectl get sa foo -o json -n=chp12-set1212 | jq 'del(.metadata.managedFields, .metadata.annotations, .metadata.apiVersion)' | yq r -P -"
echo ""
kubectl get sa foo -o json -n=chp12-set1212 | jq 'del(.metadata.managedFields, .metadata.annotations, .metadata.apiVersion)' | yq r -P -

echo $HR

enter "kubectl describe sa foo -n chp12-set1212"
kubectl describe sa foo -n chp12-set1212

enter


echo "Inspecting the custom ServiceAccount's Secret"
echo ""
echo "SECRET=\$(kubectl get sa foo -n=chp12-set1212 -o jsonpath={'.secrets[0].name'})"
SECRET=$(kubectl get sa foo -n=chp12-set1212 -o jsonpath={'.secrets[0].name'})
echo ""
echo "kubectl describe secret $SECRET -n=chp12-set1212"
kubectl describe secret $SECRET -n=chp12-set1212
enter

echo "Examine decoded contents of JWT"
echo ""
echo "JWT=\$(kubectl get secret $SECRET -n=chp12-set1212 -o jsonpath={.data.token} | base64 --decode)"
JWT=$(kubectl get secret $SECRET -n=chp12-set1212 -o jsonpath={.data.token} | base64 --decode)
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


echo $HR

echo "kubectl delete -f $FULLPATH"
kubectl delete -f $FULLPATH
