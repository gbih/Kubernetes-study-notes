#!/bin/bash
. ~/src/SETUP.sh
FULLPATH=$(pwd)

kubectl delete pv -l name=chp10-set1030 --ignore-not-found --now
kubectl delete -f $FULLPATH --now --ignore-not-found
echo $HR

echo "kubectl apply -f $FULLPATH"
kubectl apply -f $FULLPATH/set1030-0-ns.yaml
kubectl apply -f $FULLPATH/set1030-2-kubia-service-headless.yaml
kubectl apply -f $FULLPATH/set1030-3-kubia-statefulset.yaml --record
kubectl apply -f $FULLPATH/set1030-4-curl-pod.yaml --record
echo $HR_TOP
enter

value=$(<set1030-3-kubia-statefulset.yaml)
echo "$value"

enter

echo "kubectl rollout status sts kubia -n=chp10-set1030 --timeout=30s"
kubectl rollout status sts kubia -n=chp10-set1030 --timeout=30s
echo $HR

echo "kubectl get pods -n=chp10-set1030 -o wide"
kubectl get pods -n=chp10-set1030 -o wide
echo $HR

echo "kubectl get storageclass"
kubectl get storageclass
echo $HR

echo "kubectl get pvc -n=chp10-set1030"
kubectl get pvc -n=chp10-set1030
echo $HR

echo "kubectl get pv"
kubectl get pv
echo $HR

echo "kubectl get service -n=chp10-set1030 -o wide"
kubectl get service -n=chp10-set1030 -o wide
echo $HR

echo "kubectl get statefulset -n=chp10-set1030 -o wide --show-labels"
kubectl get statefulset -n=chp10-set1030 -o wide --show-labels
echo $HR

enter

echo "We cannnot communicate direct with the pods through the Service creates because it is a headless service."
echo "Instead, we need to connect to individual pods directly."
echo "Or, we could create a regular Service, but this wouldn't allow talking to a specific pod."
echo "We can connect to pods directly in different ways:"
echo "1. Using port-forwarding"
echo "2. Piggyback on another pod and running curl inside"
echo "3. Using the API server as a proxy to the pods"
echo ""

echo $HR

echo "kubectl exec -it kubia-0 -n=chp10-set1030 -- cat /etc/resolv.conf"
kubectl exec -it kubia-0 -n=chp10-set1030 -- cat /etc/resolv.conf
echo ""

echo "kubectl exec -it curl-pod -n=chp10-set1030 -- cat /etc/resolv.conf"
kubectl exec -it curl-pod -n=chp10-set1030 -- cat /etc/resolv.conf
echo ""


echo "Use the headless service:"
echo "kubectl exec -it curl-pod -n=chp10-set1030 -- sh -c 'curl http://kubia.chp10-set1030.svc.cluster.local:8080'"
kubectl exec -it curl-pod -n=chp10-set1030 -- sh -c 'curl http://kubia.chp10-set1030.svc.cluster.local:8080'



echo $HR

echo "Method 2"
echo "Piggyback on another pod and running curl inside:"
echo ""
echo 'HEADLESSPOD1=$(kubectl get pod/kubia-0 -n=chp10-set1030 -o jsonpath={'.status.podIP'})'
HEADLESSPOD1=$(kubectl get pod/kubia-0 -n=chp10-set1030 -o jsonpath={'.status.podIP'})
echo 'kubectl -n=chp10-set1030 -it exec curl-pod -- sh -c "curl $HEADLESSPOD1:8080"'
kubectl -n=chp10-set1030 -it exec curl-pod -- sh -c "curl $HEADLESSPOD1:8080"

echo $HR


#echo "kubectl get pod/kubia-0 -o yaml -n=chp10-set1030"
#kubectl get pod/kubia-0 -o yaml -n=chp10-set1030

#echo "kubectl get statefulset kubia -n=chp10-set1030 -o yaml"
#kubectl get statefulset kubia -n=chp10-set1030 -o yaml
#
#enter

#enter
echo "kubectl delete -f $FULLPATH"
kubectl delete -f $FULLPATH
kubectl delete pv -l name=chp10-set1030
