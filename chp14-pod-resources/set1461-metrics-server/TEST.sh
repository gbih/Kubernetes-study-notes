#!/bin/bash
. ~/src/common/setup.sh
FULLPATH=$(pwd)
echo "14.6.1 Collecting and retrieving actual resource usages"
echo $HR_TOP


echo "Actual CPU and memory usage of nodes"
echo "kubectl top node"
kubectl top node

echo $HR

echo "Show metrics for all pods across all namespaces"
echo "kubectl top pod -A"
kubectl top pod -A

echo $HR

echo "Show metrics for a given pod and its containers"
echo "kubectl top pods --containers -A"
kubectl top pods --containers -A

echo $HR

