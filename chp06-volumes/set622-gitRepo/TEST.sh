#!/bin/bash
. ~/src/COMMON/SETUP.sh
FULLPATH=$(pwd)

echo $HR_TOP

echo "kubectl apply -f $FULLPATH"
kubectl apply -f $FULLPATH
enter

value=$(<set622-1-gitrepo-init.yaml)
echo "$value"
enter

value=$(<set622-2-svc.yaml)
echo "$value"
enter



POD0=$(kubectl get pods -n=chp06-set622 -o jsonpath={'.items[0].metadata.name'})
echo "kubectl wait --for=condition=Ready=True pod/$POD0 -n=chp06-set622 --timeout=60s"
kubectl wait --for=condition=Ready=True pod/$POD0 -n=chp06-set622 --timeout=60s
echo $HR

echo "kubectl get pods -n=chp06-set622 -o wide"
kubectl get pods -n=chp06-set622 -o wide
echo ""

echo "kubectl get svc -n=chp06-set622 -o wide"
kubectl get svc -n=chp06-set622 -o wide

enter

echo "kubectl exec pod/gitrepo-volume-demo -c web-server -n=chp06-set622 -- ls -l /usr/share/nginx/html"
kubectl exec pod/gitrepo-volume-demo -c web-server -n=chp06-set622 -- ls -l /usr/share/nginx/html
echo ""

IP_CLUSTER=$(kubectl get service/gitrepo-volume-demo -n=chp06-set622 -o jsonpath="{.spec.clusterIP}")

echo "curl http://$IP_CLUSTER"
curl http://$IP_CLUSTER
echo ""
echo $HR

echo "kubectl get events -n=chp06-set622 --sort-by=.metadata.creationTimestamp"
kubectl get events -n=chp06-set622 --sort-by=.metadata.creationTimestamp

echo $HR

echo "kubectl delete -f $FULLPATH"
kubectl delete -f $FULLPATH
