#!/bin/bash
. ~/src/common/setup.sh
FULLPATH=$(pwd)
PSPPATH='../../chp12-secure/PSP'

echo "Talk to the API server with RBAC via a pod"

echo $HR

echo "1. Create namespaces foo and bar"
echo ""
kubectl apply -f $FULLPATH/set122-0-ns-foo.yaml
kubectl apply -f $FULLPATH/set122-0-ns-bar.yaml

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



echo "2. curl test. This should return an error, since we are using RBAC and haven't set up RoleBinding yet"
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

echo "kubectl apply -f $FULLPATH/set122-1-role-foo.yaml"
kubectl apply -f $FULLPATH/set122-1-role-foo.yaml
echo $HR

echo "kubectl describe role -n=foo"
kubectl describe role -n=foo

enter

#echo "Check config view"
#echo ""
#echo "kubectl config view"
#kubectl config view

#enter

echo "4. curl test. This should return an error, since we are using RBAC and haven't set up RoleBinding yet"
echo ""
echo "kubectl exec -it test -n foo -- curl localhost:8001/api/v1/namespaces/foo/services"
kubectl exec -it test -n foo -- curl localhost:8001/api/v1/namespaces/foo/services
echo ""

enter

echo "5. Bind a Role resource with ServiceAccount via RoleBinding"
echo ""

echo "kubectl create -f set122-3-rolebinding-foo.yaml"
kubectl create -f set122-3-rolebinding-foo.yaml
echo $HR

echo "kubectl describe rolebinding test -n=foo"
kubectl describe rolebinding test -n=foo

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

echo "kubectl create clusterrole pv-reader --verb=get,list --resource=persistentvolumes"
kubectl create clusterrole pv-reader --verb=get,list --resource=persistentvolumes

echo "kubectl get clusterrole pv-reader"
kubectl get clusterrole pv-reader
echo $HR

echo "Test if the pod can list PersistentVolumes without ClusterRoleBindings"

echo "kubectl exec -it test -n=foo -- curl localhost:8001/api/v1/persistentvolumes"
kubectl exec -it test -n=foo -- curl localhost:8001/api/v1/persistentvolumes
echo ""

enter


echo "8. Using ClusterRoleBindings"
echo "Bind ClusterRole to ServiceAccount to enable access to cluster-level resources"

echo ""


echo "kubectl create clusterrolebinding pv-test --clusterrole=pv-reader --serviceaccount=foo:default"
kubectl create clusterrolebinding pv-test --clusterrole=pv-reader --serviceaccount=foo:default
echo $HR

echo "After creating ClusterRoleBindings, test if we can list PersistentVolumes"
echo ""

echo "kubectl exec -it test -n=foo -- curl localhost:8001/api/v1/persistentvolumes"
kubectl exec -it test -n=foo  -- curl localhost:8001/api/v1/persistentvolumes
echo ""

enter

echo "kubectl get role n=foo"
kubectl get role -n=foo
echo $HR

echo "kubectl get rolebinding -n=foo"
kubectl get rolebinding -n=foo
echo $HR

echo "kubectl get clusterrole"
kubectl get clusterrole
echo $HR

echo "kubectl get clusterrolebinding"
kubectl get clusterrolebinding
echo $HR

enter

echo "kubectl describe clusterrole view"
kubectl describe clusterrole view

enter

echo "kubectl describe clusterrole admin"
kubectl describe clusterrole admin



kubectl delete ns foo
kubectl delete ns bar
kubectl delete clusterrole pv-reader
kubectl delete clusterrolebinding pv-test
