#!/bin/bash
. ~/src/common/setup.sh
FULLPATH=$(pwd)
echo "Preventing processes from writing to the container's filesystem"
echo $HR_TOP

((i++))

value=$(<set1326-1-pod-readonly-filesystem.yaml)
echo "$value"

enter


echo "$i. Deploying the app"
echo ""

echo "kubectl apply -f $FULLPATH"
kubectl apply -f $FULLPATH --record
echo $HR
echo "kubectl wait --for=condition=Ready pod/pod-with-readonly-filesystem -n=chp13-set1326 --timeout=21s"
kubectl wait --for=condition=Ready pod/pod-with-readonly-filesystem -n=chp13-set1326 --timeout=21s

echo $HR 

((i++))
echo "$i. Check Resources"
echo ""
echo "kubectl get pods -n=chp13-set1326 -o wide"
kubectl get pods -n=chp13-set1326 -o wide --sort-by=.status.podIP

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
kubectl delete -f $FULLPATH
