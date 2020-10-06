#!/bin/bash
. ~/src/SETUP.sh
FULLPATH=$(pwd)

((i++))

cat <<- "NOTES"
NOTES:
Dropping capabilities from a container

You've seen how to add capabilities, but you can also drop capabilities that may otherwise be available to the container. For example, the default capabilities given to a container include the CAP_CHOWN capability, which allows processes to change the ownership of files in the filesystem.

To prevent the container from doing that, you need to drop the capability by listing it under the container's securityContext.capabilities.drop property

By dropping the CHOWN capability, you're not allowed to change the owner of the /tmp directory in a pod.

---

GB Not sure if using the combination of PodSecurityPolicy and pod/container-level securityContext is the best practice here...
NOTES

enter
value=$(<set1325-1-pod-drop-chown-capability.yaml)
echo "$value"

enter

value=$(<PSP-MIN/psp.yaml)
echo "$value"

enter

((i++))
echo "$i. Check API-Server settings"
echo ""

echo "cat /var/snap/microk8s/current/args/kube-apiserver"
echo ""
cat /var/snap/microk8s/current/args/kube-apiserver

enter


echo "$i. Deploying the app"
echo ""

echo "kubectl apply -f $FULLPATH"
kubectl apply -f $FULLPATH/PSP-MIN
kubectl apply -f $FULLPATH --record
sleep 1
echo ""

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
echo "kubectl get psp"
kubectl get psp
echo $HR
echo "kubectl describe clusterrole psp-min-psp"
kubectl describe clusterrole psp-min-psp 
echo $HR
echo "kubectl describe clusterrolebinding psp-min-psp"
kubectl describe clusterrolebinding psp-min-psp

enter

((i++))
echo "Check how a regular pod has this capability:"
echo "kubectl -n=chp13-set1325 exec pod-regular chown guest /tmp"
kubectl -n=chp13-set1325 exec pod-regular chown guest /tmp
echo ""
echo "kubectl -n=chp13-set1325 exec pod-regular -- ls -la / | grep tmp"
kubectl -n=chp13-set1325 exec pod-regular -- ls -la / | grep tmp
echo ""

echo "To prevent the container from doing this, we need to drop the capability by listing it under the container's securityContext.capabilities.drop property".
echo ""
echo "kubectl -n=chp13-set1325 exec pod-drop-chown-capability chown guest /tmp"
kubectl -n=chp13-set1325 exec pod-drop-chown-capability chown guest /tmp

echo $HR

((i++))
echo "$i. Clean-up"
echo ""
echo "kubectl delete -f $FULLPATH"
kubectl delete -f $FULLPATH/PSP-MIN
kubectl delete -f $FULLPATH
