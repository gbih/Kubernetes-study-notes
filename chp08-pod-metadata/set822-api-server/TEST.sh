#!/bin/bash
. ~/src/COMMON/SETUP.sh
FULLPATH=$(pwd)
echo $HR_TOP

echo "kubectl apply -f $FULLPATH"
kubectl apply -f $FULLPATH
sleep 1

echo "kubectl wait --for=condition=Ready=True pod/curlpod -n=chp08-set822 --timeout=20s"
kubectl wait --for=condition=Ready=True pod/curlpod -n=chp08-set822 --timeout=20s
echo $HR


echo "kubectl -n=chp08-set822 exec curlpod -- env"
kubectl -n=chp08-set822 exec curlpod -- env
echo $HR


echo "kubectl exec -it curlpod -n=chp08-set822 -- cat /etc/resolv.conf"
kubectl exec -it curlpod -n=chp08-set822 -- cat /etc/resolv.conf
echo $HR

echo "CLUSTER_IP=\$(kubectl get svc -o jsonpath={'.items[0].spec.clusterIP'})"
CLUSTER_IP=$(kubectl get svc -o jsonpath={'.items[0].spec.clusterIP'})
echo $CLUSTER_IP
echo $HR

echo "Expect error in this step, as we are not yet using the ca.crt file."
echo ""
echo "curl https://$CLUSTER_IP"
curl https://$CLUSTER_IP

enter

echo "Verify the server's identity"
echo ""
echo "To verify you’re talking to the API server, you need to check if the server’s certificate is signed by the CA"
echo "curl allows you to specify the CA certificate with the --cacert option"
echo ""

echo "kubectl -n=chp08-set822 exec curlpod -- curl --cacert /var/run/secrets/kubernetes.io/serviceaccount/ca.crt https://$CLUSTER_IP"
kubectl -n=chp08-set822 exec curlpod -- curl --cacert /var/run/secrets/kubernetes.io/serviceaccount/ca.crt https://$CLUSTER_IP

enter

echo "TOKEN=\$(kubectl -n=chp08-set822 exec curlpod -- cat /var/run/secrets/kubernetes.io/serviceaccount/token)"
TOKEN=$(kubectl -n=chp08-set822 exec curlpod -- cat /var/run/secrets/kubernetes.io/serviceaccount/token)
echo "TOKEN is $TOKEN"

echo $HR

echo "NAMESPACE=\$(kubectl -n=chp08-set822 exec curlpod -- cat /var/run/secrets/kubernetes.io/serviceaccount/namespace)"
NAMESPACE=$(kubectl -n=chp08-set822 exec curlpod -- cat /var/run/secrets/kubernetes.io/serviceaccount/namespace)
echo "NAMESPACE is $NAMESPACE"

enter

echo "kubectl -n=chp08-set822 exec curlpod -- curl --cacert /var/run/secrets/kubernetes.io/serviceaccount/ca.crt https://$CLUSTER_IP/api/v1/namespaces/chp08-set822/pods -H \"Authorization: Bearer $TOKEN\""

echo ""
kubectl -n=chp08-set822 exec curlpod -- curl --cacert /var/run/secrets/kubernetes.io/serviceaccount/ca.crt https://$CLUSTER_IP/api/v1/namespaces/chp08-set822/pods -H "Authorization: Bearer $TOKEN" | more


echo $HR
echo "kubectl delete -f $FULLPATH"
kubectl delete -f $FULLPATH

