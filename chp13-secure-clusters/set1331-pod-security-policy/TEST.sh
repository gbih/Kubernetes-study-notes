#d!/bin/bash
. ~/src/COMMON/SETUP.sh
FULLPATH=$(pwd)

((i++))

cat <<- "NOTES"
NOTES:
PodSecurityPolicy is a cluster-level (non-namespaced) resource, which defines what security-related features users can or can't use in their pods. The job of upholding the policies configured in PodSecurityPolicy resources is performed by the PodSecurityPolicy admission control plugin running in the API server.

When someone posts a pod resource to the API server, the PodSecurityPolicy admission control plugin validates the pod definition against the configured PodSecurityPolicies. If the pod conforms to the cluster's policies, it's accepted and stored into etcd; otherwise it’s rejected immediately. The plugin may also modify the pod resource according to defaults configured in the policy.

UNDERSTANDING WHAT A PODSECURITYPOLICY CAN DO
A PodSecurityPolicy resource defines things like the following:
* Whether a pod can use the host's IPC, PID, or Network namespaces
* Which host ports a pod can bind to
* What user IDs a container can run as
* Whether a pod with privileged containers can be created
* Which kernel capabilities are allowed, which are added by default and which are always dropped
* What SELinux labels a container can use
* Whether a container can use a writable root filesystem or not
* Which filesystem groups the container can run as
* Which volume types a pod can use

NOTES FOR PLUGINS:
The PodSecurityPolicy admission control plugin may not be enabled in your cluster.

Enabling PodSecurityPolicy admission control in microk8s
https://gist.github.com/antonfisher/d4cb83ff204b196058d79f513fd135a6

To run multik8s with the PodSecurityPolicy plugsin enabled, 
sudo vim /var/snap/microk8s/current/args/kube-apiserver

Add PodSecurityPolicy to the admission plugins:
--enable-admission-plugins="NamespaceLifecycle,LimitRanger,ServiceAccount,DefaultStorageClass,DefaultTolerationSeconds,MutatingAdmissionWebhook,ValidatingAdmissionWebhook,ResourceQuota,PodSecurityPolicy,ServiceAccount"

Then,
microk8s.stop
microk8s.start
NOTES

enter
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

#echo "kubectl wait --for=condition=PodScheduled ..."
#echo "kubectl wait --for=condition=PodSchedules pod/pod-with-shared-volume-fsgroup -n=chp13-set1327 --timeout=21s"
#kubectl wait --for=condition=Ready pod/pod-with-shared-volume-fsgroup -n=chp13-set1327 --timeout=21s
#echo ""

echo $HR 

((i++))
echo "$i. Check objects and node"
echo ""

echo "kubectl get all -n=chp13-set1327 -o wide"
kubectl get all -n=chp13-set1327 -o wide
echo ""

echo "kubectl get node"
kubectl get node
echo ""

echo "kubectl get psp"
kubectl get psp psp-default

enter

#echo "kubectl describe psp default"
#kubectl describe psp default
#enter

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
echo ""

echo $HR

#echo "TEST OF USER-RESTRICTIONS:"
#echo "kubectl apply -f $FULLPATH/set1331-4-pod-as-user-guest.yaml"
#kubectl apply -f $FULLPATH/set1331-4-pod-as-user-guest.yaml
#echo "---GB: This should be rejected, but it is passing.... WHY?"
#
#echo $HR

((i++))
echo "$i. Clean-up"
echo ""
echo "kubectl delete -f $FULLPATH"
kubectl delete -f $FULLPATH

