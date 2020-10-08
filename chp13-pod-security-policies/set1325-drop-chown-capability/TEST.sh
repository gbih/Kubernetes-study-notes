#!/bin/bash
. ~/src/common/setup.sh
FULLPATH=$(pwd)
echo "Dropping capabilities from a container"
echo $HR_TOP

value=$(<set1325-1-pod-drop-chown-capability.yaml)
echo "$value"

enter

((i++))
echo "$i. Deploying the app"
echo ""

echo "kubectl apply -f $FULLPATH"
kubectl apply -f $FULLPATH --record
echo $HR
echo "kubectl wait --for=condition=Ready pod/pod-drop-chown-capability -n=chp13-set1325 --timeout=21s"
kubectl wait --for=condition=Ready pod/pod-drop-chown-capability -n=chp13-set1325 --timeout=21s

enter

((i++))
echo "$i. Check Resources"
echo ""
echo "kubectl get pods -n=chp13-set1325 -o wide"
kubectl get pods -n=chp13-set1325 -o wide --sort-by=.status.podIP
echo ""
echo "kubectl get node"
kubectl get node
echo $HR
echo "kubectl describe sa -n=chp13-set1325"
kubectl describe sa -n=chp13-set1325
echo $HR

#echo "kubectl describe clusterrole psp-min-psp"
#kubectl describe clusterrole psp-min-psp 
#echo $HR
#echo "kubectl describe clusterrolebinding psp-min-psp"
#kubectl describe clusterrolebinding psp-min-psp

enter

((i++))
echo "Check how a regular pod has this capability:"
echo "kubectl -n=chp13-set1325 exec pod-regular -- chown guest /tmp"
kubectl -n=chp13-set1325 exec pod-regular -- chown guest /tmp
echo ""
echo "kubectl -n=chp13-set1325 exec pod-regular -- ls -la / | grep tmp"
kubectl -n=chp13-set1325 exec pod-regular -- ls -la / | grep tmp
echo ""

echo "By dropping the CHOWN capability, you're not allowed to change the owner of the /tmp directory in this pod."
echo "This should now return an error."
echo ""
echo "kubectl -n=chp13-set1325 exec pod-drop-chown-capability -- chown guest /tmp"
kubectl -n=chp13-set1325 exec pod-drop-chown-capability -- chown guest /tmp

echo $HR

((i++))
echo "$i. Clean-up"
echo ""
echo "kubectl delete -f $FULLPATH"
kubectl delete -f $FULLPATH

