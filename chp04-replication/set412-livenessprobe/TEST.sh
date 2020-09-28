#!/bin/bash
. ~/src/SETUP.sh
FULLPATH=$(pwd)

echo $HR_TOP

echo "kubectl apply -f $FULLPATH/set412-0-ns.yaml"
kubectl apply -f $FULLPATH/set412-0-ns.yaml
echo $HR
sleep 1

echo "kubectl apply -f $FULLPATH"
kubectl apply -f $FULLPATH
sleep 1

echo $HR

echo "kubectl wait --for=condition=Ready=True pod/kubia-liveness -n=chp04-set412 --timeout=20s"
kubectl wait --for=condition=Ready=True pod/kubia-liveness -n=chp04-set412 --timeout=20s

echo $HR

echo "kubectl get pod/kubia-liveness -n=chp04-set412"
kubectl get pod/kubia-liveness -n=chp04-set412

echo $HR

echo "kubectl logs --follow --timestamps --pod-running-timeout=5s pod/kubia-liveness -n=chp04-set412"
kubectl logs --follow --timestamps --pod-running-timeout=5s pod/kubia-liveness -n=chp04-set412
echo ""

echo $HR

echo "kubectl -n=chp04-set412 get pod/kubia-liveness -o go-template='{{range.status.containerStatuses}}{{\"Container Name: \"}}{{.name}}{{\"\r\nLastState: \"}}{{.lastState}}{{end}}'"
echo ""
kubectl -n=chp04-set412 get pod/kubia-liveness -o go-template='{{range.status.containerStatuses}}{{"Container Name: "}}{{.name}}{{"\r\nLastState: "}}{{.lastState}}{{end}}'
echo ""

echo $HR

echo "kubectl -n=chp04-set412 get pod/kubia-liveness -o=custom-columns=LAST_STATE:status.containerStatuses[0].lastState"
echo ""
kubectl -n=chp04-set412 get pod/kubia-liveness -o=custom-columns=LAST_STATE:status.containerStatuses[0].lastState
echo ""
echo $HR


#echo "kubectl get all -n=chp04-set412"
#kubectl get all -n=chp04-set412
#echo $HR

echo "kubectl describe pod/kubia-liveness -n=chp04-set412"
kubectl describe pod/kubia-liveness -n=chp04-set412
echo $HR

echo "kubectl get pod/kubia-liveness -o wide -n=chp04-set412"
kubectl get pod/kubia-liveness -o wide -n=chp04-set412
echo $HR

echo "kubectl delete $FULLPATH"
kubectl delete -f $FULLPATH
