#!/bin/bash
. ~/src/common/setup.sh
FULLPATH=$(pwd)
echo "13.1.2 Binding to a host port without using the host’s network namespace"
echo $HR_TOP

echo "kubectl apply -f $FULLPATH"
kubectl apply -f $FULLPATH --record
echo ""
echo "kubectl wait --for=condition=Ready ..."
kubectl wait --for=condition=Ready pod/kubia-hostport -n=chp13-set1312

enter

#echo "Check environment"
#echo ""

#echo "cat /var/snap/microk8s/current/args/kube-apiserver"
#echo ""
#cat /var/snap/microk8s/current/args/kube-apiserver
#echo "" 
#echo "See more options here: https://kubernetes.io/docs/reference/command-line-tools-reference/kube-apiserver/"

#enter



((i++))
echo "$i. Check pod and node"
echo ""
echo "kubectl get pods -n=chp13-set1312 -o wide"
kubectl get pods -n=chp13-set1312 -o wide --sort-by=.status.podIP
echo ""
echo "kubectl get node -o wide"
kubectl get node -o wide
echo ""
echo "kubectl get psp -o wide"
kubectl get psp -o wide
enter


((i++))
echo "$i. Check availability of pod via curl"
echo "We can access this pod through port 9000 of the node it's scheduled to."
echo "If there are multiple nodes, we cannot access the pod through that port on the other nodes."
echo ""

echo "curl actionbook-vm:9000"
curl actionbook-vm:9000
echo $HR

echo "We can access the container on port 8080 of the pod's IP"
echo "POD_IP=\$(kubectl get pod kubia-hostport -n=chp13-set1312 -o jsonpath={'.status.podIP'})"
POD_IP=$(kubectl get pod kubia-hostport -n=chp13-set1312 -o jsonpath={'.status.podIP'})
echo "curl $POD_IP:8080"
curl $POD_IP:8080

enter


((i++))
echo "$i. Check details of pod kubia-hostport"
echo ""
echo "kubectl describe pod/kubia-hostport -n=chp13-set1312"
kubectl describe pod/kubia-hostport -n=chp13-set1312

#enter
echo $HR

((i++))
echo "$i. Clean-up"
echo ""
echo "kubectl delete -f $FULLPATH --now"
kubectl delete -f $FULLPATH --now

