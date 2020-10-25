#!/bin/bash
. ~/src/common/setup.sh
FULLPATH=$(pwd)
echo "12.2.6 Granting authorization permissions wisely"
echo $HR_TOP

function urlTest() {
  echo "Get all resources"
  echo "kubectl exec -it test -n chp12-set1226 -- curl localhost:8001"
  echo ""
  kubectl exec -it test -n chp12-set1226 -- curl localhost:8001
  echo ""
  echo $HR
  echo "Get deployment resources"
  # .[]? is similar to .[], but no errors will be output if . is not an array or object.
  echo "kubectl exec -it test -n chp12-set1226 -- curl localhost:8001/apis/apps/v1/deployments | jq -r '.items[]?.metadata.name'"
  echo ""
  kubectl exec -it test -n chp12-set1226 -- curl localhost:8001/apis/apps/v1/deployments | jq -r '.items[]?.metadata.name'
  echo ""
  echo $HR
  echo "Get services in this namespace"
  echo "kubectl exec -it test -n chp12-set1226 -- curl localhost:8001/api/v1/namespaces/chp12-set1226/services"
  kubectl exec -it test -n chp12-set1226 -- curl localhost:8001/api/v1/namespaces/chp12-set1226/services
  echo ""
}

###########################################

# Make sure any clusterrolebindings are deleted beforehand
kubectl delete clusterrolebinding binding --ignore-not-found
kubectl delete rolebinding binding -n chp12-set1226 --ignore-not-found

kubectl apply -f $FULLPATH/set1226-0-ns.yaml
kubectl apply -f $FULLPATH/set1226-1-sa.yaml
kubectl apply -f $FULLPATH/set1226-2-pod.yaml

echo $HR
echo "kubectl wait --for=condition=Ready=True pod/test -n=chp12-set1226 --timeout=20s"
kubectl wait --for=condition=Ready=True pod/test -n=chp12-set1226 --timeout=20s

enter

###########################################

echo "1. Grant super-user access to all service accounts cluster-wide (not recommended)"
echo "This does not partition permissions at all and grants super-use access to all service accounts"
echo ""
echo "kubectl create clusterrolebinding binding --clusterrole=cluster-admin --group=system:serviceaccounts --dry-run=client -o yaml"
echo ""
value=$(<crb-1.yaml)
echo "$value"
echo $HR
echo "kubectl apply -f $FULLPATH/crb-1.yaml"
kubectl apply -f $FULLPATH/crb-1.yaml
echo $HR
kubectl get clusterrolebinding binding -o wide
echo ""
kubectl get clusterrole cluster-admin
enter
urlTest
echo $HR
echo "kubectl delete clusterrolebinding binding"
kubectl delete clusterrolebinding binding
enter

###########################################

echo "2. Grant a limited role to all service accounts cluster-wide (not recommended)"
echo "If you don't want to manage permissions per-namespace, you can grant a cluster-wide role to all service accoutns"
echo ""
echo "kubectl create clusterrolebinding binding --clusterrole=view --group=system:serviceaccounts --dry-run=client -o yaml"
echo ""
value=$(<crb-2.yaml)
echo "$value"
echo $HR
echo "kubectl apply -f $FULLPATH/crb-2.yaml"
kubectl apply -f $FULLPATH/crb-2.yaml
echo $HR
kubectl get clusterrolebinding binding -o wide
echo ""
kubectl get clusterrole view
enter
urlTest
echo $HR
enter
echo "kubectl delete clusterrolebinding binding"
kubectl delete clusterrolebinding binding
enter

###########################################

echo "3. Grant a role to all service accounts in a namespace"
echo "If you want all applications in a namespace to have a role, no matter what service account use,"
echo "you can grant a role to the service account group for that namespace."
echo "For ex, grant read-only permission within "chp12-set1226" namespace to all service accounts in that namespacd."
echo ""
echo "kubectl create rolebinding binding --clusterrole=view --group=system:serviceaccounts -n chp12-set1226 --dry-run=client -o yaml"
echo ""
value=$(<crb-3.yaml)
echo "$value"
echo $HR
echo "kubectl apply -f $FULLPATH/crb-3.yaml"
kubectl apply -f $FULLPATH/crb-3.yaml
echo $HR
kubectl get rolebinding binding -n chp12-set1226 -o wide
echo ""
kubectl get clusterrole view
echo ""
kubectl get sa -n chp12-set1226
enter
urlTest
echo $HR
enter
echo "kubectl delete rolebinding binding -n ch12-set1226"
kubectl delete rolebinding binding -n chp12-set1226
enter

###########################################

echo "4. Grant a role ot the default service account in a namespace"
echo "If an application does not specify a serviceAccountName, it uses the 'default' service account"
echo "Permissions given to the 'default' service account are available to any pod in the namespace that does not specify a serviceAccountName"
echo "Grant read-only permission within 'chp12-set1226' to the the 'default' service account"
echo ""
echo "kubectl create rolebinding binding --clusterrole=view --serviceaccount=chp12-set1226:default -n chp12-set1226 --dry-run=client -o yaml"
echo ""
value=$(<crb-4.yaml)
echo "$value"
echo $HR
echo "kubectl apply -f $FULLPATH/crb-4.yaml"
kubectl apply -f $FULLPATH/crb-4.yaml
echo $HR
kubectl get rolebinding binding -n chp12-set1226
echo ""
kubectl get clusterrole view
echo ""
kubectl get sa default -n chp12-set1226
enter
urlTest
enter
echo "kubectl delete rolebinding binding -n chp12-set1226"
kubectl delete rolebinding binding -n chp12-set1226
enter

###########################################

echo "5. Grant a role to an application-specific service account (best practice)"
echo "Grant read-only permission within namespace to the specified service accoutn"
echo ""
echo "kubectl create rolebinding binding --role=ClusterRole --serviceaccount=chp12-set1226:test -n chp12-set1226 --dry-run=client -o yaml"
echo ""
value=$(<crb-5.yaml)
echo "$value"
echo $HR
kubectl apply -f $FULLPATH/crb-5.yaml
kubectl get rolebinding binding -n chp12-set1226
echo ""
kubectl get clusterole view
echo ""
kubectl get sa test -n chp12-set1226
enter
urlTest
echo $HR
echo "kubectl delete rolebinding binding -n chp12-set1226"
kubectl delete rolebinding binding -n chp12-set1226
enter

##########################################

echo "6. Role, Rolebinding, Specific ServiceAccount"
echo "Grant read-only permission within namespace to the specified service account, using role"
echo ""
echo "kubectl create rolebinding binding --role=service-reader --serviceaccount=chp12-set1226:test -n chp12-set1226 --dry-run=client -o yaml"
echo ""
value=$(<crb-6.yaml)
echo "$value"
echo $HR
kubectl apply -f $FULLPATH/crb-6.yaml
kubectl get rolebinding binding -n chp12-set1226
echo ""
kubectl get role service-reader -n chp12-set1226
echo ""
kubectl get sa test -n chp12-set1226
enter
urlTest
echo $HR
echo "kubectl delete rolebinding binding -n chp12-set1226"
kubectl delete rolebinding binding -n chp12-set1226
enter



##########################################

kubectl delete -f $FULLPATH
