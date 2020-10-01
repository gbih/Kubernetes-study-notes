#!/bin/bash
. ../../SETUP.sh
FULLPATH=$(pwd)
echo $HR_TOP

echo "kubectl apply -f $FULLPATH"
kubectl apply -f $FULLPATH
sleep 1

echo $HR

echo "kubectl wait --for=condition=Ready=True pod/curl-with-ambassador -n=chp08-set823 --timeout=20s"
kubectl wait --for=condition=Ready=True pod/curl-with-ambassador -n=chp08-set823 --timeout=20s
echo $HR

#echo "kubectl get events -n=chp08-set823"
#kubectl get events -n=chp08-set823
#echo $HR

enter
kubectl describe pods/curl-with-ambassador -n=chp08-set823
enter

echo "These access commands are essentially the same."
echo ""
echo "1. The main container passes this request to the ambassador container by accessing port 8001"
echo "kubectl -n=chp08-set823 exec curl-with-ambassador -c main -- curl localhost:8001"
echo ""
echo "2. Use curl directly on the ambassador container on port 8001"
echo "kubectl -n=chp08-set823 exec curl-with-ambassador -c ambassador -- curl http://localhost:8001"

enter

echo "kubectl -n=chp08-set823 exec curl-with-ambassador -c main -- curl localhost:8001"
kubectl -n=chp08-set823 exec curl-with-ambassador -c main -- curl localhost:8001

enter

echo "kubectl -n=chp08-set823 exec curl-with-ambassador -c ambassador -- curl http://localhost:8001"
kubectl -n=chp08-set823 exec curl-with-ambassador -c ambassador -- curl http://localhost:8001

enter

echo "kubectl delete -f $FULLPATH"
kubectl delete -f $FULLPATH
