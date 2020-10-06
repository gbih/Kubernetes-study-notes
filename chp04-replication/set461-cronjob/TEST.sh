#!/bin/bash
. ~/src/COMMON/SETUP.sh
FULLPATH=$(pwd)
echo $HR_TOP

echo "kubectl apply -f $FULLPATH"
kubectl apply -f $FULLPATH

echo $HR

echo "The smallest time increment of Kubenetes CronJobs is a minute".
echo "This is a limitation of Linux cron job functionality."
echo "Here, we wait 63 seconds in order to see the Kubernetes objects created."
echo ""
echo "sleep 63"
sleep 63 

echo $HR

echo "kubectl get jobs -n=chp04-set461"
kubectl get jobs -n=chp04-set461

echo $HR

echo "kubectl get pods -n=chp04-set461"
kubectl get pods -n=chp04-set461

echo $HR

echo "kubectl get cronjobs -n=chp04-set461"
kubectl get cronjobs -n=chp04-set461

echo $HR

echo "kubectl get events -n=chp04-set461"
kubectl get events -n=chp04-set461

echo $HR

echo "kubectl delete -f $FULLPATH"
kubectl delete -f $FULLPATH

