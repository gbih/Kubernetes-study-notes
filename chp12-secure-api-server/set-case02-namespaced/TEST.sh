#!/bin/bash
. ~/src/common/setup.sh
FULLPATH=$(pwd)
echo "12.2.7 Granting authorization permissions wisely"
echo $HR_TOP

function urlTest() {

  echo "Get cluster-level, non-namespaced resources" 
#  echo "kubectl exec -it my-pod -n chp12-set1227 -- curl localhost:8001/api/v1/componentstatuses"
  #kubectl exec -it my-pod -- curl localhost:8001/api/v1/componentstatuses
  # kubectl exec -it my-pod -n=chp12-set1227 -- curl http://localhost:8001/apis/storage.k8s.io/v1/storageclasses
  # kubectl exec -it my-pod -n=chp12-set1227 -- curl http://localhost:8001/apis/storage.k8s.io/v1/volumeattachments
  # kubectl exec -it my-pod -n=chp12-set1227 -- curl http://localhost:8001/api/v1/persistentvolumes
  # kubectl exec -it my-pod -n=chp12-set1227 -- curl http://localhost:8001/apis/admissionregistration.k8s.io/v1/validatingwebhookconfigurations
   kubectl exec -it my-pod -n=chp12-set1227 -- curl http://localhost:8001/apis/rbac.authorization.k8s.io/v1/roles




# .[]? is similar to .[], but no errors will be output if . is not an array or object.
  #echo "kubectl exec -it my-pod -n chp12-set1227 -- curl localhost:8001/apis/apps/v1/deployments | jq -r '.items[]?.metadata.name'"
  #kubectl exec -it my-pod -n chp12-set1227 -- curl localhost:8001/apis/apps/v1/deployments | jq -r '.items[]?.metadata.name'

}

###########################################

# Make sure any clusterrolebindings are deleted beforehand
kubectl delete clusterrolebinding my-binding --ignore-not-found
#kubectl delete rolebinding my-binding -n chp12-set1227 --ignore-not-found

kubectl apply -f $FULLPATH/set1227-0-ns.yaml
kubectl apply -f $FULLPATH/set1227-1-sa.yaml
#kubectl apply -f $FULLPATH/set1227-2-pod.yaml
kubectl apply -f $FULLPATH/set1227-3-pod-sa.yaml
#kubectl apply -f $FULLPATH/tokenreview-clusterrolebinding.yaml

echo $HR
echo "kubectl wait --for=condition=Ready=True pod/my-pod -n=chp12-set1227 --timeout=20s"
kubectl wait --for=condition=Ready=True pod/my-pod -n=chp12-set1227 --timeout=20s



# Start at root-level permissions, then work out how to lock it down iteratively
# OK: his gives all service accounts (and implicitly pods) cluster-admin privileges
# kubectl create clusterrolebinding my-binding --clusterrole=cluster-admin --group=system:serviceaccounts --dry-run=client -o yaml > crb-1.yaml

# OK: Gives cluster-admin privileges to all service accounts in namespace chp12-set1227
# kubectl create clusterrolebinding my-binding --clusterrole=cluster-admin --group=system:serviceaccounts:chp12-set1227 --dry-run=client -o yaml > crb-1.yaml

# OK: Gives cluster-admin privileges to service account my-sa in namespace chp12-set1227
#kubectl create clusterrolebinding my-binding --clusterrole=cluster-admin --serviceaccount=chp12-set1227:my-sa --dry-run=client -o yaml > crb-1.yaml

kubectl create clusterrolebinding my-binding --clusterrole=admin --serviceaccount=chp12-set1227:my-sa --dry-run=client -o yaml > crb-1.yaml

#kubectl create clusterrolebinding my-binding --clusterrole=edit --serviceaccount=chp12-set1227:my-sa --dry-run=client -o yaml > crb-1.yaml

#kubectl create clusterrolebinding my-binding --clusterrole=view --serviceaccount=chp12-set1227:my-sa --dry-run=client -o yaml > crb-1.yaml

echo ""
value=$(<crb-1.yaml)
echo "$value"
echo $HR
echo "kubectl apply -f $FULLPATH/crb-1.yaml"
kubectl apply -f $FULLPATH/crb-1.yaml
echo $HR
kubectl get clusterrolebinding my-binding -o wide
echo ""
kubectl get clusterrole cluster-admin
urlTest
echo $HR

echo "kubectl delete clusterrolebinding my-binding"
kubectl delete clusterrolebinding my-binding

###########################################

#kubectl delete pod/my-pod -n chp12-set1227
