#!/bin/bash
 . ~/src/common/setup.sh
FULLPATH=$(pwd)

echo "Tests for Section 17.6 pre-stop hook" 
echo ""

kubectl delete -f $FULLPATH --now --ignore-not-found

value=$(<set176-1-pod-prestop-hook.yaml)
echo "$value"
enter

kubectl apply -f $FULLPATH

echo "sleep 3"
sleep 3
echo ""

echo "kubectl get pods -n=chp17-set176 -o wide"
kubectl get pods -n=chp17-set176 -o wide
echo ""

#kubectl describe pod/pod-with-prestop-hook -n=chp17-set176
#echo ""

echo "sleep 20"
sleep 20 
echo ""

echo "kubectl logs pod-with-prestop-hook -n=chp17-set176"
kubectl logs pod-with-prestop-hook -n=chp17-set176
#kubectl describe pod/pod-with-prestop-hook -n=chp17-set176
#echo ""

echo $HR
echo "kubectl delete -f $FULLPATH"
kubectl delete -f $FULLPATH
 
#echo "1. The default system:discovery ClusterRole"
#echo ""
#
#
#echo "The API server also exposes non-resource URLs"
#echo "Access to these URLs is granted via the predefined system:discovery ClusterRole and ClusterRoleBinding"
#echo ""
#echo "kubectl get clusterrole system:discovery -o yaml"
#kubectl get clusterrole system:discovery -o yaml
#echo ""
#
#echo $HR
#
#echo "2. The default sytem:discovery ClusterRoleBinding"
#echo ""
#
#echo "kubectl get clusterrolebinding system:discovery -o yaml"
#kubectl get clusterrolebinding system:discovery -o yaml
#echo ""
#
#echo "1. Create namespace and pod resources"
#echo ""
#kubectl apply -f $FULLPATH/set1224-0-ns.yaml
#echo ""
#
#echo "kubectl run test --generator=run-pod/v1 --image=luksa/kubectl-proxy -n=foo"
#kubectl run test --generator=run-pod/v1 --image=luksa/kubectl-proxy -n=foo
#echo ""
#
#echo $HR
#
#echo "Get enn var from the test pod"
#kubectl -n=foo exec -it test -- printenv
#echo ""
#
#kubectl -n=foo exec -it test -- sh -c 'export TEST=$KUBERNETES_SERVICE_HOST'
#echo "TEST IS $TEST"
#echo ""
#
#PODIP=$(kubectl -n=foo exec test -it -- sh -c "printenv KUBERNETES_SERVICE_HOST")
#echo "PODIP is $PODIP"
## Check for illegal characters
#printf %s "$PODIP" | xxd
#echo ""
#URL=${PODIP%$'\r'}
#kubectl -n=foo exec -it test -- curl https://$URL:443/healthz -k
#
#kubectl -n=foo exec -it test -- curl https://$URL:443/api -k
#echo ""

#kubectl -n=foo exec -it test -- curl localhost:8001/healthz
#echo ""



##echo "kubectl run test --generator=run-pod/v1 --image=luksa/kubectl-proxy -n=bar"
##kubectl run test --generator=run-pod/v1 --image=luksa/kubectl-proxy -n=bar
##echo ""
#
#echo "kubectl -n=foo wait --for=condition=Ready=True pod/test --timeout=31s"
#kubectl -n=foo wait --for=condition=Ready=True pod/test --timeout=31s
#echo ""
#
#echo $HR
#
#echo "2. Create Role Resources"
#echo ""
#
#kubectl apply -f $FULLPATH/set1224-1-role-foo.yaml
##kubectl apply -f $FULLPATH/set1224-2-role-bar.yaml
#echo ""
#
##echo "kubectl describe role service-reader -n=foo"
##kubectl describe role service-reader -n=foo 
##echo ""
#
#echo "kubectl get role service-reader -n=foo -o yaml"
#kubectl get role service-reader -n=foo -o yaml
#echo ""
#
#echo $HR
#
#echo "3. curl test. This should return an error, since we are using RBAC and haven't set up RoleBinding yet"
#echo ""
#echo "kubectl exec -it test -n foo -- curl localhost:8001/api/v1/namespaces/foo/services"
#kubectl exec -it test -n foo -- curl localhost:8001/api/v1/namespaces/foo/services
#echo ""
#
#echo $HR
#
#echo "4. curl test. This should work, since we use RoleBinding to bind Role resource with ServiceAccount"
#echo ""
#
#echo "kubectl create -f set1224-3-rolebinding-foo.yaml"
#kubectl create -f set1224-3-rolebinding-foo.yaml
#echo ""
#
##echo "kubectl describe rolebinding -n=foo"
##kubectl describe rolebinding -n=foo
##echo ""
#
#echo "kubectl get rolebinding test -n=foo -o yaml"
#kubectl get rolebinding test -n=foo -o yaml
#echo ""
#
#echo "Get a shell to a running container"
#
#echo "kubectl exec -it test -n foo -- curl localhost:8001/api/v1/namespaces/foo/services"
#kubectl exec -it test -n foo -- curl localhost:8001/api/v1/namespaces/foo/services
#echo ""
#
#echo $HR
#
#echo "5. Using ClusterRoles"
#echo ""
#
##echo "kubectl apply -f set1224-4-clusterrole.yaml"
##kubectl apply -f set1224-4-clusterrole.yaml 
##echo ""
#
#kubectl create clusterrole pv-reader --verb=get,list --resource=persistentvolumes
#
#echo "kubectl get clusterrole pv-reader"
#kubectl get clusterrole pv-reader
#echo ""
#
#echo "Test if the pod can list PV"
#
#echo "kubectl exec -it test -n foo -- curl localhost:8001/api/v1/persistentvolumes"
#kubectl exec -it test -n foo -- curl localhost:8001/api/v1/persistentvolumes
#echo ""
#
#echo $HR
#
#echo "6. Using ClusterRoleBindings"
#echo ""
#
##echo "kubectl apply -f set1224-5-clusterrolebinding.yaml"
##kubectl apply -f set1224-5-clusterrolebinding.yaml
##echo ""
#
#echo "kubectl create clusterrolebinding pv-test --clusterrole=pv-reader --serviceaccount=foo:default"
#kubectl create clusterrolebinding pv-test --clusterrole=pv-reader --serviceaccount=foo:default
#echo ""
#
#echo "After creating ClusterRoleBindings, test if we can list PVs"
#echo ""
#
#echo "kubectl exec -it test -n foo -- curl localhost:8001/api/v1/persistentvolumes"
#kubectl exec -it test -n foo -- curl localhost:8001/api/v1/persistentvolumes
#echo ""
#
#
#
#
#echo $HR

#kubectl delete -f set1224-0-ns.yaml --force --grace-period=0
#kubectl delete pod/test -n=foo --force --grace-period=0
#kubectl delete -f set1224-1-role-foo.yaml
#kubectl delete -f set1224-3-rolebinding-foo.yaml


#kubectl delete clusterrole pv-reader
#kubectl delete clusterrolebinding pv-test
