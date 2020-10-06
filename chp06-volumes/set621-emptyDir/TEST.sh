#!/bin/bash
. ~/src/common/setup.sh
FULLPATH=$(pwd)
echo $HR_TOP

echo "kubectl apply -f $FULLPATH"
kubectl apply -f $FULLPATH
echo $HR

value=$(<set621-1-fortune-pod.yaml)
echo "$value"
enter

value=$(<set621-2-svc.yaml)
echo "$value"
enter

POD0=$(kubectl get pods -n=chp06-set621 -o jsonpath={'.items[0].metadata.name'})
echo "kubectl wait --for=condition=Ready=True pod/\$POD0 -n=chp06-set621 --timeout=60s"
kubectl wait --for=condition=Ready=True pod/$POD0 -n=chp06-set621 --timeout=60s
echo $HR

echo "kubectl get pods -n=chp06-set621 -o wide --show-labels"
kubectl get pods -n=chp06-set621 -o wide --show-labels
echo ""

echo "kubectl get svc -n=chp06-set621"
kubectl get svc -n=chp06-set621
echo ""

echo "kubectl get endpoints -n=chp06-set621"
kubectl get endpoints -n=chp06-set621

enter

echo "Check emptyDir mount point /var/htdocs in container html-generator."
echo "kubectl exec pod/fortune -c html-generator -n=chp06-set621 -- ls -l /var/htdocs"
kubectl exec pod/fortune -c html-generator -n=chp06-set621 -- ls -l /var/htdocs
echo ""
echo "kubectl exec pod/fortune -c html-generator -n=chp06-set621 -- cat /var/htdocs/index.html"
kubectl exec pod/fortune -c html-generator -n=chp06-set621 -- cat /var/htdocs/index.html

echo $HR 

echo "Check emptyDir mount point /usr/share/nginx/html in container web-server."
echo "kubectl exec pod/fortune -c web-server -n=chp06-set621 -- ls -l /usr/share/nginx/html"
kubectl exec pod/fortune -c web-server -n=chp06-set621 -- ls -l /usr/share/nginx/html
echo ""

echo "kubectl exec pod/fortune -c web-server -n=chp06-set621 -- cat /usr/share/nginx/html/index.html"
kubectl exec pod/fortune -c web-server -n=chp06-set621 -- cat /usr/share/nginx/html/index.html
echo $HR 

echo "IP_CLUSTER=\$(kubectl get svc fortune -n=chp06-set621 -o jsonpath='{.spec.clusterIP}')"
IP_CLUSTER=$(kubectl get svc fortune -n=chp06-set621 -o jsonpath="{.spec.clusterIP}")
echo ""

echo "curl http://$IP_CLUSTER"
curl http://$IP_CLUSTER

enter

echo "kubectl get events -n=chp06-set621"
kubectl get events -n=chp06-set621

echo $HR
echo "kubectl delete -f $FULLPATH"
kubectl delete -f $FULLPATH

