#!/bin/bash
. ~/src/common/setup.sh
FULLPATH=$(pwd)
echo $HR_TOP

echo "kubectl apply -f $FULLPATH"
kubectl apply -f $FULLPATH
sleep 2

echo $HR

value=$(<set512-1-rs.yaml)
echo "$value"

enter

value=$(<set512-2-svc.yaml)
echo "$value"

enter

echo "POD0=\$(kubectl get pod -n=chp05-set512 -o jsonpath={'.items[0].metadata.name'})"
echo "POD1=\$(kubectl get pod -n=chp05-set512 -o jsonpath={'.items[1].metadata.name'})"
echo "POD2=\$(kubectl get pod -n=chp05-set512 -o jsonpath={'.items[2].metadata.name'})"

POD0=$(kubectl get pod -n=chp05-set512 -o jsonpath={'.items[0].metadata.name'})
POD1=$(kubectl get pod -n=chp05-set512 -o jsonpath={'.items[1].metadata.name'})
POD2=$(kubectl get pod -n=chp05-set512 -o jsonpath={'.items[2].metadata.name'})

echo "kubectl wait --for=condition=Ready=True pod/\$POD0 -n=chp05-set512 --timeout 20s"
echo "kubectl wait --for=condition=Ready=True pod/\$POD1 -n=chp05-set512 --timeout 20s"
echo "kubectl wait --for=condition=Ready=True pod/\$POD2 -n=chp05-set512 --timeout 20s"

kubectl wait --for=condition=Ready=True pod/$POD0 -n=chp05-set512 --timeout 20s
kubectl wait --for=condition=Ready=True pod/$POD1 -n=chp05-set512 --timeout 20s
kubectl wait --for=condition=Ready=True pod/$POD2 -n=chp05-set512 --timeout 20s

echo $HR

echo "kubectl get all -n=chp05-set512 --sort-by=..metadata.name --show-labels"
kubectl get all -n=chp05-set512 --sort-by=..metadata.name --show-labels -o wide
echo ""

echo "kubectl get endpoints -n=chp05-set512"
kubectl get endpoints -n=chp05-set512

echo $HR

echo "SERVICE_IP=\$(kubectl get svc -n=chp05-set512 -o jsonpath={'.items[0].spec.clusterIP'})"
SERVICE_IP=$(kubectl get svc -n=chp05-set512 -o jsonpath={'.items[0].spec.clusterIP'})

echo "curl $SERVICE_IP"
curl $SERVICE_IP

enter

echo "Discovering services through DNS."
echo "The pod runs a DNS server, which all other pods running in the cluster are automatically configured to use."
echo "Kubernetes does this by modifying each container's /etc/resolv.conf file."
echo ""

echo "kubectl exec -it $POD0 -n=chp05-set512 -- cat /etc/resolv.conf"
kubectl exec -it $POD0 -n=chp05-set512 -- cat /etc/resolv.conf
echo ""


echo "Each service gets a DNS entry in the internal DNS server."
echo "Client pods that know the service name can access its fully qualified domain name (FQDN) instead of the IP address."
echo ""

echo "kubectl exec -it $POD0 -n=chp05-set512 -- curl http://kubia.chp05-set512.svc.cluster.local"
kubectl exec -it $POD0 -n=chp05-set512 -- curl http://kubia.chp05-set512.svc.cluster.local
echo ""


echo "Shortcut (omitting .svc.cluster.local suffix)"
echo "kubectl exec -it $POD0 -n=chp05-set512 -- curl http://kubia.chp05-set512"
kubectl exec -it $POD0 -n=chp05-set512 -- curl http://kubia.chp05-set512

echo $HR

echo "kubectl logs $POD0 -n=chp05-set512"
kubectl logs -l app=kubia --all-containers -n=chp05-set512 

echo $HR

echo "kubectl delete -f $FULLPATH"
kubectl delete -f $FULLPATH
