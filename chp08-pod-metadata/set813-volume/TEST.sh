#!/bin/bash
. ~/src/common/setup.sh
FULLPATH=$(pwd)
echo $HR_TOP

echo "kubectl apply -f $FULLPATH"
kubectl apply -f $FULLPATH
sleep 1

echo "kubectl wait --for=condition=Ready=True pod/downward -n=chp08-set813 --timeout=30s"
kubectl wait --for=condition=Ready=True pod/downward -n=chp08-set813 --timeout=30s

echo $HR

# use for downwardAPI volume
echo "kubectl -n=chp08-set813 exec pod/downward -- ls -la /etc/downward"
kubectl -n=chp08-set813 exec pod/downward -- ls -la /etc/downward

echo $HR
enter
echo "kubectl -n=chp08-set813 exec downward -- cat /etc/downward/annotations"
kubectl -n=chp08-set813 exec downward -- cat /etc/downward/annotations
echo ""
echo ""

echo "kubectl -n=chp08-set813 exec downward -- cat /etc/downward/containerCpuRequestMilliCores"
kubectl -n=chp08-set813 exec downward -- cat /etc/downward/containerCpuRequestMilliCores
echo ""
echo ""

echo "kubectl -n=chp08-set813 exec downward -- cat /etc/downward/containerMemoryLimitBytes"
kubectl -n=chp08-set813 exec downward -- cat /etc/downward/containerMemoryLimitBytes
echo ""
echo ""

echo "kubectl -n=chp08-set813 exec downward -- cat /etc/downward/labels"
kubectl -n=chp08-set813 exec downward -- cat /etc/downward/labels
echo ""
echo ""

echo "kubectl -n=chp08-set813 exec downward -- cat /etc/downward/podName"
kubectl -n=chp08-set813 exec downward -- cat /etc/downward/podName
echo ""
echo ""

echo "kubectl -n=chp08-set813 exec downward -- cat /etc/downward/podNamespace"
kubectl -n=chp08-set813 exec downward -- cat /etc/downward/podNamespace
echo ""

echo $HR

echo "kubectl delete -f $FULLPATH"
kubectl delete -f $FULLPATH
