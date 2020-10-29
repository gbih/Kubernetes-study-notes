#!/bin/bash
. ~/src/common/setup.sh
FULLPATH=$(pwd)
echo "12.2.8 Explore through privilege levels with RoleBindings"
echo $HR_TOP


function urlTest() {
  echo "Query services in this namespace"
  echo "kubectl exec -it my-pod -n chp12-set1228 -- curl localhost:8001/api/v1/namespaces/chp12-set1228/services"
  kubectl exec -it my-pod -n chp12-set1228 -- curl localhost:8001/api/v1/namespaces/chp12-set1228/services
  echo ""
}

###########################################

# Make sure any clusterrolebindings are deleted beforehand
kubectl delete clusterrolebinding my-binding --ignore-not-found
kubectl delete rolebinding my-binding -n chp12-set1228 --ignore-not-found

kubectl apply -f $FULLPATH/set1228-0-ns.yaml
kubectl apply -f $FULLPATH/set1228-1-sa.yaml
kubectl apply -f $FULLPATH/set1228-2-pod.yaml

echo $HR
echo "kubectl wait --for=condition=Ready=True pod/my-pod -n=chp12-set1228 --timeout=20s"
kubectl wait --for=condition=Ready=True pod/my-pod -n=chp12-set1228 --timeout=20s

enter

echo "1. For all service accounts everywhere:"
echo "kubectl create rolebinding my-binding -n=chp12-set1228 --clusterrole=view --group=system:serviceaccounts --dry-run=client -o yaml > rb-1.yaml"

kubectl create rolebinding my-binding -n=chp12-set1228 --clusterrole=view --group=system:serviceaccounts --dry-run=client -o yaml > rb-1.yaml

echo $HR
echo "kubectl apply -f $FULLPATH/rb-1.yaml"
kubectl apply -f $FULLPATH/rb-1.yaml
echo $HR
urlTest
echo $HR
echo "kubectl delete rolebinding my-binding -n=chp12-set1228"
kubectl delete rolebinding my-binding -n=chp12-set1228
enter

###########################################

echo "2. For all service accounts in the chp12-set1228  namespace:"
echo "kubectl create rolebinding my-binding -n=chp12-set1228 --clusterrole=view --group=system:serviceaccounts:chp12-set1228 --dry-run=client -o yaml > rb-2.yaml"

kubectl create rolebinding my-binding -n=chp12-set1228 --clusterrole=view --group=system:serviceaccounts:chp12-set1228 --dry-run=client -o yaml > rb-2.yaml

echo $HR
echo "kubectl apply -f $FULLPATH/rb-2.yaml"
kubectl apply -f $FULLPATH/rb-2.yaml
echo $HR
urlTest
echo $HR
echo "kubectl delete rolebinding my-binding -n=chp12-set1228"
kubectl delete rolebinding my-binding -n=chp12-set1228
enter

###########################################

echo "3. For all authenticated users"
echo "kubectl create rolebinding my-binding -n=chp12-set1228 --clusterrole=view --group=system:authenticated --dry-run=client -o yaml > rb-3.yaml"

kubectl create rolebinding my-binding -n=chp12-set1228 --clusterrole=view --group=system:authenticated --dry-run=client -o yaml > rb-3.yaml

echo $HR
echo "kubectl apply -f $FULLPATH/rb-3.yaml"
kubectl apply -f $FULLPATH/rb-3.yaml
echo $HR
urlTest
echo $HR
echo "kubectl delete rolebinding my-binding -n=chp12-set1228"
kubectl delete rolebinding my-binding -n=chp12-set1228
enter

###########################################

echo "4. For all unauthenticated users"
echo "kubectl create rolebinding my-binding -n=chp12-set1228 --clusterrole=view --group=system:unauthenticated --dry-run=client -o yaml > rb-4.yaml"

kubectl create rolebinding my-binding -n=chp12-set1228 --clusterrole=view --group=system:unauthenticated --dry-run=client -o yaml > rb-4.yaml

echo $HR
echo "kubectl apply -f $FULLPATH/rb-4.yaml"
kubectl apply -f $FULLPATH/rb-4.yaml
echo $HR
urlTest
echo $HR
echo "kubectl delete rolebinding my-binding -n=chp12-set1228"
kubectl delete rolebinding my-binding -n=chp12-set1228
enter

###########################################

echo "5. For all users (both authenticated and unauthenticated)"
echo "kubectl create rolebinding my-binding -n=chp12-set1228 --clusterrole=view --group=system:unauthenticated --group=system:authenticated --dry-run=client -o yaml > rb-5.yaml"

kubectl create rolebinding my-binding -n=chp12-set1228 --clusterrole=view --group=system:unauthenticated --group=system:authenticated --dry-run=client -o yaml > rb-5.yaml

echo $HR
echo "kubectl apply -f $FULLPATH/rb-5.yaml"
kubectl apply -f $FULLPATH/rb-5.yaml
echo $HR
urlTest
echo $HR
echo "kubectl delete rolebinding my-binding -n=chp12-set1228"
kubectl delete rolebinding my-binding -n=chp12-set1228
enter


###########################################

echo "SERVICE ACCOUNT PERMISSIONS"
echo ""

echo "6. Grant read-only permissions within chp12-set1228 to the my-sa service account"
echo "kubectl create rolebinding my-binding -n=chp12-set1228 --clusterrole=view --serviceaccount=chp12-set1228:my-sa --dry-run=client -o yaml > rb-6.yaml"

kubectl create rolebinding my-binding -n=chp12-set1228 --clusterrole=view --serviceaccount=chp12-set1228:my-sa --dry-run=client -o yaml > rb-6.yaml

echo $HR
echo "kubectl apply -f $FULLPATH/rb-6.yaml"
kubectl apply -f $FULLPATH/rb-6.yaml
echo $HR
urlTest
echo $HR
echo "kubectl delete rolebinding my-binding -n=chp12-set1228"
kubectl delete rolebinding my-binding -n=chp12-set1228
enter

###########################################

# https://unofficial-kubernetes.readthedocs.io/en/latest/admin/authorization/rbac/

echo "SERVICE ACCOUNT PERMISSIONS"
echo ""

echo "7. Grant read-only permissions within chp12-set1228 to the default service account"
echo "kubectl create rolebinding my-binding -n=chp12-set1228 --clusterrole=view --serviceaccount=chp12-set1228:default --dry-run=client -o yaml > rb-7.yaml"

kubectl create rolebinding my-binding -n=chp12-set1228 --clusterrole=view --serviceaccount=chp12-set1228:my-sa --dry-run=client -o yaml > rb-7.yaml

echo $HR
echo "kubectl apply -f $FULLPATH/rb-7.yaml"
kubectl apply -f $FULLPATH/rb-7.yaml
echo $HR
urlTest
echo $HR
echo "kubectl delete rolebinding my-binding -n=chp12-set1228"
kubectl delete rolebinding my-binding -n=chp12-set1228
enter

###########################################

# https://unofficial-kubernetes.readthedocs.io/en/latest/admin/authorization/rbac/

echo "SERVICE ACCOUNT PERMISSIONS"
echo ""

echo "8. Grant read-only permissions within chp12-set1228 to all service accounts in that namespace."
echo "kubectl create rolebinding my-binding -n=chp12-set1228 --clusterrole=view --group=system:serviceaccounts:chp12-set1228 --dry-run=client -o yaml > rb-8.yaml"

kubectl create rolebinding my-binding -n=chp12-set1228 --clusterrole=view --group=system:serviceaccounts:chp12-set1228 --dry-run=client -o yaml > rb-8.yaml

echo $HR
echo "kubectl apply -f $FULLPATH/rb-8.yaml"
kubectl apply -f $FULLPATH/rb-8.yaml
echo $HR
urlTest
echo $HR
echo "kubectl delete rolebinding my-binding -n=chp12-set1228"
kubectl delete rolebinding my-binding -n=chp12-set1228
enter


###########################################

# https://unofficial-kubernetes.readthedocs.io/en/latest/admin/authorization/rbac/

echo "SERVICE ACCOUNT PERMISSIONS"
echo ""

echo "9. Grant read-only permissions within chp12-set1228 to all service accounts"
echo "kubectl create rolebinding my-binding -n=chp12-set1228 --clusterrole=view --group=system:serviceaccounts --dry-run=client -o yaml > rb-9.yaml"

kubectl create rolebinding my-binding -n=chp12-set1228 --clusterrole=view --group=system:serviceaccounts --dry-run=client -o yaml > rb-9.yaml

echo $HR
echo "kubectl apply -f $FULLPATH/rb-9.yaml"
kubectl apply -f $FULLPATH/rb-9.yaml
echo $HR
urlTest
echo $HR
echo "kubectl delete rolebinding my-binding -n=chp12-set1228"
kubectl delete rolebinding my-binding -n=chp12-set1228
enter





###########################################

# Make sure any clusterrolebindings are deleted afterward
kubectl delete -f $FULLPATH
kubectl delete clusterrolebinding my-binding --ignore-not-found
kubectl delete rolebinding my-binding -n chp12-set1228 --ignore-not-found
