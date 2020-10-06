#!/bin/bash
. ~/src/COMMON/SETUP.sh
FULLPATH=$(pwd)

((i++))

cat <<- "NOTES"
NOTES:
Running pods in privileged mode

Sometimes pods need to do everything that the node they're running on can do, such as use protected system devices or other kernel features, which aren't accessible to regular containers.

An example of such a pod is the kube-proxy pod, which needs to modify the node's iptables rules to make services work, as was explained in chapter 11. If you follow the instructions in appendix B and deploy a cluster with kubeadm, you'll see every cluster node runs a kube-proxy pod and you can examine its YAML specification to see all the special features it’s using.

To get full access to the node's kernel, the pod's container runs in privileged mode. This is achieved by setting the privileged property in the container’s securityContext property to true. You’ll create a privileged pod from the YAML in the following listing.

If you're familiar with Linux, you may know it has a special file directory called /dev, which contains device files for all the devices on the system. These aren't regular files on disk, but are special files used to communicate with devices. Let’s see what devices are visible in the non-privileged container you deployed earlier (the pod-with-defaults pod), by listing files in its /dev directory

SETUP NOTES:
To allows priviledge mode in microks, we need this this setup:
1. Add --allow-privileged into /var/snap/microk8s/current/args/kube-apiserver
2. microk8s.stop
3. microk8s.start
NOTES

enter
value=$(<set1323-1-pod-privileged.yaml)
echo "$value"

enter

value=$(<PSP/psp-sample01.yaml)
echo "$value"

enter

echo "$i. Deploying the app via StatefulSet"
echo ""

echo "kubectl apply -f $FULLPATH"
kubectl apply -f $FULLPATH/PSP
kubectl apply -f $FULLPATH --record
#sleep 1
echo ""
echo "kubectl wait --for=condition=Ready pod/pod-privileged -n=chp13-set1323 --timeout=21s"
kubectl wait --for=condition=Ready pod/pod-privileged -n=chp13-set1323 --timeout=21s
echo ""


echo $HR 

((i++))
echo "$i. Check Resources"
echo ""
echo "kubectl get pods -n=chp13-set1323 -o wide"
kubectl get pods -n=chp13-set1323 -o wide --sort-by=.status.podIP
echo ""
echo "kubectl get node"
kubectl get node
echo ""
echo "kubectl get psp"
kubectl get psp
echo ""
echo "kubectl get sa -n=chp13-set1323"
kubectl get sa -n=chp13-set1323
enter

((i++))
echo "See what devices are visible:"
echo "kubectl exec -it pod-privileged -n=chp13-set1323 ls /dev"
#kubectl exec -it pod-privileged -n=chp13-set1323 ls /dev
kubectl exec -it pod-privileged -n=chp13-set1323 -- sh -c 'ls /dev'
echo ""

echo "Now check devices available on the regular non-privileged pod:"
echo "kubectl exec -it pod-non-privileged -n=chp13-set1323 ls /dev"
#kubectl exec -it pod-non-privileged -n=chp13-set1323 ls /dev
kubectl exec -it pod-non-privileged -n=chp13-set1323 -- sh -c 'ls /dev'

enter

#((i++))
#echo "kubectl describe pod/pod-privileged -n=chp13-set1323"
#kubectl describe pod/pod-privileged -n=chp13-set1323
#
##enter
#echo $HR

((i++))
echo "$i. Clean-up"
echo ""
echo "kubectl delete -f $FULLPATH"
kubectl delete -f $FULLPATH/PSP
kubectl delete -f $FULLPATH
echo $HR 
