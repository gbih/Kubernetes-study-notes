#!/bin/bash
. ~/src/COMMON/SETUP.sh
FULLPATH=$(pwd)

echo $HR_TOP

echo "kubectl apply -f $FULLPATH"
kubectl apply -f $FULLPATH 

echo ""
echo "Although headless services may seem different from regular services, they aren't that different from the clients' perspective. Even with a headless service, clients can con- nect to its pods by connecting to the service's DNS name, as they can with regular services. But with headless services, because DNS returns the pods’ IPs, clients connect directly to the pods, instead of through the service proxy."
echo "NOTE: A headless services still provides load balancing across pods, but through the DNS round-robin mechanism instead of through the service proxy."

sleep 15

echo $HR

POD0=$(kubectl get pods -l app=kubia -n=chp05-set561 -o jsonpath='{.items[0].metadata.name}')
POD1=$(kubectl get pods -l app=kubia -n=chp05-set561 -o jsonpath='{.items[1].metadata.name}')
POD2=$(kubectl get pods -l app=kubia -n=chp05-set561 -o jsonpath='{.items[2].metadata.name}')


echo "kubectl wait --for=condition=Intialized=True pod/$POD0 -n=chp05-set561 --timeout=50s"
kubectl wait --for=condition=Initialized=True pod/$POD0 -n=chp05-set561 --timeout=50s
echo "kubectl wait --for=condition=Intialized=True pod/$POD1 -n=chp05-set561 --timeout=50s"
kubectl wait --for=condition=Initialized=True pod/$POD1 -n=chp05-set561 --timeout=50s
echo "kubectl wait --for=condition=Intialized=True pod/$POD2 -n=chp05-set561 --timeout=50s"
kubectl wait --for=condition=Initialized=True pod/$POD2 -n=chp05-set561 --timeout=50s
echo $HR


echo "Create dir /var/ready in $POD0 and $POD1" 
echo "kubectl exec $POD0 -n=chp05-set561 -- touch /var/ready"
echo "kubectl exec $POD1 -n=chp05-set561 -- touch /var/ready"
kubectl exec $POD0 -n=chp05-set561 -- touch /var/ready
kubectl exec $POD1 -n=chp05-set561 -- touch /var/ready
echo $HR

sleep 1


echo "kubectl wait --for=condition=Ready=True pod $POD0 -n=chp05-set561 --timeout=20s"
kubectl wait --for=condition=Ready=True pod $POD0 -n=chp05-set561 --timeout=20s

echo "kubectl wait --for=condition=Ready=True pod $POD1 -n=chp05-set561 --timeout=20s"
kubectl wait --for=condition=Ready=True pod $POD1 -n=chp05-set561 --timeout=20s
echo $HR

echo "kubectl get all -n=chp05-set561 -o wide"
kubectl get pods -n=chp05-set561 -o wide
echo ""

echo "kubectl get svc -n=chp05-set561"
kubectl get svc -n=chp05-set561 -o wide
echo ""

echo "kubectl get endpoints -n=chp05-set561"
kubectl get endpoints -n=chp05-set561 

echo $HR
echo $HR
echo $HR

echo "kubectl exec dnsutils  -n=chp05-set561 -- sh -c 'nslookup kubia-headless'"
kubectl exec dnsutils  -n=chp05-set561 -- sh -c 'nslookup kubia-headless'

echo $HR

echo "Discovering services through DNS."
echo "The pod runs a DNS server, which all other pods running in the cluster are automatically configured to use."
echo "Kubernetes does this by modifying each container's /etc/resolv.conf file."
echo ""

echo "kubectl exec -it $POD0 -n=chp05-set561 -- cat /etc/resolv.conf"
kubectl exec -it $POD0 -n=chp05-set561 -- cat /etc/resolv.conf
echo ""

echo "Each service gets a DNS entry in the internal DNS server."
echo "Client pods that know the service name can access its fully qualified domain name (FQDN) instead of the IP address."
echo ""


for i in {1..6}
do
  echo "kubectl exec -it $POD0 -n=chp05-set561 -- curl http://kubia-headless.chp05-set561.svc.cluster.local:8080"
  kubectl exec -it $POD0 -n=chp05-set561 -- curl http://kubia-headless.chp05-set561.svc.cluster.local:8080
  sleep 1
  echo ""
done


echo $HR



echo "kubectl delete -f $FULLPATH --now"
kubectl delete -f $FULLPATH --now --ignore-not-found
