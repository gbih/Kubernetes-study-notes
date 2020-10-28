#!/bin/bash
. ~/src/common/setup.sh
FULLPATH=$(pwd)
echo "12.2.7 Granting authorization permissions wisely"
echo $HR_TOP

function urlTest() {

  echo "CURL" 
   kubectl exec -it my-pod -n=chp12-set1227 -- curl localhost:8001/api/v1/namespaces/chp12-set1227/nodes

  echo ""
}

###########################################

# Make sure any rolebindings are deleted beforehand
kubectl delete rolebinding my-binding -n=chp12-set1227 --ignore-not-found
kubectl delete role my-role -n=chp12-set1227 --ignore-not-found

kubectl apply -f $FULLPATH/set1227-0-ns.yaml
kubectl apply -f $FULLPATH/set1227-1-sa.yaml



#ROLE
kubectl create role my-role --verb=get --verb=list --resource=nodes -n chp12-set1227 --dry-run=client -o yaml > my-role.yaml

kubectl apply -f $FULLPATH/my-role.yaml
#sleep 1

#kubectl create role my-role --verb=get --verb=list --resource=pods -n chp12-set1227



#kubectl apply -f $FULLPATH/set1227-2-pod.yaml
kubectl apply -f $FULLPATH/set1227-3-pod-sa.yaml
#kubectl apply -f $FULLPATH/tokenreview-rolebinding.yaml

echo $HR
echo "kubectl wait --for=condition=Ready=True pod/my-pod -n=chp12-set1227 --timeout=20s"
kubectl wait --for=condition=Ready=True pod/my-pod -n=chp12-set1227 --timeout=20s



#kubectl create role myrole --verb=get --verb=list --resource=configmaps -n chp12-set1227

# Start at root-level permissions, then work out how to lock it down iteratively
# OK: his gives all service accounts (and implicitly pods) cluster-admin privileges
#kubectl create rolebinding my-binding -n=chp12-set1227 --clusterrole=cluster-admin --group=system:serviceaccounts --dry-run=client -o yaml > rb-1.yaml

# OK: Gives cluster-admin privileges to all service accounts in namespace chp12-set1227
#kubectl create rolebinding my-binding -n=chp12-set1227 --clusterrole=cluster-admin --group=system:serviceaccounts:chp12-set1227 --dry-run=client -o yaml > rb-1.yaml

# OK: Gives cluster-admin privileges to service account my-sa in namespace chp12-set1227
#kubectl create rolebinding my-binding -n=chp12-set1227 --clusterrole=cluster-admin --serviceaccount=chp12-set1227:my-sa --dry-run=client -o yaml > rb-1.yaml

#kubectl create rolebinding my-binding -n=chp12-set1227 --clusterrole=admin --serviceaccount=chp12-set1227:my-sa --dry-run=client -o yaml > rb-1.yaml

#kubectl create rolebinding my-binding -n=chp12-set1227 --clusterrole=edit --serviceaccount=chp12-set1227:my-sa --dry-run=client -o yaml > rb-1.yaml

kubectl create rolebinding my-binding -n=chp12-set1227 --role=my-role --serviceaccount=chp12-set1227:my-sa --dry-run=client -o yaml > rb-1.yaml

#echo ""
#value=$(<rb-1.yaml)
#echo "$value"
#echo $HR
echo "kubectl apply -f $FULLPATH/rb-1.yaml"
kubectl apply -f $FULLPATH/rb-1.yaml
echo $HR
kubectl get rolebinding my-binding -n=chp12-set1227 -o wide
echo ""
#kubectl get clusterrole cluster-admin
urlTest
echo $HR

#echo "kubectl delete rolebinding my-binding -n=chp12-set1227"
#kubectl delete rolebinding my-binding -n=chp12-set1227

###########################################

#kubectl delete pod/my-pod -n chp12-set1227
