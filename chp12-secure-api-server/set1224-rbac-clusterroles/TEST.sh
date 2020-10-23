#!/bin/bash
. ~/src/common/setup.sh
FULLPATH=$(pwd)
echo "12.2.4 Using ClusterRoles and ClusterRoleBindings"
echo "This is usually for system-level resources."
echo $HR_TOP

echo "kubectl apply -f $FULLPATH/set1224-0-ns.yaml"
#echo "kubectl apply -f $FULLPATH/set1224-1-sa.yaml"
echo "kubectl apply -f $FULLPATH/set1224-2-deployment.yaml"

kubectl apply -f $FULLPATH/set1224-0-ns.yaml
#kubectl apply -f $FULLPATH/set1224-1-sa.yaml
kubectl apply -f $FULLPATH/set1224-2-deployment.yaml

echo $HR

echo "kubectl rollout status deployment test -n=chp12-set1224"
kubectl rollout status deployment test -n=chp12-set1224

enter

echo "kubectl apply -f $FULLPATH/set1224-3-clusterrole.yaml"
kubectl apply -f $FULLPATH/set1224-3-clusterrole.yaml

echo $HR

echo "kubectl describe clusterrole pv-reader"
echo ""
kubectl describe clusterrole pv-reader
echo $HR

echo "kubectl get clusterrole pv-reader -o json | jq 'del(.metadata.managedFields, .metadata.annotations, .metadata.selfLink, .metadata.uid, .metadata.resourceVersion)' | yq r -P -"
echo ""
kubectl get clusterrole pv-reader -o json | jq 'del(.metadata.managedFields, .metadata.annotations, .metadata.selfLink, .metadata.uid, .metadata.resourceVersion)' | yq r -P -

enter

echo "Verify whether the pod can list PV before binding the ClusterRole to the pod ServiceAccount."
echo "(expect an error)"
echo ""

echo "kubectl exec deployment/test -n chp12-set1224 --v=6 -it -- curl localhost:8001/api/v1/persistentvolumes"
kubectl exec deployment/test -n chp12-set1224 --v=6 -it -- curl localhost:8001/api/v1/persistentvolumes

enter

echo "Create rolebinding"
echo "kubectl apply -f $FULLPATH/set1224-4-rolebinding.yaml"
kubectl apply -f $FULLPATH/set1224-4-rolebinding.yaml

echo $HR

echo "kubectl describe rolebinding pv-test -n chp12-set1224"
kubectl describe rolebinding pv-test -n chp12-set1224

enter

echo "Try again:"
echo "(expect another error)"
echo ""
echo "kubectl exec deployment/test -n chp12-set1224 --v=6 -it -- curl localhost:8001/api/v1/persistentvolumes"
kubectl exec deployment/test -n chp12-set1224 --v=6 -it -- curl localhost:8001/api/v1/persistentvolumes
echo ""

enter

echo "kubectl apply -f $FULPATH/set1224-5-clusterrolebinding.yaml"
kubectl apply -f $FULLPATH/set1224-5-clusterrolebinding.yaml

echo $HR

echo "Try again:"
echo ""
echo "kubectl exec deployment/test -n chp12-set1224 --v=6 -it -- curl localhost:8001/api/v1/persistentvolumes"
kubectl exec deployment/test -n chp12-set1224 --v=6 -it -- curl localhost:8001/api/v1/persistentvolumes

enter

echo "Although you can create a RoleBinding and have it reference a ClusterRole when you want to enable access to namespaced resources, you can't use the ame approach for cluster-level (non-namespaced) resources."
echo "To grant access to cluster-level resources, we must always use a ClusterRoleBinding."

echo $HR

echo "OK:"
echo ""
echo "kubectl describe clusterrolebinding pv-test"
kubectl describe clusterrolebinding pv-test

echo $HR

echo "BAD:"
echo ""
echo "kubectl describe rolebinding pv-test -n chp12-set1224"
kubectl describe rolebinding pv-test -n chp12-set1224

enter

echo "kubectl delete -f $FULLPATH"
kubectl delete -f $FULLPATH --ignore-not-found

