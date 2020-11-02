#!/bin/bash
. ~/src/common/setup.sh
FULLPATH=$(pwd)
echo "8.1.2 Exposing metadata through environment variables"
echo $HR_TOP


echo "kubectl apply -f $FULLPATH"
kubectl apply -f $FULLPATH
sleep 1

echo $HR

echo "kubectl wait --for=condition=Ready=True pod/downward -n=chp08-set812 --timeout=20s"
kubectl wait --for=condition=Ready=True pod/downward -n=chp08-set812 --timeout=20s
echo $HR

echo "kubectl -n=chp08-set812 exec downward -- env"
kubectl -n=chp08-set812 exec downward -- env
echo $HR

echo "kubectl delete -f $FULLPATH"
kubectl delete -f $FULLPATH

