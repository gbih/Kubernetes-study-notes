#!/bin/bash
. ~/src/SETUP.sh
FULLPATH=$(pwd)

echo "NOTES:"

echo "* Talking to the API server from within a pod" 
echo "* Sometimes your app will need to know more about other pods and even other resources defined in your cluster. The Downward API doesn’t help in those cases."

echo "Here we work through how to talk to the API server from within a pod, where you (usually) don’t have kubectl. Therefore, to talk to the API server from inside a pod, you need to take care of three things:
  1. Find the location of the API server.
  2. Make sure you’re talking to the API server and not something impersonating it.
  3. Authenticate with the server; otherwise it won’t let you see or do anything.
"


echo $HR
echo "kubectl apply -f $FULLPATH"
kubectl apply -f $FULLPATH
sleep 1

echo "kubectl wait --for=condition=Ready=True pod/curl -n=chp08-set822 --timeout=20s"
kubectl wait --for=condition=Ready=True pod/curl -n=chp08-set822 --timeout=20s
echo $HR


echo "kubectl -n=chp08-set822 exec curl -- env | grep KUBERNETES_SERVICE"
kubectl -n=chp08-set822 exec curl -- env | grep KUBERNETES_SERVICE
echo $HR


echo "kubectl exec -it curl -n=chp08-set822 -- cat /etc/resolv.conf"
kubectl exec -it curl -n=chp08-set822 -- cat /etc/resolv.conf
echo $HR

kubectl get svc -o wide 
echo $HR


CLUSTER_IP=$(kubectl get svc -o jsonpath={'.items[0].spec.clusterIP'})
echo $CLUSTER_IP
echo ""

echo "curl https://$CLUSTER_IP"
curl https://$CLUSTER_IP
echo $HR


echo "Verify the server's identity"
echo "To verify you’re talking to the API server, you need to check if the server’s certificate is signed by the CA"
echo "curl allows you to specify the CA certificate with the --cacert option"
echo ""

echo "kubectl -n=chp08-set822 exec curl -- curl --cacert /var/run/secrets/kubernetes.io/serviceaccount/ca.crt https://$CLUSTER_IP"
kubectl -n=chp08-set822 exec curl -- curl --cacert /var/run/secrets/kubernetes.io/serviceaccount/ca.crt https://$CLUSTER_IP

echo $HR

echo "GET TOKEN"
TOKEN=$(kubectl -n=chp08-set822 exec curl -- cat /var/run/secrets/kubernetes.io/serviceaccount/token)
echo "TOKEN is $TOKEN"
echo ""


echo "GET NAMESPACE"
NAMESPACE=$(kubectl -n=chp08-set822 exec curl -- cat /var/run/secrets/kubernetes.io/serviceaccount/namespace)
echo "NAMESPACE is $NAMESPACE"
echo ""


echo "Workaround for RBAC"
echo "This gives all service accounts (we could also say all pods) cluster-admin privileges, allowing them to do whatever they want."
echo "kubectl create clusterrolebinding permissive-binding --clusterrole=cluster-admin --group=system:serviceaccounts"
echo ""
kubectl create clusterrolebinding permissive-binding --clusterrole=cluster-admin --group=system:serviceaccounts

sleep 1
echo $HR


echo 'kubectl -n=chp08-set822 exec curl -- curl --cacert /var/run/secrets/kubernetes.io/serviceaccount/ca.crt https://$CLUSTER_IP/api/v1/namespaces/chp08-set822/pods -H "Authorization: Bearer $TOKEN"'
kubectl -n=chp08-set822 exec curl -- curl --cacert /var/run/secrets/kubernetes.io/serviceaccount/ca.crt https://$CLUSTER_IP/api/v1/namespaces/chp08-set822/pods -H "Authorization: Bearer $TOKEN" 



echo $HR
kubectl delete -f $FULLPATH --now
#kubectl delete clusterrolebinding permissive-binding -n=system
kubectl delete clusterrolebinding permissive-binding
echo $HR

