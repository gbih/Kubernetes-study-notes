#!/bin/bash
. ~/src/common/setup.sh
FULLPATH=$(pwd)
echo "13.3.2 Understanding runAsUser, fsGroup, and supplementalGroups policies"
echo $HR_TOP

((i++))

value=$(<set1332-1-psp-must-run-as.yaml)
echo "$value"

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

enter

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
echo ""
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
kubectl delete -f $FULLPATH --ignore-not-found
