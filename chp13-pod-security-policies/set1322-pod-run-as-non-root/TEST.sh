#!/bin/bash
. ~/src/common/setup.sh
FULLPATH=$(pwd)
echo "Preventing a container from running as root"
echo $HR_TOP

((i++))

echo "$i. Source files"
echo ""
echo "set1322-1-pod-run-as-non-root.yaml"
echo ""
value=$(<set1322-1-pod-run-as-non-root.yaml)
echo "$value"

enter

#echo "PSP/psp-sample01.yaml"
#value2=$(<PSP/psp-sample01.yaml)
#echo "$value2"

#enter

#((i++))
#echo "$i. Check API-Server settings"
#echo ""


#echo "cat /var/snap/microk8s/current/args/kube-apiserver"
#echo ""
#cat /var/snap/microk8s/current/args/kube-apiserver

#enter

((i++))
echo "$i. Deploying the app"
echo ""

#echo "kubectl apply -f $FULLPATH/PSP"
#kubectl apply -f $FULLPATH/PSP
echo "kubectl apply -f $FULLPATH"
kubectl apply -f $FULLPATH --record


echo ""
echo "kubectl wait --for=condition=Initialized pod/pod-run-as-non-root -n=chp13-set1322 --timeout=10s"
kubectl wait --for=condition=Initialized pod/pod-run-as-non-root -n=chp13-set1322 --timeout=10s
echo ""

echo "kubectl wait --for=condition=PodScheduled pod/pod-run-as-non-root -n=chp13-set1322 --timeout=10s"
kubectl wait --for=condition=PodScheduled pod/pod-run-as-non-root -n=chp13-set1322 --timeout=10s
echo ""

echo "This should not reach 'ContainersReady' status"
echo "kubectl wait --for=condition=ContainersReady pod/pod-run-as-non-root -n=chp13-set1322 --timeout=10s"
kubectl wait --for=condition=ContainersReady pod/pod-run-as-non-root -n=chp13-set1322 --timeout=10s
echo ""

echo "This should not reach 'Ready' status"
echo "kubectl wait --for=condition=Ready pod/pod-run-as-non-root -n=chp13-set1322 --timeout=10s"
kubectl wait --for=condition=Ready pod/pod-run-as-non-root -n=chp13-set1322 --timeout=10s

enter 

((i++))
echo "$i. Resource Status"
echo ""
echo "kubectl get pods -n=chp13-set1322 -o wide"
kubectl get pods -n=chp13-set1322 -o wide --sort-by=.status.podIP
echo ""
echo "kubectl get node"
kubectl get node
#echo ""
#echo "kubectl get psp"
#kubectl get psp

enter

((i++))
echo "$i. Pod Check"
echo "If you deploy this pod, it gets scheduled, but is not allowed to run:"
echo "kubectl get pod pod-run-as-non-root -n=chp13-set1322"
kubectl get pod pod-run-as-non-root -n=chp13-set1322

echo $HR

((i++))
echo "kubectl get events -n=chp13-set1322"
kubectl get events -n=chp13-set1322
echo $HR

((i++))
echo "$i. Clean-up"
echo ""

#echo "kubectl delete -f $FULLPATH/PSP --now"
#kubectl delete -f $FULLPATH/PSP --now
#echo ""

echo "kubectl delete -f $FULLPATH --now"
kubectl delete -f $FULLPATH --now
echo $HR 
