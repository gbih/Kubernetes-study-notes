#!/bin/bash
. ~/src/common/setup.sh
FULLPATH=$(pwd)

cat <<- "NOTES"
Kubernetes Up and Running - Kelsey
page 234 Redis
Manually Replicated MongoDB with StatefulSets
Deploy a replicated MongoDB cluster
NOTES

echo $HR

kubectl apply -f $FULLPATH/set175-0-ns.yaml

kubectl create configmap -n=chp17-set175 \
--from-file=slave.conf=./slave.conf \
--from-file=master.conf=./master.conf \
--from-file=sentinel.conf=./sentinel.conf \
--from-file=init.sh=./init.sh \
--from-file=sentinel.sh=./sentinel.sh \
redis-config

kubectl apply -f $FULLPATH
echo $HR
sleep 4

#echo "kubectl rollout status sts redis -n=chp17-set175"
#kubectl rollout status sts redis -n=chp17-set175
#echo ""
enter

echo "kubectl get all -n=chp17-set175"
kubectl get all -n=chp17-set175

enter

echo "kubectl describe pod/redis-0 -n=chp17-set175"
kubectl describe pod/redis-0 -n=chp17-set175

enter

echo "kubectl rollout status deployment redis -n=chp17-set175"
kubectl rollout status deployment redis -n=chp17-set175
echo ""

echo "kubectl get pods -n=chp17-set175"
kubectl get pods -n=chp17-set175
echo ""

echo "kubectl describe pods -n=chp17-set175"
kubectl describe pods -n=chp17-set175
echo ""

echo $HR

echo "kubectl delete -f $FULLPATH"
kubectl delete -f $FULLPATH

