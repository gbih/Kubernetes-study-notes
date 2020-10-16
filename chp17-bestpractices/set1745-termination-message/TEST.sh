#!/bin/bash
. ~/src/common/setup.sh
FULLPATH=$(pwd)
echo "17.4.5 Termination Message" 
echo $HR_TOP

echo "kubectl apply -f $FULLPATH"
kubectl apply -f $FULLPATH

echo $HR

echo "This pod has a busybox container that dies immediately after creation"
echo ""
echo "kubectl wait --for=condition=Ready=True pods/pod-with-termination-message -n=chp17-set1745 --timeout=20s"
kubectl wait --for=condition=Ready=True pods/pod-with-termination-message -n=chp17-set1745 --timeout=20s

echo $HR

echo "kubectl get pods -n=chp17-set1745 -o wide"
kubectl get pods -n=chp17-set1745 -o wide
echo ""

echo "Check termination message"
echo ""
echo "kubectl -n=chp17-set1745 exec -it pod-with-termination-message -- cat /var/termination-reason"
kubectl -n=chp17-set1745 exec -it pod-with-termination-message -- cat /var/termination-reason

echo $HR

# filepath at terminationMessagePath: /var/termination-reason
echo "kubectl -n=chp17-set1745 cp pod-with-termination-message:/var/termination-reason termination-reason.txt"
kubectl -n=chp17-set1745 cp pod-with-termination-message:/var/termination-reason termination-reason.txt

enter

echo "kubectl describe pod pod-with-termination-message -n=chp17-set1745"
kubectl describe pod pod-with-termination-message -n=chp17-set1745

enter

echo "kubectl delete -f $FULLPATH"
kubectl delete -f $FULLPATH

