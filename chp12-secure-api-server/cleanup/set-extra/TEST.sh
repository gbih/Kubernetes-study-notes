#!/bin/bash
. ~/src/common/setup.sh
FULLPATH=$(pwd)
echo "Extra: Explore 'Principle of Least Privilege' iteratively"
echo $HR_TOP

function urlTest() {

  echo "CURL" 
   kubectl exec -it my-pod -n=chp12-set1227 -- curl localhost:8001/api/v1/namespaces/chp12-set1227/nodes

  echo ""
}

###########################################


kubectl apply -f $FULLPATH/set1227-0-ns.yaml
kubectl apply -f $FULLPATH/set1227-1-sa.yaml
kubectl apply -f $FULLPATH/set1227-3-pod-sa.yaml

echo "kubectl wait --for=condition=Ready=True pod/my-pod -n=chp12-set1227 --timeout=20s"
kubectl wait --for=condition=Ready=True pod/my-pod -n=chp12-set1227 --timeout=20s


allEndpoints=(
localhost:8001/api/v1/namespaces/chp12-set1227/bindings
localhost:8001/api/v1/namespaces/chp12-set1227/configmaps
localhost:8001/api/v1/namespaces/chp12-set1227/endpoints
localhost:8001/api/v1/namespaces/chp12-set1227/events
localhost:8001/api/v1/namespaces/chp12-set1227/limitranges
localhost:8001/api/v1/namespaces/chp12-set1227/persistentvolumeclaims
localhost:8001/api/v1/namespaces/chp12-set1227/pods
localhost:8001/api/v1/namespaces/chp12-set1227/podtemplates
localhost:8001/api/v1/namespaces/chp12-set1227/replicationcontrollers
localhost:8001/api/v1/namespaces/chp12-set1227/resourcequotas
localhost:8001/api/v1/namespaces/chp12-set1227/secrets
localhost:8001/api/v1/namespaces/chp12-set1227/serviceaccounts
localhost:8001/api/v1/namespaces/chp12-set1227/services
localhost:8001/apis/apps/v1/namespaces/chp12-set1227/controllerrevisions
localhost:8001/apis/apps/v1/namespaces/chp12-set1227/daemonsets
localhost:8001/apis/apps/v1/namespaces/chp12-set1227/deployments
localhost:8001/apis/apps/v1/namespaces/chp12-set1227/replicasets
localhost:8001/apis/apps/v1/namespaces/chp12-set1227/statefulsets
localhost:8001/apis/authorization.k8s.io/v1/namespaces/chp12-set1227/localsubjectaccessreviews
localhost:8001/apis/autoscaling/v1/namespaces/chp12-set1227/horizontalpodautoscalers
localhost:8001/apis/batch/v1beta1/namespaces/chp12-set1227/cronjobs
localhost:8001/apis/batch/v1/namespaces/chp12-set1227/jobs
localhost:8001/apis/coordination.k8s.io/v1/namespaces/chp12-set1227/leases
localhost:8001/apis/discovery.k8s.io/v1beta1/namespaces/chp12-set1227/endpointslices
localhost:8001/api/v1/namespaces/chp12-set1227/events
localhost:8001/apis/extensions/v1beta1/namespaces/chp12-set1227/ingresses
localhost:8001/api/v1/namespaces/chp12-set1227/pods
localhost:8001/apis/extensions/v1beta1/namespaces/chp12-set1227/ingresses
localhost:8001/apis/networking.k8s.io/v1/namespaces/chp12-set1227/networkpolicies
localhost:8001/apis/policy/v1beta1/namespaces/chp12-set1227/poddisruptionbudgets
localhost:8001/apis/rbac.authorization.k8s.io/v1/namespaces/chp12-set1227/rolebindings
localhost:8001/apis/rbac.authorization.k8s.io/v1/namespaces/chp12-set1227/roles
)

for t in ${allEndpoints[@]}; do
  tput reset

  kubectl delete rolebinding my-binding -n=chp12-set1227 --ignore-not-found > /dev/null 2>&1
  #kubectl delete role my-role -n=chp12-set1227 --ignore-not-found
  #echo $t
  #kubectl create role my-role --verb=get --verb=list --resource=nodes -n chp12-set1227 --dry-run=client -o yaml > my-role.yaml
  #kubectl apply -f $FULLPATH/my-role.yaml
  #echo $t
  #echo $HR
  echo "kubectl create rolebinding my-binding -n=chp12-set1227 --clusterrole=cluster-admin --group=system:serviceaccounts"
  kubectl create rolebinding my-binding -n=chp12-set1227 --clusterrole=cluster-admin --group=system:serviceaccounts > /dev/null 2>&1
  echo ""
  #echo $t
  #echo ""
  echo "kubectl exec -it my-pod -n=chp12-set1227 -- curl $t"
  kubectl exec -it my-pod -n=chp12-set1227 -- curl $t
  echo ""
  echo $HR

  kubectl delete rolebinding my-binding -n=chp12-set1227 --ignore-not-found > /dev/null 2>&1
  echo "kubectl create rolebinding my-binding -n=chp12-set1227 --clusterrole=view --group=system:serviceaccounts"
  kubectl create rolebinding my-binding -n=chp12-set1227 --clusterrole=view --group=system:serviceaccounts > /dev/null 2>&1
  echo ""
  #echo $t
  #echo ""
  echo "kubectl exec -it my-pod -n=chp12-set1227 -- curl $t"
  kubectl exec -it my-pod -n=chp12-set1227 -- curl $t
  echo ""

  echo $HR
  sleep 3
done


kubectl delete -f $FULLPATH
