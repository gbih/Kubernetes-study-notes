#!/bin/bash
. ~/src/common/setup.sh
FULLPATH=$(pwd)
echo "12.2.7 Granting authorization permissions wisely"
echo "Iterate accessing the API Server with varying levels of priviledge"
echo $HR_TOP

function urlTest() {

  # .[]? is similar to .[], but no errors will be output if . is not an array or object.
  echo "kubectl exec -it my-pod -n chp12-set1227 -- curl localhost:8001/apis/apps/v1/deployments | jq -r '.items[]?.metadata.name'"
  kubectl exec -it my-pod -n chp12-set1227 -- curl localhost:8001/apis/apps/v1/deployments | jq -r '.items[]?.metadata.name'
  echo $HR
  echo "kubectl exec -it my-pod -n chp12-set1227 -- curl localhost:8001/api/v1/namespaces/chp12-set1227/services"
  kubectl exec -it my-pod -n chp12-set1227 -- curl localhost:8001/api/v1/namespaces/chp12-set1227/services
  echo ""
  echo $HR
  echo "kubectl exec -it my-pod -n chp12-set1227 -- curl localhost:8001/api/v1/persistentvolumes"
  kubectl exec -it my-pod -n chp12-set1227 -- curl localhost:8001/api/v1/persistentvolumes
  echo ""

}

###########################################

kubectl delete clusterrolebinding my-binding --ignore-not-found
kubectl delete rolebinding my-binding -n chp12-set1227 --ignore-not-found

kubectl apply -f $FULLPATH/set1227-0-ns.yaml
kubectl apply -f $FULLPATH/set1227-1-sa.yaml
kubectl apply -f $FULLPATH/set1227-2-pod.yaml

echo $HR
echo "kubectl wait --for=condition=Ready=True pod/my-pod -n=chp12-set1227 --timeout=20s"
kubectl wait --for=condition=Ready=True pod/my-pod -n=chp12-set1227 --timeout=20s

enter


echo "1. Grant super-user access to all service accounts cluster-wide (not recommended)"
echo "This does not partition permissions at all and grants super-use access to all service accounts"
echo "This allows any application full access to the cluster, and also grants any user with read access to Secrets (or the ability to create any pod) full access to the cluster"
echo ""
echo "kubectl create clusterrolebinding my-binding --clusterrole=cluster-admin --group=system:serviceaccounts --dry-run=client -o yaml > crb-1.yaml"
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
enter
urlTest
echo $HR
echo "kubectl delete clusterrolebinding my-binding"
kubectl delete clusterrolebinding my-binding
enter

###########################################

echo "1b. Test for accessing non-namespaced resources, like PersistentVolumes"
echo "You have to use ClusterRoleBinding in order to access cluster-level resources, such as PV"
echo "kubectl create clusterrolebinding my-binding --clusterrole=view --group=system:authenticated --dry-run=client -o yaml > crb-1b.yaml"
echo ""
value=$(<crb-1b.yaml)
echo "$value"
kubectl apply -f $FULLPATH/crb-1b.yaml
enter
urlTest
echo $HR
echo "kubectl delete clusterrolebinding my-binding"
kubectl delete clusterrolebinding my-binding
enter

###########################################

echo "2. Grant a limited role to all service accounts cluster-wide (not recommended)"
echo "If you don't want to manage permissions per-namespace, you can grant a cluster-wide role to all service accounts."
echo "This grants read-only permission across all namespaces to all service accounts in the cluster."
echo ""
echo "kubectl create clusterrolebinding my-binding --clusterrole=view --group=system:serviceaccounts --dry-run=client -o yaml > crb-2.yaml"
echo ""
value=$(<crb-2.yaml)
echo "$value"
echo $HR
echo "kubectl apply -f $FULLPATH/crb-2.yaml"
kubectl apply -f $FULLPATH/crb-2.yaml
echo $HR
kubectl get clusterrolebinding my-binding -o wide
echo ""
kubectl get clusterrole view
enter
urlTest
echo $HR
echo "kubectl delete clusterrolebinding my-binding"
kubectl delete clusterrolebinding my-binding
enter

###########################################

echo "3. Grant a role to all service accounts in a namespace"
echo "If you want all applications in a namespace to have a role, no matter what service account they use,"
echo "you can grant a role to the service account group for that namespace."
echo "Here, grant read-only permission within the chp12-set1227 namespace to all service accounts in that namespace."
echo ""
echo "kubectl create rolebinding my-binding --clusterrole=view --group=system:serviceaccounts:chp12-set1227 -n chp12-set1227 --dry-run=client -o yaml > crb-3.yaml"
echo ""
value=$(<crb-3.yaml)
echo "$value"
echo $HR
echo "kubectl apply -f $FULLPATH/crb-3.yaml"
kubectl apply -f $FULLPATH/crb-3.yaml
echo $HR
kubectl get rolebinding my-binding -n chp12-set1227 -o wide
echo ""
kubectl get clusterrole view
echo ""
kubectl get sa -n chp12-set1227
enter
urlTest
echo $HR
echo "kubectl delete rolebinding my-binding -n ch12-set1227"
kubectl delete rolebinding my-binding -n chp12-set1227
enter

###########################################

echo "4. Grant a role to the default service account in a namespace"
echo "If an application does not specify a serviceAccountName, it uses the 'default' service account"
echo "Permissions given to the 'default' service account are available to any pod in the namespace that does not specify a serviceAccountName"
echo "Here, grant read-only permission within namespace chp12-set1227 to the the default service account"
echo ""
echo "kubectl create rolebinding my-binding --clusterrole=view --serviceaccount=chp12-set1227:default -n chp12-set1227 --dry-run=client -o yaml > crb-4.yaml"
echo ""
value=$(<crb-4.yaml)
echo "$value"
echo $HR
echo "kubectl apply -f $FULLPATH/crb-4.yaml"
kubectl apply -f $FULLPATH/crb-4.yaml
echo $HR
kubectl get rolebinding my-binding -n chp12-set1227
echo ""
kubectl get clusterrole view
echo ""
kubectl get sa default -n chp12-set1227
enter
urlTest
echo "kubectl delete rolebinding my-binding -n chp12-set1227"
kubectl delete rolebinding my-binding -n chp12-set1227
enter

###########################################

echo "5. Grant a role to an application-specific service account (best practice)"
echo "This requires the application to specify a serviceAccountName in its pod spec, and for the service account to be created)."
echo "Here, we grant read-only permission within chp12-set1227 to the specified service account my-sa"
echo ""
echo "kubectl create rolebinding my-binding --clusterrole=view --serviceaccount=chp12-set1227:my-sa -n chp12-set1227 --dry-run=client -o yaml > crb-5.yaml"
echo ""
value=$(<crb-5.yaml)
echo "$value"
echo $HR
kubectl apply -f $FULLPATH/crb-5.yaml
kubectl get rolebinding my-binding -n chp12-set1227
echo ""
kubectl get clusterrole view
echo ""
kubectl get sa my-sa -n chp12-set1227
enter
urlTest
echo $HR
echo "kubectl delete rolebinding my-binding -n chp12-set1227"
kubectl delete rolebinding my-binding -n chp12-set1227
enter

##########################################

echo "6. Grant a role to an application-specific service account, using Roleinstead of ClusterRole (best practice)"
echo "This requires the application to specify a serviceAccountName in its pod spec, and for the service account to be created). We use a customized Role, instead of the built-in ClusterRole."

echo ""
echo "kubectl create rolebinding my-binding --role=service-reader --serviceaccount=chp12-set1227:my-sa -n chp12-set1227 --dry-run=client -o yaml > rb-6.yaml"
echo ""
value=$(<set1227-3-role-services.yaml)
echo "$value"
echo $HR
value=$(<rb-6.yaml)
echo "$value"
echo $HR
kubectl apply -f $FULLPATH/rb-6.yaml
kubectl get rolebinding my-binding -n chp12-set1227
echo ""
kubectl get role service-reader -n chp12-set1227
echo ""
kubectl get sa my-sa -n chp12-set1227
enter
urlTest
echo $HR
echo "kubectl delete rolebinding my-binding -n chp12-set1227"
kubectl delete rolebinding my-binding -n chp12-set1227
enter

##########################################

kubectl delete -f $FULLPATH --ignore-not-found
