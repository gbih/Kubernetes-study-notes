#!/bin/bash
. ~/src/SETUP.sh
FULLPATH=$(pwd)

echo $HR_TOP

echo "kubectl apply -f $FULLPATH"
kubectl apply -f $FULLPATH
sleep 1

echo $HR

echo "POD2=\$(kubectl get pods -n=chp05-set544 -o jsonpath='{.items[2].metadata.name}')"
POD2=$(kubectl get pods -n=chp05-set544 -o jsonpath='{.items[2].metadata.name}')

echo "kubectl wait --for=condition=Ready=True -n=chp05-set544 pods/$POD2 --timeout=30s"
kubectl wait --for=condition=Ready=True -n=chp05-set544 pods/$POD2 --timeout=30s

echo $HR

rm tls.key
rm tls.cert

echo "kubectl get all -o wide -n=chp05-set544"
kubectl get all -o wide -n=chp05-set544

echo $HR

echo "kubectl get ingress.networking.k8s.io kubia -n=chp05-set544"
kubectl get ingress.networking.k8s.io kubia -n=chp05-set544 -o wide

echo $HR

INGRESS_IP=$(kubectl get ingress.networking.k8s.io kubia -n=chp05-set544 -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
echo "INGRESS_IP is $INGRESS_IP"

echo "Manually add this line to /etc/hosts"
echo "INGRESS_IP kubia.example.com"

echo $HR

echo "Create key"
openssl genrsa -out tls.key 2048

echo $HR

echo "Create certificate"
openssl req -new -x509 -key tls.key -out tls.cert -days 360 -subj "/CN=kubia.example.com"

echo $HR

echo "Create the Secret from the two files"
echo "kubectl create secret tls tls-secret --cert=tls.cert --key=tls.key -n=chp05-set544"
kubectl create secret tls tls-secret --cert=tls.cert --key=tls.key -n=chp05-set544

sleep 3

echo $HR

echo "Confirm Secret object"
echo "kubectl get secrets -n=chp05-set544"
kubectl get secrets -n=chp05-set544

echo $HR

echo "SECRET_OBJECT=\$(kubectl get secrets -n=chp05-set544 -o jsonpath='{.items[0].metadata.name}')"
SECRET_OBJECT=$(kubectl get secrets -n=chp05-set544 -o jsonpath='{.items[0].metadata.name}')
echo "SECRET_OBJECT IS $SECRET_OBJECT"

echo $HR

echo "kubectl describe secrets/$SECRET_OBJECT -n=chp05-set544"
kubectl describe secrets/$SECRET_OBJECT -n=chp05-set544 

echo $HR

echo "Handle TLS traffic to pods with Ingress"
echo ""

echo "curl -k https://kubia.example.com/kubia"
curl -k https://kubia.example.com/kubia
echo ""

echo "curl -k https://kubia.example.com/kubia"
curl -k https://kubia.example.com/kubia
echo ""

echo "curl -k https://kubia.example.com/kubia"
curl -k https://kubia.example.com/kubia

echo $HR

echo "kubectl delete -f $FULLPATH"
kubectl delete -f $FULLPATH

