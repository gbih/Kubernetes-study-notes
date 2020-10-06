#!/bin/bash
. ../../SETUP.sh
FULLPATH=$(pwd)

((i++))

cat <<- "NOTES"
NOTES:
Preventing a container from running as root

What if you don't care what user the container runs as, but you still want to prevent it from running as root?

Imagine having a pod deployed with a container image that was built with a USER daemon directive in the Dockerfile, which makes the container run under the daemon user. What if an attacker gets access to your image registry and pushes a different image under the same tag? The attacker's image is configured to run as the root user. When Kubernetes schedules a new instance of your pod, the Kubelet will download the attacker’s image and run whatever code they put into it.

Although containers are mostly isolated from the host system, running their pro- cesses as root is still considered a bad practice. For example, when a host directory is mounted into the container, if the process running in the container is running as root, it has full access to the mounted directory, whereas if it's running as non-root, it won’t.

To prevent the attack scenario described previously, you can specify that the pod's container needs to run as a non-root user
NOTES

enter

value=$(<set1322-1-pod-run-as-non-root.yaml)
echo "$value"

enter

value2=$(<PSP/psp-sample01.yaml)
echo "$value2"

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

echo "kubectl apply -f $FULLPATH/PSP"
kubectl apply -f $FULLPATH/PSP
echo ""
echo "kubectl apply -f $FULLPATH"
kubectl apply -f $FULLPATH --record


echo ""
echo "kubectl wait --for=condition=Initialized pod/pod-run-as-non-root -n=chp13-set1322 --timeout=5s"
kubectl wait --for=condition=Initialized pod/pod-run-as-non-root -n=chp13-set1322 --timeout=5s
echo ""

echo "kubectl wait --for=condition=PodScheduled pod/pod-run-as-non-root -n=chp13-set1322 --timeout=5s"
kubectl wait --for=condition=PodScheduled pod/pod-run-as-non-root -n=chp13-set1322 --timeout=5s
echo ""

echo "kubectl wait --for=condition=Ready pod/pod-run-as-non-root -n=chp13-set1322 --timeout=5s"
kubectl wait --for=condition=Ready pod/pod-run-as-non-root -n=chp13-set1322 --timeout=5s

echo $HR 

((i++))
echo "$i. Check Resources"
echo ""
echo "kubectl get pods -n=chp13-set1322 -o wide"
kubectl get pods -n=chp13-set1322 -o wide --sort-by=.status.podIP
echo ""
echo "kubectl get node"
kubectl get node
echo ""
echo "kubectl get psp"
kubectl get psp

enter

((i++))
echo "$i. Pod Status"
echo "If you deploy this pod, it gets scheduled, but is not allowed to run:"
echo "kubectl get pod pod-run-as-non-root -n=chp13-set1322"
kubectl get pod pod-run-as-non-root -n=chp13-set1322

echo $HR

((i++))
echo "$i Misc Test"
echo "To see the effect of the runAsUser property, run the id command in this new pod."
echo ""
echo "kubectl exec pod-run-as-non-root id -n=chp13-set1322"
kubectl exec pod-run-as-non-root id -n=chp13-set1322 
echo ""
echo "We can see this pod running as the more limited guest user."
echo ""

echo $HR

((i++))
echo "$i. Clean-up"
echo ""

echo "kubectl delete -f $FULLPATH/PSP --now"
kubectl delete -f $FULLPATH/PSP --now
echo ""

echo "kubectl delete -f $FULLPATH --now"
kubectl delete -f $FULLPATH --now
echo $HR 
