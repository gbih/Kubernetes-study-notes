#!/bin/bash
. ~/src/SETUP.sh
FULLPATH=$(pwd)

((i++))

cat <<- "NOTES"
NOTES:
Preventing processes from writing to the container's filesystem


GB: If we are using PodSecurityPolicy, then maybe we really don't need the pod/container-level securityContext mechanism???


You may want to prevent the processes running in the container from writing to the container's filesystem, and only allow them to write to mounted volumes. You'd want to do that mostly for security reasons.

Let's imagine you're running a PHP application with a hidden vulnerability, allowing an attacker to write to the filesystem. The PHP files are added to the container image at build time and are served from the container’s filesystem. Because of the vulnerability, the attacker can modify those files and inject them with malicious code.

These types of attacks can be thwarted by preventing the container from writing to its filesystem, where the app's executable code is normally stored. This is done by setting the container's securityContext.readOnlyRootFilesystem property to true.
NOTES

enter
value=$(<set1326-1-pod-readonly-filesystem.yaml)
echo "$value"

enter

value=$(<PSP/psp.yaml)
echo "$value"

enter

echo "$i. Deploying the app"
echo ""

echo "kubectl apply -f $FULLPATH/PSP"
kubectl apply -f $FULLPATH/PSP
echo "kubectl apply -f $FULLPATH"
kubectl apply -f $FULLPATH --record
sleep 1
echo ""

echo "kubectl wait --for=condition=Ready pod/pod-with-readonly-filesystem -n=chp13-set1326 --timeout=21s"
kubectl wait --for=condition=Ready pod/pod-with-readonly-filesystem -n=chp13-set1326 --timeout=21s
echo ""

echo $HR 

((i++))
echo "$i. Check Resources"
echo ""
echo "kubectl get pods -n=chp13-set1326 -o wide"
kubectl get pods -n=chp13-set1326 -o wide --sort-by=.status.podIP
echo ""
echo "kubectl get node"
kubectl get node
echo ""
echo "kubectl get psp"
kubectl get psp

enter

((i++))
echo "Try writing to the container's filesystem. This should fail:"
echo "kubectl -n=chp13-set1326 exec -it pod-with-readonly-filesystem -- touch /new-file"
kubectl -n=chp13-set1326 exec -it pod-with-readonly-filesystem -- touch /new-file
echo ""

echo "Next, try writing to the mounted volume. This should succeed:"
echo "kubectl -n=chp13-set1326 exec -it pod-with-readonly-filesystem -- touch /volume/newfile"
kubectl -n=chp13-set1326 exec -it pod-with-readonly-filesystem -- touch /volume/newfile
echo ""

echo "kubectl -n=chp13-set1326 exec -it pod-with-readonly-filesystem -- sh -c 'ls -la /volume/newfile'"
kubectl -n=chp13-set1326 exec -it pod-with-readonly-filesystem -- sh -c 'ls -la /volume/newfile'

echo ""
echo ""
echo "When you make the container's filesystem read-only, you’ll probably want to mount a volume in every directory the application writes to (for example, logs, on-disk caches, and so on)."
echo ""
echo "Best Practice: To increase security, when running pods in production, set their container's readOnlyRootFilesystem property to true."
echo ""
echo "In all these examples, you've set the security context of an individual container. Several of these options can also be set at the pod level (through the pod.spec.security-Context property). They serve as a default for all the pod’s containers but can be overridden at the container level."
echo $HR

((i++))
echo "$i. Clean-up"
echo ""
echo "kubectl delete -f $FULLPATH"
kubectl delete -f $FULLPATH/PSP
kubectl delete -f $FULLPATH
