#!/bin/bash
. ~/src/common/setup.sh
FULLPATH=$(pwd)
echo "13.2.3 Running pods in privileged mode"
echo ""
echo "To allows priviledge mode in microk8s, use this cluster-configuration:"
echo "Add --allow-privileged /var/snap/microk8s/current/args/kube-apiserver"
echo "microk8s.stop"
echo "microk8s.start"
echo $HR_TOP

((i++))

value=$(<set1323-1-pod-privileged.yaml)
echo "$value"

enter


echo "$i. Deploying the app via StatefulSet"
echo ""

echo "kubectl apply -f $FULLPATH"
kubectl apply -f $FULLPATH --record
echo ""
echo "kubectl wait --for=condition=Ready pod/pod-privileged -n=chp13-set1323 --timeout=21s"
kubectl wait --for=condition=Ready pod/pod-privileged -n=chp13-set1323 --timeout=21s
echo ""


echo $HR 

((i++))
echo "$i. Check Resources"
echo ""
echo "kubectl get pods -n=chp13-set1323 -o wide"
kubectl get pods -n=chp13-set1323 -o wide --sort-by=.status.podIP
echo ""
echo "kubectl get node"
kubectl get node
echo ""
echo "kubectl get sa -n=chp13-set1323"
kubectl get sa -n=chp13-set1323
enter

((i++))
echo "See what devices are visible:"
echo "kubectl exec -it pod-privileged -n=chp13-set1323 ls /dev"
#kubectl exec -it pod-privileged -n=chp13-set1323 ls /dev
kubectl exec -it pod-privileged -n=chp13-set1323 -- sh -c 'ls /dev'
echo ""

echo "Now check devices available on the regular non-privileged pod:"
echo "kubectl exec -it pod-non-privileged -n=chp13-set1323 ls /dev"
#kubectl exec -it pod-non-privileged -n=chp13-set1323 ls /dev
kubectl exec -it pod-non-privileged -n=chp13-set1323 -- sh -c 'ls /dev'

enter

((i++))
echo "$i. Clean-up"
echo ""
echo "kubectl delete -f $FULLPATH"
kubectl delete -f $FULLPATH
echo $HR 
