#!/bin/bash
. ~/src/common/setup.sh
FULLPATH=$(pwd)
echo "12.2.1 Introducing the RBAC authorization plugin"
echo $HR_TOP

PSPPATH='../../chp12-secure/PSP'

echo "Talk to the API server with RBAC via a pod"

echo $HR

echo "1. Create namespaces foo and bar"
echo ""
kubectl apply -f $FULLPATH/set1221-0-ns-foo.yaml
kubectl apply -f $FULLPATH/set1221-0-ns-bar.yaml

echo $HR

echo "kubectl run test --image=georgebaptista/kubectl-proxy --restart=Never -n=foo"
kubectl run test --image=georgebaptista/kubectl-proxy --restart=Never -n=foo
echo ""
echo "kubectl run test --image=georgebaptista/kubectl-proxy --restart=Never -n=bar"
kubectl run test --image=georgebaptista/kubectl-proxy --restart=Never -n=bar

echo $HR

echo "kubectl -n=foo wait --for=condition=Ready=True pod/test --timeout=31s"
kubectl -n=foo wait --for=condition=Ready=True pod/test --timeout=31s
echo ""
echo "kubectl -n=bar wait --for=condition=Ready=True pod/test --timeout=31s"
kubectl -n=bar wait --for=condition=Ready=True pod/test --timeout=31s
echo $HR

echo "kubectl get pod -n=foo"
kubectl get pod -n=foo
echo ""
echo "kubectl get pod -n=bar"
kubectl get pod -n=bar

enter



echo "2. curl test. This should return an error, since we are using RBAC and haven't set up a Role and RoleBinding yet"
echo ""
echo "kubectl exec -it test -n foo -- curl localhost:8001/api/v1/namespaces/foo/services"
kubectl exec -it test -n foo -- curl localhost:8001/api/v1/namespaces/foo/services
echo ""

echo $HR

echo "kubectl exec -it test -n bar -- curl localhost:8001/api/v1/namespaces/bar/services"
kubectl exec -it test -n bar -- curl localhost:8001/api/v1/namespaces/bar/services
echo ""

enter



echo "3. Create Role Resources"
echo ""

echo "kubectl apply -f $FULLPATH/set1221-1-role-foo.yaml"
kubectl apply -f $FULLPATH/set1221-1-role-foo.yaml
echo $HR

echo "kubectl describe role service-reader -n=foo"
echo ""
kubectl describe role service-reader -n=foo
echo $HR

echo "kubectl get role service-reader -o json -n=foo | jq 'del(.metadata.managedFields, .metadata.annotations, .metadata.selfLink, .metadata.uid, .metadata.resourceVersion)' | yq r -P -"
echo ""
kubectl get role service-reader -o json -n=foo | jq 'del(.metadata.managedFields, .metadata.annotations, .metadata.selfLink, .metadata.uid, .metadata.resourceVersion)' | yq r -P -


enter

#echo "Check config view"
#echo ""
#echo "kubectl config view"
#kubectl config view

#enter

echo "4. curl test. We now have a Role, but still no RoleBinding, and we expect this to return an error via RBAC"
echo ""
echo "kubectl exec -it test -n foo -- curl localhost:8001/api/v1/namespaces/foo/services"
kubectl exec -it test -n foo -- curl localhost:8001/api/v1/namespaces/foo/services
echo ""

enter

echo "5. Bind a Role resource with ServiceAccount via RoleBinding"
echo ""

echo "kubectl apple -f set1221-3-rolebinding-foo.yaml"
kubectl apply -f set1221-3-rolebinding-foo.yaml
echo $HR

echo "kubectl describe rolebinding test -n=foo"
kubectl describe rolebinding test -n=foo
echo $HR

echo "kubectl get rolebinding test  -n=foo -o json -n=foo | jq 'del(.metadata.managedFields, .metadata.annotations, .metadata.selfLink, .metadata.uid, .metadata.resourceVersion)' | yq r -P -"
echo ""
kubectl get rolebinding test  -n=foo -o json -n=foo | jq 'del(.metadata.managedFields, .metadata.annotations, .metadata.selfLink, .metadata.uid, .metadata.resourceVersion)' | yq r -P -

enter

echo "6. curl test. This should work, since we use RoleBinding to bind Role resource with ServiceAccount"
echo ""

echo "Get Services from the API server"
echo "kubectl exec -it test -n=foo -- curl localhost:8001/api/v1/namespaces/foo/services"
kubectl exec -it test -n=foo -- curl localhost:8001/api/v1/namespaces/foo/services
echo ""

enter

echo "7. Using ClusterRoles"
echo ""

#echo "kubectl create clusterrole pv-reader --verb=get,list --resource=persistentvolumes"
#kubectl create clusterrole pv-reader --verb=get,list --resource=persistentvolumes
#

echo "kubectl apply -f set1221-4-clusterrole.yaml"
kubectl apply -f set1221-4-clusterrole.yaml

echo $HR

echo "kubectl describe clusterrole pv-reader"
echo ""
kubectl describe clusterrole pv-reader
echo $HR

echo "kubectl get clusterrole pv-reader -o json | jq 'del(.metadata.managedFields, .metadata.annotations, .metadata.selfLink, .metadata.uid, .metadata.resourceVersion)' | yq r -P -"
echo ""
kubectl get clusterrole pv-reader -o json | jq 'del(.metadata.managedFields, .metadata.annotations, .metadata.selfLink, .metadata.uid, .metadata.resourceVersion)' | yq r -P -

enter

echo "Test if the pod can list PersistentVolumes without ClusterRoleBindings"
echo ""

echo "kubectl exec -it test -n=foo -- curl localhost:8001/api/v1/persistentvolumes"
kubectl exec -it test -n=foo -- curl localhost:8001/api/v1/persistentvolumes
echo ""

enter


echo "8. Using ClusterRoleBindings"
echo "Bind ClusterRole to ServiceAccount to enable access to cluster-level resources"
echo ""


#echo "kubectl create clusterrolebinding pv-test --clusterrole=pv-reader --serviceaccount=foo:default"
#kubectl create clusterrolebinding pv-test --clusterrole=pv-reader --serviceaccount=foo:default

echo "kubectl apply -f set1221-5-clusterrolebinding.yaml"
kubectl apply -f set1221-5-clusterrolebinding.yaml

echo $HR

echo "After creating ClusterRoleBindings, test if we can list PersistentVolumes"
echo ""

echo "kubectl exec -it test -n=foo -- curl localhost:8001/api/v1/persistentvolumes"
kubectl exec -it test -n=foo  -- curl localhost:8001/api/v1/persistentvolumes
echo ""

echo $HR

echo "kubectl delete -f $FULLPATH"
kubectl delete -f $FULLPATH --ignore-not-found

#echo "kubectl delete ns foo"
#echo "kubectl delete ns bar"
#echo "kubectl delete clusterrole pv-reader"
#echo "kubectl delete clusterrolebinding pv-test"

#kubectl delete ns foo
#kubectl delete ns bar
#kubectl delete clusterrole pv-reader
#kubectl delete clusterrolebinding pv-test
