#!/bin/bash
. ~/src/common/setup.sh
FULLPATH=$(pwd)

echo "kubectl apply -f $FULLPATH"
kubectl apply -f $FULLPATH/set1030-0-ns.yaml
kubectl apply -f $FULLPATH/set1030-2-kubia-service-headless.yaml
kubectl apply -f $FULLPATH/set1030-3-kubia-statefulset.yaml --record
kubectl apply -f $FULLPATH/set1030-4-curl-pod.yaml --record
echo $HR_TOP
sleep 3

enter

value=$(<set1030-2-kubia-service-headless.yaml)
echo "$value"

enter

value=$(<set1030-3-kubia-statefulset.yaml)
echo "$value"

enter

echo "kubectl rollout status sts kubia -n=chp10-set1030 --timeout=30s"
kubectl rollout status sts kubia -n=chp10-set1030 --timeout=30s
echo $HR

echo "kubectl get all -n=chp10-set1030 --show-labels"
kubectl get all -n=chp10-set1030 --show-labels
echo $HR

echo "kubectl get storageclass --show-labels"
kubectl get storageclass --show-labels
echo $HR

echo "kubectl get persistentvolumeclaim -n=chp10-set1030 --show-labels"
kubectl get persistentvolumeclaim -n=chp10-set1030 --show-labels
echo $HR

enter

echo "kubectl get persistentvolume --show-labels"
kubectl get persistentvolume --show-labels
echo $HR

echo "kubectl get statefulset -n=chp10-set1030 -o wide --show-labels"
kubectl get statefulset -n=chp10-set1030 -o wide --show-labels
echo $HR

enter

echo "Check DNS information inside pods"
echo "/etc/resolv.conf is used by the resolver. It is also used to configure the DNS name servers."
echo ""
echo "kubectl exec -it kubia-0 -n=chp10-set1030 -- cat /etc/resolv.conf"
kubectl exec -it kubia-0 -n=chp10-set1030 -- cat /etc/resolv.conf
echo ""

echo "kubectl exec -it curl-pod -n=chp10-set1030 -- cat /etc/resolv.conf"
kubectl exec -it curl-pod -n=chp10-set1030 -- cat /etc/resolv.conf

echo $HR

echo "We cannnot communicate direct with the pods through the Service creates because it is a headless service."
echo "Instead, we need to connect to individual pods directly."
echo "Or, we could create a regular Service, but this wouldn't allow talking to a specific pod."
echo "We can connect to pods directly in different ways:"
echo "1. Using port-forwarding"
echo "2. Piggyback on another pod and running curl inside"
echo "3. Using the API server as a proxy to the pods"
echo ""
echo "Here, we use #2 and piggyback on another pod with curl built inside of it"
echo $HR


echo "Use the headless service via piggybacking pod with curl"
echo "kubectl exec -it curl-pod -n=chp10-set1030 -- sh -c 'curl http://kubia.chp10-set1030.svc.cluster.local:8080'"
kubectl exec -it curl-pod -n=chp10-set1030 -- sh -c 'curl http://kubia.chp10-set1030.svc.cluster.local:8080'

echo $HR

enter

echo "kubectl describe pod/kubia-0 -n=chp10-set1030"
kubectl describe pod/kubia-0 -n=chp10-set1030

enter

echo "kubectl describe statefulset kubia -n=chp10-set1030"
kubectl describe statefulset kubia -n=chp10-set1030

enter

echo "kubectl delete -f $FULLPATH"
kubectl delete -f $FULLPATH
