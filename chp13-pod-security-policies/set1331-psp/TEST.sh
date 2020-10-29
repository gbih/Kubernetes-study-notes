#d!/bin/bash
. ~/src/common/setup.sh
FULLPATH=$(pwd)
echo "13.3.1 Introducing the PodSecurityPolicy resource"
echo ""
echo "Setup:"
echo "Enable the PodSecurityPolicy admission control plugin in the cluster."
echo ""
echo "Edit /var/snap/microk8s/current/args/kube-apiserver"
echo ""
echo "Comment out --allow-privileged"
echo "#--allow-privileged"
echo ""
echo "Add PodSecurityPolicy to the admission plugins:"
echo '
--enable-admission-plugins="\
NamespaceLifecycle,\
LimitRanger,\
ServiceAccount,\
DefaultStorageClass,\
DefaultTolerationSeconds,\
MutatingAdmissionWebhook,\
ValidatingAdmissionWebhook,\
ResourceQuota,\
PodSecurityPolicy"
'
echo "microk8s stop && microk8s start && microk8s status"
echo $HR_TOP

enter

((i++))


value=$(<set1331-1-psp.yaml)
echo "The following listing shows a sample PodSecurityPolicy, which prevents pods from using the host's IPC, PID, and Network namespaces, and prevents running privileged containers and the use of most host ports (except ports from 10000-11000 and 13000-14000). The policy doesn't set any constraints on what users, groups, or SELinux groups the container can run as."
echo ""
echo "$value"

enter

value=$(<set1331-2-pod-privileged.yaml)
echo "$value"

enter


echo "cat /var/snap/microk8s/current/args/kube-apiserver"
cat /var/snap/microk8s/current/args/kube-apiserver

enter

echo "$i. Deploying the app"
echo ""

echo "kubectl apply -f $FULLPATH"
kubectl apply -f $FULLPATH/set1331-0-ns.yaml
kubectl apply -f $FULLPATH/set1331-1-psp.yaml
sleep 2
echo ""

echo $HR 

((i++))
echo "$i. Check objects and node"
echo ""

echo "kubectl get all -n=chp13-set1327 -o wide"
kubectl get all -n=chp13-set1327 -o wide
echo ""

echo "kubectl get psp"
kubectl get psp psp-default

enter


((i++))
echo "$i. After this PodSecurityPolicy resource is posted to cluster, the API server will no longer allow you to deploy the privileged pod used earlier."
echo ""

echo "kubectl apply -f $FULLPATH/set1331-2-pod-privileged.yaml"
kubectl apply -f $FULLPATH/set1331-2-pod-privileged.yaml
echo ""

echo "Likewise, you can no longer deploy pods that want to use the host's PID, IPC, or Network namespace. Also, because you set readOnlyRootFilesystem to true in the policy, the container filesystems in all pods will be read-only (containers can only write to volumes)."
echo ""

echo "We can still create a non-privileged pod, as in:"
echo "kubectl apply -f $FULLPATH/set1331-3-pod-nonprivileged.yaml"
kubectl apply -f $FULLPATH/set1331-3-pod-nonprivileged.yaml

echo $HR

echo "kubectl get all -n=chp13-set1331"
kubectl get all -n=chp13-set1331
echo $HR


((i++))
echo "$i. Clean-up"
echo ""
echo "kubectl delete -f $FULLPATH"
kubectl delete -f $FULLPATH --ignore-not-found

