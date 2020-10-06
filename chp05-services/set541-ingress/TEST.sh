#!/bin/bash
. ~/src/common/setup.sh
FULLPATH=$(pwd)

echo $HR_TOP

echo "kubectl apply -f $FULLPATH"
kubectl apply -f $FULLPATH
echo $HR

sleep 3

echo "POD8=\$(kubectl get pods -n=chp05-set541 -o jsonpath='{.items[8].metadata.name}')"
POD8=$(kubectl get pods -n=chp05-set541 -o jsonpath='{.items[8].metadata.name}')
echo ""

echo "kubectl wait --for=condition=Ready=True -n=chp05-set541 pods/$POD8 --timeout=30s"
kubectl wait --for=condition=Ready=True -n=chp05-set541 pods/$POD8 --timeout=30s

echo $HR


echo "kubectl get ingress.networking.k8s.io -n=chp05-set541 -o wide"
kubectl get ingress.networking.k8s.io -n=chp05-set541 -o wide

#echo "kubectl get ingress kubia -n=chp05-set541 -o wide"
#kubectl get ingress kubia -n=chp05-set541 -o wide

echo $HR

echo "INGRESS_IP=\$(kubectl get ingress.networking.k8s.io kubia -n=chp05-set541 -o jsonpath={'.status.loadBalancer.ingress[0].ip'})"
INGRESS_IP=$(kubectl get ingress.networking.k8s.io kubia -n=chp05-set541 -o jsonpath={'.status.loadBalancer.ingress[0].ip'})
echo "INGRESS_IP is $INGRESS_IP"
echo ""

enter


echo "sudo chmod a+wrx /etc/hosts"
#sudo chmod a+wrx /etc/hosts

echo "sudo echo $INGRESS_IP kubia.example.com >> /etc/hosts"
#sudo echo "$INGRESS_IP kubia.example.com" >> /etc/hosts

echo "sudo echo $INGRESS_IP foo.example.com >> /etc/hosts"
#sudo echo "$INGRESS_IP foo.example.com" >> /etc/hosts

echo "sudo echo $INGRESS_IP bar.example.com >> /etc/hosts"
#sudo echo "$INGRESS_IP bar.example.com" >> /etc/hosts

echo $HR

echo "cat /etc/hosts"
cat /etc/hosts


enter


echo "Access pods through the Ingress"
echo "curl http://kubia.example.com"
curl http://kubia.example.com
echo ""

echo "curl http://foo.example.com"
curl http://foo.example.com
echo ""

echo "curl http://bar.example.com"
curl http://bar.example.com

echo $HR

echo "kubectl describe ingress.networking.k8s.io -n=chp05-set541"
kubectl describe ingress.networking.k8s.io -n=chp05-set541


enter


echo "kubectl get all -n=ingress"
kubectl get all -n=ingress


echo $HR

echo "Access pods through the Ingress"
echo "curl http://kubia.example.com"
curl http://kubia.example.com
echo ""

echo "curl http://foo.example.com"
curl http://foo.example.com
echo ""

echo "curl http://bar.example.com"
curl http://bar.example.com


echo $HR

echo "kubectl delete -f $FULLPATH"
kubectl delete -f $FULLPATH

