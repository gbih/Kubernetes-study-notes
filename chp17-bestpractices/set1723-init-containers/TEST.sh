#!/bin/bash
. ~/src/common/setup.sh
FULLPATH=$(pwd)
echo "17.2.3 Starting pods in a specific order"
echo $HR_TOP

echo "kubectl apply -f $FULLPATH"
kubectl apply -f set1723-0-ns.yaml
kubectl apply -f psp.yaml
kubectl apply -f sa.yaml
kubectl apply -f role-rolebinding.yaml
kubectl apply -f set1723-1-pod-fortune-client.yaml 
echo $HR

echo "kubectl wait --for=condition=Ready=True pods/fortune-client -n=chp17-set1723 --timeout=20s"
kubectl wait --for=condition=Ready=True pods/fortune-client -n=chp17-set1723 --timeout=20s
echo ""


echo "Execute the pod's init containers sequentially"
echo ""
echo "kubectl get pod -n=chp17-set1723 -o wide"
kubectl get pod -n=chp17-set1723 -o wide
echo ""

enter

value=$(<set1723-1-pod-fortune-client.yaml)
echo "$value"

enter

echo "Test whether init-container has finished"
echo ""
echo "kubectl exec -it -c main fortune-client -n chp17-set1723 -- wget -q -O - http://fortune"
kubectl exec -it -c main fortune-client -n chp17-set1723 -- wget -q -O - http://fortune

enter

echo "kubectl logs fortune-client -n=chp17-set1723 -c init"
kubectl logs fortune-client -n=chp17-set1723 -c init
echo ""

echo $HR

echo "kubectl apply -f set1723-2-service-fortune-server.yaml"
kubectl apply -f set1723-2-service-fortune-server.yaml

enter

echo "kubectl wait --for=condition=Ready=True pod fortune-server -n=chp17-set1723 --timeout=11s"
kubectl wait --for=condition=Ready=True pod fortune-server -n=chp17-set1723 --timeout=11s
echo $HR

echo "Check again"
echo "kubectl get all -n=chp17-set1723 -o wide"
kubectl get all -n=chp17-set1723 -o wide
sleep 2

echo $HR

echo "kubectl logs fortune-server -n=chp17-set1723 -c web-server"
kubectl logs fortune-server -n=chp17-set1723 -c web-server

enter

echo "kubectl get pods -n=chp17-set1723"
kubectl get pods -n=chp17-set1723

echo $HR

echo "kubectl exec -it -c main fortune-client -n chp17-set1723 -- wget -q -O - http://fortune"
kubectl exec -it -c main fortune-client -n chp17-set1723 -- wget -q -O - http://fortune

enter

echo "kubectl delete -f $FULLPATH"
kubectl delete -f $FULLPATH
