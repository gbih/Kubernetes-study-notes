#!/bin/bash
. ~/src/common/setup.sh
FULLPATH=$(pwd)

((i++))

cat <<- "NOTES"
NOTES: 
Understanding runAsUser, fsGroup, and supplementalGroups policies

The policy in the previous example doesn't impose any limits on which users and groups containers can run as, because you've used the RunAsAny rule for the runAs- User, fsGroup, and supplementalGroups fields. If you want to constrain the list of allowed user or group IDs, you change the rule to MustRunAs and specify the range of allowed IDs.

USING THE MUSTRUNAS RULE
Let's look at an example. To only allow containers to run as user ID 2 and constrain the default filesystem group and supplemental group IDs to be anything from 2–10 or 20–30 (all inclusive), you'd include the following snippet in the PodSecurityPolicy resource.

If the pod spec tries to set either of those fields to a value outside of these ranges, the pod will not be accepted by the API server. To try this, delete the previous PodSecurityPolicy and create the new one from the psp-must-run-as.yaml file.

---

SETUP NOTES:
In order to use MustRunAs rule in the PodSecurityPolicy, we have to enable

SecurityContextDeny

in the kube-apiserver at
/var/snap/microk8s/current/args/kube-apiserver

Reference:
https://kubernetes.io/docs/reference/access-authn-authz/admission-controllers/
NOTES

enter

value=$(<set1332-1-psp-must-run-as.yaml)
echo "$value"

enter

echo "cat /var/snap/microk8s/current/args/kube-apiserver"
echo ""
cat /var/snap/microk8s/current/args/kube-apiserver
echo ""
echo "See more options here: https://kubernetes.io/docs/reference/command-line-tools-reference/kube-apiserver/"

enter


echo "$i. Deploying the app"
echo ""

echo "kubectl apply -f $FULLPATH"
kubectl apply -f $FULLPATH/set1332-0-ns.yaml
kubectl apply -f $FULLPATH/set1332-1-psp-must-run-as.yaml
sleep 2

echo $HR 

((i++))
echo "$i. Check Resources"
echo ""

echo "kubectl get node"
kubectl get node
echo ""

echo "kubectl get psp psp-default"
kubectl get psp psp-default

enter

((i++))
echo "$i. After this PodSecurityPolicy resource is posted to cluster, the API server will no longer allow you to deploy the privileged pod used earlier."
echo ""

echo "kubectl apply -f $FULLPATH/set1332-2-pod-as-user-guest.yaml"
kubectl apply -f $FULLPATH/set1332-2-pod-as-user-guest.yaml
echo ""

echo "Likewise, you can no longer deploy pods that want to use the host's PID, IPC, or Network namespace. Also, because you set readOnlyRootFilesystem to true in the policy, the container filesystems in all pods will be read-only (containers can only write to volumes)."
echo $HR

echo "Try deploying a pod with the user 2 specified:"
echo "kubectl apply -f $FULLPATH/set1332-3-pod-as-user2.yaml"
kubectl apply -f $FULLPATH/set1332-3-pod-as-user2.yaml
echo ""
echo "kubectl wait --for=condition=Ready pod/pod-as-user2 -n=chp13-set1332 --timeout=21s"
kubectl wait --for=condition=Ready pod/pod-as-user2 -n=chp13-set1332 --timeout=21s
echo ""

echo "kubectl -n=chp13-set1332 exec pod-as-user2 -- id"
kubectl -n=chp13-set1332 exec pod-as-user2 -- id

echo $HR

echo "Dockerfile with a USER directive: kubia-run-as-user-5/Dockerfile"
echo ""
echo "kubectl apply -f $FULLPATH/set1332-4-runas5container.yaml"
kubectl apply -f $FULLPATH/set1332-4-runas5container.yaml
echo "kubectl wait --for=condition=Ready pod/run-as-5 -n=chp13-set1332 --timeout=21s"
kubectl wait --for=condition=Ready pod/run-as-5 -n=chp13-set1332 --timeout=21s
echo ""
echo "kubectl -n=chp13-set1332 exec run-as-5 -- id"
kubectl -n=chp13-set1332 exec run-as-5 -- id
echo ""
echo "The container is running as user ID 2, which is the ID you specified in the PodSecurityPolicy. The PodSecurityPolicy can be used to override the user ID hardcoded into a container image."
echo $HR

((i++))
echo "$i. Clean-up"
echo ""
echo "kubectl delete -f $FULLPATH"
kubectl delete -f $FULLPATH
