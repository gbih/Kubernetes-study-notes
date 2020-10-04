#!/bin/bash
clear
HR=$(printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' =)
echo $HR
FULLPATH=$HOME/src/chp11-internals/set111

echo "Tests for Section 11.1 Understanding Kubernetes internals"

echo $HR
echo "1. Check kubectl version"
echo "kubectl version --short"
kubectl version --short

echo $HR

echo "2. Check Control Plane components"
echo "kubectl get cs"
#kubectl get componentstatuses
kubectl get cs

echo $HR

echo "3. Kubernetes components running as pods"
echo "kubectl get pods -o custom-columns=POD:metadata.name,NODE:spec.nodeName --sort-by spec.nodeName -n=kube-system"
kubectl get pods -o custom-columns=POD:metadata.name,NODE:spec.nodeName --sort-by spec.nodeName -n=kube-system

echo $HR

echo "4. Using etcdctl, the command line client for etcd. It can be used in scripts or for administrators to explore an etcd cluster"

echo "GB: NOT WORKING"
# for version 3.2.10, sudo snap install etcd
# https://github.com/etcd-io/etcd/tree/master/etcdctl

etcdctl get /registry --prefix=true




#echo "kubectl rollout status sts kubia -n=chp11-set111"
#kubectl rollout status sts kubia -n=chp11-set111
#echo ""
#
#
#POD_0=$(kubectl get pod -n=chp11-set111 -o jsonpath={'.items[0].metadata.name'})
##
#echo "kubectl wait --for=condition=Ready=True pod/$POD_0 -n=chp11-set111 --timeout=21s"
#kubectl wait --for=condition=Ready=True pod/$POD_0 -n=chp11-set111 --timeout=21s
#echo ""
#
#
#
#STATUS=$(kubectl get pods $POD0 -n=chp11-set111  -o 'jsonpath={..status.conditions[*].status}')while [[ $(kubectl get pods $POD0 -n=chp11-set111 -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}') != "True" ]]; do echo "waiting for pod: $STATUS" && sleep 1; done
#echo ""


#echo "kubectl get pods -n=chp11-set111"
#kubectl get pods -n=chp11-set111
#echo ""
#
##kubectl get pod kubia-0 -o yaml -n=chp11-set111
##echo ""
#
#
#echo "kubectl get pvc -n=chp11-set111"
#kubectl get pvc -n=chp11-set111
#echo ""


#echo $HR
#
#echo "2. Communicating with the API Server via 'kubectl proxy'"
#echo ""
#
#echo "kubectl proxy"
#kubectl proxy &
#echo ""
#
#echo "sleep 5"
#sleep 5
#echo ""
#
#echo "curl localhost:8001/api/v1/namespaces/chp11-set111/pods/kubia-0/proxy/"
#curl localhost:8001/api/v1/namespaces/chp11-set111/pods/kubia-0/proxy/
#echo ""
#
#
#echo 'curl -X POST -d "Hey there! This greeting was submitted to kubia-0" localhost:8001/api/v1/namespaces/chp11-set111/pods/kubia-0/proxy/'
#curl -X POST -d "Hey there! This greeting was submitted to kubia-0" localhost:8001/api/v1/namespaces/chp11-set111/pods/kubia-0/proxy/
#echo ""
#
#
#echo "curl localhost:8001/api/v1/namespaces/chp11-set111/pods/kubia-0/proxy/"
#curl localhost:8001/api/v1/namespaces/chp11-set111/pods/kubia-0/proxy/
#echo ""
#
#echo "kubectl get pvc -n=chp11-set111"
#kubectl get pvc -n=chp11-set111
#echo ""
#
#echo $HR
#
#echo "2. Deleting a Stateful Pod to see if the rescheduled pod is reattached to the same storage"
#echo ""
#
#echo "kubectl delete pod kubia-0 -n=chp11-set111 --now"
#kubectl delete pod kubia-0 -n=chp11-set111 --now
#echo ""
#
#
#echo "kubectl wait --for=condition=Ready=False pod/$POD_0 -n=chp11-set111 --timeout=21s"
#kubectl wait --for=condition=Ready=False pod/$POD_0 -n=chp11-set111 --timeout=21s
#echo ""
#
#echo "kubecl get pods -n=chp11-set111"
#kubectl get pods -n=chp11-set111
#echo ""
#
#echo "kubectl wait --for=condition=Ready=True pod/$POD_0 -n=chp11-set111 --timeout=21s"
#kubectl wait --for=condition=Ready=True pod/$POD_0 -n=chp11-set111 --timeout=21s
#echo ""
#
#echo "kubecl get pods -n=chp11-set111"
#kubectl get pods -n=chp11-set111
#echo ""
#
#
#echo "curl localhost:8001/api/v1/namespaces/chp11-set111/pods/kubia-0/proxy/"
#curl localhost:8001/api/v1/namespaces/chp11-set111/pods/kubia-0/proxy/
#echo ""
#
#
#echo "kubectl get pvc -n=chp11-set111"
#kubectl get pvc -n=chp11-set111
#echo ""
#
#echo $HR
#
#echo "3. Scaling the StatefulSet"
#echo ""
#
#echo "kubectl apply -f set1031-5-kubia-statefulset-replicas4.yaml --record"
#kubectl apply -f set1031-5-kubia-statefulset-replicas4.yaml --record
#echo ""
#
#
#sleep 5

# not working
#echo "kubectl rollout status sts kubia -n=chp11-set111"
#kubectl rollout status sts kubia -n=chp11-set111
#echo ""

#echo "kubectl wait --for=condition=Ready=True pod/kubia-3 -n=chp11-set111 --timeout=21s"
#kubectl wait --for=condition=Ready=True pod/kubia-3 -n=chp11-set111 --timeout=21s
#echo ""
#echo "sleep 10"
#sleep 10 
#echo ""

#echo "kubectl get pods -n=chp11-set111"
#kubectl get pods -n=chp11-set111
#echo ""
#
#echo "curl localhost:8001/api/v1/namespaces/chp11-set111/pods/kubia-0/proxy/"
#curl localhost:8001/api/v1/namespaces/chp11-set111/pods/kubia-0/proxy/
#echo ""
#
#
#echo "kubectl get pvc -n=chp11-set111"
#kubectl get pvc -n=chp11-set111
#echo ""
#
#
#echo $HR
#
#echo "4. Connecting to Cluster-internal services through the API Server"
#echo ""
#
#
#echo "curl localhost:8001/api/v1/namespaces/chp11-set111/services/kubia-public/proxy/"
#curl localhost:8001/api/v1/namespaces/chp11-set111/services/kubia-public/proxy/
#echo ""
#
#echo $HR
#
#echo "5. Listing DNS SRV records of the headless Service"
#
#echo "kubectl run -it srvlookup --image=tutum/dnsutils --rm --restart=Never -- dig SRV kubia.chp11-set111.svc.cluster.local"
#kubectl run -it srvlookup --image=tutum/dnsutils --rm --restart=Never -- dig SRV kubia.chp11-set111.svc.cluster.local
#echo ""
#
#
#echo $HR
#
#echo "6. Updating a StatefulSet"
#echo ""
#
#
#echo "Need to build a container with the namespace chp11-set111 hardcoded in"
#
## docker build -t georgebaptista/kubia-pet-peers .
## docker login --username georgebaptista --password CUisdfsdjfkd8937473Uhdjfjjfdfod09
## docker login --username georgebaptista --password <pwd>
## docker push georgebaptista/kubia-pet-peers
#echo ""
#
#echo "kubectl apply -f set1031-6-kubia-statefulset-image-pet-peers.yaml"
#kubectl apply -f set1031-6-kubia-statefulset-image-pet-peers.yaml
#echo ""
#
#
## NOT WORKING!
##echo "kubectl rollout status sts kubia -n=chp11-set111"
##kubectl rollout status sts kubia -n=chp11-set111
##echo ""
#
#echo "sleep 5"
#sleep 5
#echo ""
#
#echo "kubectl get pods -n=chp11-set111"
#kubectl get pods -n=chp11-set111
#echo ""
#
#kubectl delete pods kubia-0 kubia-1 -n=chp11-set111
#echo ""
#
##sleep 11
#
#echo $HR
#
#echo "7. Trying out the clustered data store"
#echo ""
#
#echo "kubectl wait --for=condition=Ready=True pod/kubia-0 -n=chp11-set111 --timeout=31s"
#kubectl wait --for=condition=Ready=True pod/kubia-0 -n=chp11-set111 --timeout=31s
#echo ""
#
#echo "sleep 3"
#sleep 3
#echo ""
#
#echo 'curl -X POST -d "The sun is shining" localhost:8001/api/v1/namespaces/chp11-set111/services/kubia-public/proxy/'
#curl -X POST -d "The sun is shining" localhost:8001/api/v1/namespaces/chp11-set111/services/kubia-public/proxy/
#echo ""
#
#
#echo 'curl -X POST -d "The weather is sweet" localhost:8001/api/v1/namespaces/chp11-set111/services/kubia-public/proxy/'
#curl -X POST -d "The weather is sweet" localhost:8001/api/v1/namespaces/chp11-set111/services/kubia-public/proxy/
#echo ""
#
#echo "sleep 2"
#sleep 2
#echo ""
#
#echo 'curl localhost:8001/api/v1/namespaces/chp11-set111/services/kubia-public/proxy/'
#curl localhost:8001/api/v1/namespaces/chp11-set111/services/kubia-public/proxy/
#echo ""

#SVC_IP=$(kubectl get svc/kubia -n=chp11-set111 -o jsonpath={'.status.loadBalancer.ingress[0].ip'})
#
#
#echo "curl $SVC_IP"
#counter=1
#while [ $counter -le 5 ]
#do
#  curl http://$SVC_IP 
#  sleep 0.5
#  ((counter++))
#done
#echo ""
#
#
#
#echo "kubectl rollout status deployment kubia -n=chp11-set111"
#kubectl rollout status deployment kubia -n=chp11-set111
#echo ""


#echo "kubectl patch deployment kubia -p '{\"spec\": {\"minReadySeconds\": 3}}' -n=chp11-set111"
#kubectl patch deployment kubia -p '{"spec": {"minReadySeconds": 3}}' -n=chp11-set111
#echo ""

# Imperative style
#echo "kubectl set image deployment kubia nodejs=luksa/kubia:v2 -n=chp11-set111"
#kubectl set image deployment kubia nodejs=luksa/kubia:v2 -n=chp11-set111
#echo ""

#echo "======================================================"
#echo ""
#
## Declarative style
#echo "kubectl apply -f $FULLPATH/set1031-2-kubia-deployment-v3-with-readinesscheck.yaml --record"
#kubectl apply -f $FULLPATH/set1031-2-kubia-deployment-v3-with-readinesscheck.yaml --record
#echo ""
#
#
#
#echo "curl $SVC_IP"
#counter=1
#while [ $counter -le 5 ]
#do
#  curl http://$SVC_IP 
#  sleep 0.5
#  ((counter++))
#done
#echo ""
#
#
#
#echo "kubectl get rs -n=chp11-set111 -o wide"
#kubectl get rs -n=chp11-set111 -o wide
#echo ""
#
#echo "kubectl get pods -n=chp11-set111 --show-labels"
#kubectl get pods -n=chp11-set111 --show-labels
#echo ""

#echo "sleep 1"
#sleep 1
#echo ""



#echo "kubectl rollout status deployment kubia --timeout=11s -n=chp11-set111"
#kubectl rollout status deployment kubia --timeout=11s -n=chp11-set111
#echo ""



#echo "kubectl describe deployment kubia -n=chp11-set111"
#kubectl describe deployment kubia -n=chp11-set111
#echo ""

#echo "curl $SVC_IP"
#counter=1
#while [ $counter -le 20 ]
#do
#  curl http://$SVC_IP 
#  sleep 0.5
#  ((counter++))
#done
#echo ""



#echo "kubectl rollout undo deployment kubia --to-revision=1 -n=chp11-set111"
#kubectl rollout undo deployment kubia --to-revision=1 -n=chp11-set111
#echo ""


#echo "kubectl rollout history deployment kubia -n=chp11-set111"
#kubectl rollout history deployment kubia -n=chp11-set111
#echo ""



#echo "kubectl get svc -n=chp11-set111 -o wide"
#kubectl get svc -n=chp11-set111 -o wide
#echo ""




#echo "kubectl get events -n=chp11-set111 --sort-by .lastTimestamp"
#kubectl get events -n=chp11-set111 --sort-by=.metadata.creationTimestamp
#echo ""
#
#
#
#echo "Abort bad rollout"
#echo "kubectl rollout undo deployment kubia -n=chp11-set111"
#kubectl rollout undo deployment kubia -n=chp11-set111
#echo ""



#echo "In a separate terminal window, type this to see the rolling-update change:"
#echo ""
#echo "while true; do curl $SVC_IP; done"
#echo ""
#
#echo "chp11-set111: --update-period=1m0s, --poll-interval=3s, --timeout=5m0s"
#echo ""
#
#echo "kubectl rolling-update --update-period=2s --poll-interval=1s kubia-v1 kubia-v2 --image=luksa/kubia:v2 -n=chp11-set111"
#kubectl rolling-update --update-period=4s --poll-interval=1s kubia-v1 kubia-v2 --image=luksa/kubia:v2 -n=chp11-set111
## kubectl rolling-update kubia-v1 kubia-v2 --image=luksa/kubia:v2 -n=chp11-set111 --v 6
#echo ""
#
#
#echo "kubectl get rc -n=chp11-set111 -o wide"
#kubectl get rc -n=chp11-set111 -o wide
#echo ""
#
#
#echo "kubectl get pods -n=chp11-set111 --show-labels"
#kubectl get pods -n=chp11-set111 --show-labels
#echo ""

#kubectl delete -f $FULLPATH --force --grace-period=0


#kubectl delete -f $FULLPATH/set1031-0-ns.yaml --force --grace-period=0
#kubectl delete -f $FULLPATH/set1031-1-kubia-deployment-v1.yaml --force --grace-period=0
#kubectl delete -f $FULLPATH/set1031-2-service.yaml --force --grace-period=0

#kubectl delete -f $FULLPATH/set1031-0-ns.yaml --force --grace-period=0

#echo $HR
#
#echo "8. Deleting namespace"
#echo ""
##
#echo "Remove port forward process"
#echo "killall kubectl"
#killall kubectl
#echo ""
##
#echo "kubectl delete -f $FULLPATH -now"
#kubectl delete -f $FULLPATH --now



if [ "$DELETE" == "d" ]
then
  echo ""
  kubectl delete -f $FULLPATH --grace-period=0 --force
  echo ""
fi

echo $HR
