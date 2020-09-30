#!/bin/bash
. ../../SETUP.sh
FULLPATH=$(pwd)

echo "NOTES:"
echo "Simplifying API server communication with ambassador containers" 
echo $HR

kubectl apply -f $FULLPATH
#sleep 1


echo "kubectl get events -n=chp08-set823"
kubectl get events -n=chp08-set823
echo $HR

echo "kubectl wait --for=condition=Ready=True pod/curl-with-ambassador -n=chp08-set823 --timeout=20s"
kubectl wait --for=condition=Ready=True pod/curl-with-ambassador -n=chp08-set823 --timeout=20s
echo $HR


echo "kubectl get events -n=chp08-set823"
kubectl get events -n=chp08-set823
echo $HR


echo "kubectl get all -n=chp08-set823"
kubectl get all -n=chp08-set823
echo ""

echo "kubectl get endpoints -n=chp08-set823"
kubectl get endpoints -n=chp08-set823
echo $HR

#echo "Talking to the API server through the main container (should fail)"
#echo "kubectl -n=chp08-set823 exec curl-with-ambassador -c main -- curl localhost:8001"
#echo ""
#kubectl -n=chp08-set823 exec curl-with-ambassador -c main -- curl localhost:8001
#echo ""
#echo $HR


echo "Workaround for RBAC"
echo "This gives all service accounts (we could also say all pods) cluster-admin privileges, allowing them to do whatever they want."
echo "kubectl create clusterrolebinding permissive-binding --clusterrole=cluster-admin --group=system:serviceaccounts"
echo ""
kubectl create clusterrolebinding permissive-binding --clusterrole=cluster-admin --group=system:serviceaccounts

sleep 1
echo $HR


echo "Talking to the API server through the Ambassador Container Pattern"
echo "kubectl -n=chp08-set823 exec curl-with-ambassador -c ambassador -- curl localhost:8001"
echo ""
echo "kubectl -n=chp08-set823 exec curl-with-ambassador -c ambassador -- curl http://localhost:8001/api/v1/namespaces/chp08-set823/pods -v"
#kubectl -n=chp08-set823 exec curl-with-ambassador -c ambassador -- curl http://localhost:8001/api/v1/namespaces/chp08-set823/pods -v
kubectl -n=chp08-set823 exec curl-with-ambassador -c ambassador -- curl http://localhost:8001/api/v1/namespaces/chp08-set823/pods

echo $HR

kubectl -n=chp08-set823 exec curl-with-ambassador -c ambassador -- curl http://localhost:8001/api/v1/namespaces/chp08-set823/pods -v

echo ""
echo $HR

echo "kubectl get events -n=chp08-set823"
kubectl get events -n=chp08-set823
echo $HR

kubectl delete -f $FULLPATH --now
kubectl delete clusterrolebinding permissive-binding
echo $HR
