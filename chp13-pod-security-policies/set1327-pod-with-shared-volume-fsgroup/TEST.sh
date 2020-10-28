#!/bin/bash
. ~/src/common/setup.sh
FULLPATH=$(pwd)
echo "13.2.7 Sharing volumes when containers run as different users"
echo $HR_TOP

((i++))

value=$(<set1327-1-pod-with-shared-volume-fsgroup.yaml)
echo "$value"

enter

echo "$i. Deploying the app"
echo ""

echo "kubectl apply -f $FULLPATH"
kubectl apply -f $FULLPATH --record
echo $HR

echo "kubectl wait --for=condition=Ready pod/pod-with-shared-volume-fsgroup -n=chp13-set1327 --timeout=21s"
kubectl wait --for=condition=Ready pod/pod-with-shared-volume-fsgroup -n=chp13-set1327 --timeout=21s

echo $HR 

((i++))
echo "$i. Check Resources"
echo ""
echo "kubectl get pods -n=chp13-set1327 -o wide"
kubectl get pods -n=chp13-set1327 -o wide --sort-by=.status.podIP
echo ""

enter

((i++))
echo "$i. See what user and group IDs the first container is running as:"
echo ""
echo "kubectl -n=chp13-set1327 exec -it pod-with-shared-volume-fsgroup -c first -- sh -c 'id'"
kubectl -n=chp13-set1327 exec -it pod-with-shared-volume-fsgroup -c first -- sh -c 'id'

echo $HR

((i++))
echo "$i. In the pod definition, you set fsGroup to 555. Because of this, the mounted volume will be owned by group ID 555:"
echo ""
echo "kubectl -n=chp13-set1327 exec -it pod-with-shared-volume-fsgroup -c first -- sh -c 'ls -l / | grep volume'"
kubectl -n=chp13-set1327 exec -it pod-with-shared-volume-fsgroup -c first -- sh -c 'ls -l / | grep volume'

enter

((i++))
echo "$i. Create a file in the mounted volume's directory. The file should be owned by user ID 1111 (the user ID the container is running as) and by group IP 555:"
echo ""

echo "kubectl -n=chp13-set1327 exec -it pod-with-shared-volume-fsgroup -c first -- sh -c 'echo foo > /volume/foo'"
kubectl -n=chp13-set1327 exec -it pod-with-shared-volume-fsgroup -c first -- sh -c 'echo foo > /volume/foo'
echo ""


echo "kubectl -n=chp13-set1327 exec -it pod-with-shared-volume-fsgroup -c first -- sh -c 'ls -l /volume'"
kubectl -n=chp13-set1327 exec -it pod-with-shared-volume-fsgroup -c first -- sh -c 'ls -l /volume'

echo $HR

echo "This is different from how ownership is otherwise set up for newly created files. Usually, the user's effective group ID, which is 0 in your case, is used when a user creates files."
echo ""

echo "You can see this by creating a file in the container’s filesystem instead of in the volume:"
echo ""
echo "kubectl -n=chp13-set1327 exec -it pod-with-shared-volume-fsgroup -c first -- sh -c 'echo foo > /tmp/foo'"
kubectl -n=chp13-set1327 exec -it pod-with-shared-volume-fsgroup -c first -- sh -c 'echo foo > /tmp/foo'
echo ""


echo "kubectl -n=chp13-set1327 exec -it pod-with-shared-volume-fsgroup -c first -- sh -c 'ls -l /tmp'"
kubectl -n=chp13-set1327 exec -it pod-with-shared-volume-fsgroup -c first -- sh -c 'ls -l /tmp'
echo ""

echo "As you can see, the fsGroup security context property is used when the process creates files in a volume (but this depends on the volume plugin used), whereas the supplementalGroups property defines a list of additional group IDs the user is associated with."


echo $HR

((i++))
echo "$i. Clean-up"
echo ""
echo "kubectl delete -f $FULLPATH"
kubectl delete -f $FULLPATH
