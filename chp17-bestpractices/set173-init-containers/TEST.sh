#!/bin/bash
. ~/src/common/setup.sh
FULLPATH=$(pwd)

cat <<- "NOTES"
Tests for Section 17.3 Best Practices
 
1. Init Containers
We use an init container to delay starting the pod's main container until a precondition is met.

NOTES

kubectl delete -f $FULLPATH --now --ignore-not-found

echo $HR

kubectl apply -f set173-0-ns.yaml
kubectl apply -f set173-1-pod-fortune-client.yaml 
echo ""

echo "Execute the pod's init containers sequentially"
echo "kubectl get pod -n=chp17-set173 -o wide"
kubectl get pod -n=chp17-set173 -o wide
echo ""

echo $HR

echo '
  initContainers:
  - name: init
    image: busybox
    command:
    - sh
    - -c
    - while true; do echo "Waiting for fortune service to come up..."; wget http://fortune -q -T 1 -O /dev/null >/dev/null 2>/dev/null && break; sleep 1; done; echo "Service is up! Starting main container."'




#echo "sleep 3"
#sleep 3
#echo ""

echo $HR

echo "kubectl logs fortune-client -n=chp17-set173 -c init"
kubectl logs fortune-client -n=chp17-set173 -c init
echo ""

echo $HR

echo "kubectl apply -f set173-2-service-fortune-server.yaml"
kubectl apply -f set173-2-service-fortune-server.yaml
echo ""
#kubectl -n=foo exec -it test -- curl localhost:8001/healthz
#echo ""

echo $HR

sleep 3
echo ""

echo "kubectl wait --for=condition=Ready=True pod fortune-server -n=chp17-set173 --timeout=11s"
kubectl wait --for=condition=Ready=True pod fortune-server -n=chp17-set173 --timeout=11s
echo ""

echo "Check again"
echo "kubectl get all -n=chp17-set173 -o wide"
kubectl get all -n=chp17-set173 -o wide
echo ""

echo sleep 3

echo $HR

echo "kubectl logs fortune-server -n=chp17-set173 -c web-server"
kubectl logs fortune-server -n=chp17-set173 -c web-server
echo ""

sleep 5

kubectl get pods -n=chp17-set173

echo $HR

echo "wget http://fortune -T 1"
wget http://fortune -T 1
echo $HR

echo "kubectl delete -f $FULLPATH"
kubectl delete -f $FULLPATH
