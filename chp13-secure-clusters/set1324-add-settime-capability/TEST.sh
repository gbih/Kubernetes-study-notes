#!/bin/bash
. ~/src/SETUP.sh
FULLPATH=$(pwd)

((i++))

cat <<- "NOTES"
NOTES:
Adding individual kernel capabilities to a container

In the previous section, you saw one way of giving a container unlimited power. In the old days, traditional UNIX implementations only distinguished between privileged and unprivileged processes, but for many years, Linux has supported a much more fine-grained permission system through kernel capabilities.

Instead of making a container privileged and giving it unlimited permissions, a much safer method (from a security perspective) is to give it access only to the kernel features it really requires. Kubernetes allows you to add capabilities to each container or drop part of them, which allows you to fine-tune the container's permissions and limit the impact of a potential intrusion by an attacker.

For example, a container usually isn't allowed to change the system time (the hardware clock's time). You can confirm this by trying to set the time in your pod-with- defaults pod.

If you want to allow the container to change the system time, you can add a capability called CAP_SYS_TIME to the container's capabilities list, as shown in the following listing.

Adding capabilities like this is a much better way than giving a container full privileges with privileged: true. Admittedly, it does require you to know and understand what each capability does.

You'll find the list of Linux kernel capabilities in the Linux man pages.
NOTES

enter
value=$(<set1324-1-pod-add-settime-capability.yaml)
echo "$value"

enter

value=$(<PSP/podsecuritypolicy.yaml)
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
kubectl apply -f $FULLPATH/PSP
kubectl apply -f $FULLPATH --record
sleep 1
echo ""

echo "kubectl wait --for=condition=Ready pod/pod-add-settime-capability -n=chp13-set1324 --timeout=21s"
kubectl wait --for=condition=Ready pod/pod-add-settime-capability -n=chp13-set1324 --timeout=21s
echo ""

echo $HR 

((i++))
echo "$i. Check resources"
echo ""
echo "kubectl get pods -n=chp13-set1324 -o wide"
kubectl get pods -n=chp13-set1324 -o wide --sort-by=.status.podIP
echo ""
echo "kubectl get node"
kubectl get node
echo ""
echo "kubectl get psp"
kubectl get psp
enter

((i++))
echo "kubectl -n=chp13-set1324 exec -it pod-add-settime-capability -- -sh -c 'date +%T -s "12:00:00"'"
kubectl -n=chp13-set1324 exec -it pod-add-settime-capability -- sh -c 'date +%T -s "12:00:00"'
echo ""
echo "GB: It seems this is working with privileged:true, but not with this capabilities setting..."
echo ""

echo "kubectl -n=chp13-set1324 exec -it pod-add-settime-capability -- sh -c 'date'"
kubectl -n=chp13-set1324 exec -it pod-add-settime-capability -- sh -c 'date'
echo ""

echo $HR

echo "With a pod with regular privileges, it is not allowed to change the system time:"
echo "kubectl exec -it pod-regular -n=chp13-set1324 -- sh -c 'date +%T -s "12:00:00"'"
kubectl exec -it pod-regular -n=chp13-set1324 -- sh -c 'date +%T -s "12:00:00"'


echo $HR

((i++))
echo "$i. Clean-up"
echo ""
echo "kubectl delete -f $FULLPATH"
kubectl delete -f $FULLPATH/PSP
kubectl delete -f $FULLPATH
