# /bin/bash
. ~/src/COMMON/SETUP.sh
FULLPATH=$(pwd)


# http://tldp.org/LDP/abs/html/here-docs.html

#echo "Run this in a separate terminal:"
#echo "kubectl get events -n=chp10-ex01 -w"
#echo $HR

notes1=$(cat <<-"SETVAR"
NOTES:
Ref: https://kubernetes.io/docs/tutorials/stateful-application/basic-stateful-set/

Before deploying a StatefulSet, we first need to create a headless Service.
The headless Service will provide the network identity for the stateful pods.

StatefulSets are not only about pods having a predictable name and hostname. Unlike regular pods, stateful pods sometimes need to be addressable by their hostname, whereas stateless pods usually don't. With stateful pods, you usually want to operate on a specific pod from the group, because they differ from each other.

So, a StatefulSet requires you to create a corresponding governing headless Service that's used to provide the actual network identity to each pod. Through this Service, each pod gets its own DNS entry, so its peers and possibly other clients in the cluster can address the pod by its hostname.

For example, if the governing Service belongs to the default namespace and is called foo, and one of the pods is called A-0, you can reach the pod through its fully qualified domain name, which is a-0.foo.default.svc.cluster.local. You can't do that with pods managed by a ReplicaSet.

Also, you can use DNS to look up all the StatefulSet's pods' names by looking up SRV records for the foo.default.svc.cluster.local domain.

StatefulSet Manifest Notes:
1. The StatefulSet manifest is not that different from a ReplicaSet. What is new is the volumeClaimTemplates list. Here we define one volume claim template called data, which will be used to create a PersistentVolumeClaim for each pod. The StatefulSet adds this to the pod specification automatically and configures the volume to be bound to the claim the StatefulSet created for the specific pod.

2. The storage size must be less than or same size as PV size. If not, we get this error:
Warning  FailedScheduling  37s (x2 over 2m2s)  default-scheduler  error while running "VolumeBinding" filter plugin for pod "kubia-0": pod has unbound immediate PersistentVolumeClaims

3. Need updateStrategy property specified in order to use 'kubectl rollout status'
   https://github.com/kubernetes/kubernetes/issues/72212#issuecomment-468556805

hostPath Notes:
https://kubernetes.io/docs/concepts/storage/volumes/#hostpath
Watch out when using this type of volume, because:

* Pods with identical configuration (such as created from a podTemplate) may behave differently on different nodes due to different files on the nodes
* When Kubernetes adds resource-aware scheduling, as is planned, it will not be able to account for resources used by a hostPath
* The files or directories created on the underlying hosts are only writable by root. You either need to run your process as root in a privileged Container or modify the file permissions on the host to be able to write to a hostPath volume


Notes:
When using kube exec, it's safest to use the -- bash -c '...', as in:
kubectl -n=chp10-ex01 exec web-0 -it -- bash -c "echo "$VAR" > /usr/share/nginx/html/index.html"

Misc:
Run this in a separate terminal:
kubectl get events -n=chp10-ex01 -w

SETVAR
)

echo "$notes1"
enter

value=$(<ex01-3-kubia-statefulset.yaml)
echo "$value"
enter


echo "1. Deploying the app via StatefulSet"
echo ""

echo "kubectl apply -f $FULLPATH"
kubectl apply -f $FULLPATH
#kubectl apply -f $FULLPATH/ex01-0-ns.yaml
#kubectl apply -f $FULLPATH/ex01-1-pv-hostpath.yaml
#kubectl apply -f $FULLPATH/ex01-2-kubia-service-headless.yaml
#kubectl apply -f $FULLPATH/ex01-3-kubia-statefulset.yaml --record
sleep 3

VOLUME_MOUNTS=$(kubectl get sts web -n=chp10-ex01 -o jsonpath={'.spec.template.spec.containers[0].volumeMounts[0].mountPath'})

REPLICAS=$(kubectl get sts web -n=chp10-ex01 -o jsonpath={'.spec.replicas'})
REPLICAS_COUNT=$(($REPLICAS-1))

echo $HR

enter

echo "kubectl rollout status sts web -n=chp10-ex01"
kubectl rollout status sts web -n=chp10-ex01
echo $HR

echo "kubectl get pv -l chp=chp10"
echo "In a StatefulSet with N replicas, Pods are deployed sequentially from {0..N-1}"
echo ""

echo "kubectl get pods -n=chp10-ex01 -l app=nginx -L app"
kubectl get pods -n=chp10-ex01 -l app=nginx -L app
echo $HR


echo "kubectl get pv -l chp=chp10"
kubectl get pv -l chp=chp10
echo $HR

echo "VolumeMounts contents of PersistentVolumes"
#echo "for i in {0..1}; do echo web-$i; kubectl -n=chp10-ex01 exec web-$i -- ls -l $VOLUME_MOUNTS; done"
for i in {0..1}; do echo ""; echo "web-$i"; kubectl -n=chp10-ex01 exec "web-$i" -- ls -l $VOLUME_MOUNTS; done
echo $HR


echo "kubectl get statefulset -n=chp10-ex01 -o wide --show-labels"
kubectl get statefulset -n=chp10-ex01 -o wide --show-labels
echo $HR


echo "kubectl get pvc -n=chp10-ex01 --show-labels"
kubectl get pvc -n=chp10-ex01 --show-labels

enter

echo "Using Stable Network Identities"
echo "Each pod has a stable hostname based on its ordinal index."
echo ""
echo "for i in 0 1; do kubectl -n=chp10-ex01 exec web-\$i -- sh -c 'hostname'; done"
for i in 0 1; do kubectl -n=chp10-ex01 exec web-$i -- sh -c 'hostname'; done

echo $HR

echo "Use kubectl run to execute a container that provides the 'nslookup' command from the dnsutils package."
echo ""

echo "kubectl -n=chp10-ex01 run dnsutils --image=tutum/dnsutils --generator=run-pod/v1 --command -- sleep infinity"
kubectl -n=chp10-ex01 run dnsutils --image=tutum/dnsutils --generator=run-pod/v1 --command -- sleep infinity 
sleep 2
echo ""

echo "kubectl wait --for=condition=Ready=True pod/dnsutils -n=chp10-ex01 --timeout=20s"
kubectl wait --for=condition=Ready=True pod/dnsutils -n=chp10-ex01 --timeout=20s
echo $HR

echo "kubectl exec dnsutils -n=chp10-ex01 -- nslookup web-0.nginx"
kubectl exec dnsutils -n=chp10-ex01 -- nslookup web-0.nginx
echo $HR

echo "kubectl exec dnsutils -n=chp10-ex01 -- nslookup web-1.nginx"
kubectl exec dnsutils -n=chp10-ex01 -- nslookup web-1.nginx
echo $HR

echo "The CNAME of the headless service points to SRV records (one for each Pod that is Running and Ready). The SRV records point to A record entries that contain the Pods' IP addresses."

enter

echo "Delete all the Pods in the StatefulSet."
echo ""

echo "kubectl get pods -n=chp10-ex01 -l app=nginx -o wide"
kubectl get pods -n=chp10-ex01 -l app=nginx -o wide
echo $HR

echo "kubectl delete pod -l app=nginx -n=chp10-ex01"
kubectl delete pod -l app=nginx -n=chp10-ex01

echo $HR
echo "Wait for the StatefulSet to re#start them, and for both Pods to transition to Running and Ready."
sleep 5
echo $HR

echo "kubectl rollout status sts web -n=chp10-ex01"
kubectl rollout status sts web -n=chp10-ex01
echo $HR

echo "kubectl get pod -l app=nginx -n=chp10-ex01 -o wide"
kubectl get pod -l app=nginx -n=chp10-ex01 -o wide

echo $HR

enter


echo "Use kubectl exec and kubectl run to view the Pods hostnames and in-cluster DNS entries."
echo ""

echo "for i in 0 1; do kubectl -n=chp10-ex01 exec web-$i -- sh -c 'hostname'; done"
for i in 0 1; do kubectl -n=chp10-ex01 exec web-$i -- sh -c 'hostname'; done

echo $HR

echo "kubectl exec dnsutils -n=chp10-ex01 -- nslookup web-0.nginx"
kubectl exec dnsutils -n=chp10-ex01 -- nslookup web-0.nginx
echo $HR

echo "kubectl exec dnsutils -n=chp10-ex01 -- nslookup web-1.nginx"
kubectl exec dnsutils -n=chp10-ex01 -- nslookup web-1.nginx
echo $HR

echo "The Pods' ordinals, hostnames, SRV records, and A record names have not changed, but the IP addresses associated with the Pods may have changed. In the cluster used for this tutorial, they have. This is why it is important not to configure other applications to connect to Pods in a StatefulSet by IP address.

If you need to find and connect to the active members of a StatefulSet, you should query the CNAME of the Headless Service (nginx.namespace.svc.cluster.local). The SRV records associated with the CNAME will contain only the Pods in the StatefulSet that are Running and Ready.
"

echo "kubectl exec dnsutils -n=chp10-ex01 -- nslookup nginx.chp10-ex01.svc.cluster.local"
kubectl exec dnsutils -n=chp10-ex01 -- nslookup nginx.chp10-ex01.svc.cluster.local


enter

echo "Writing to Stable Storage"
echo ""

echo "kubectl get pvc -l app=nginx -n=chp10-ex01"
kubectl get pvc -l app=nginx -n=chp10-ex01

echo "
The StatefulSet controller created two PersistentVolumeClaims that are bound to two PersistentVolumes. As the cluster used in this tutorial is configured to dynamically provision PersistentVolumes, the PersistentVolumes were created and bound automatically.

The NGINX webservers, by default, will serve an index file at $VOLUME_MOUNTS/index.html. The volumeMounts field in the StatefulSets spec ensures that the $MOUNT_PATH directory is backed by a PersistentVolume.

Here we write the Pods' hostnames to their index.html files and verify that the NGINX webservers serve the hostnames.
"

echo $HR

echo "May need to change permissions on dir mounted by the volumeMounts (due to bug in hostPath volumes)"
echo "for i in 0 1; do echo web-$i; kubectl -n=chp10-ex01 exec web-$i -- chmod a+wrx /usr/share/nginx/html; done"
for i in 0 1; do echo web-$i; kubectl -n=chp10-ex01 exec web-$i -- chmod a+wrx /usr/share/nginx/html; done
echo $HR

echo "May need to create index.html file here"
echo "for i in 0 1; do kubectl -n=chp10-ex01 exec web-$i -- touch /usr/share/nginx/html/index.html; done"
for i in 0 1; do kubectl -n=chp10-ex01 exec web-$i -- touch /usr/share/nginx/html/index.html; done
echo $HR


echo "Check mountPath contents afterwards:"
echo "for i in 0 1; do echo web-$i; kubectl -n=chp10-ex01 exec web-$i -- sh -c 'ls -la $VOLUME_MOUNTS'; done"
for i in 0 1; do echo ""; echo web-$i; kubectl -n=chp10-ex01 exec web-$i -- ls -la $VOLUME_MOUNTS; done

enter


echo "Write host to $VOLUME_MOUNTS/index.html"
HOSTNAME0=$(kubectl -n=chp10-ex01 exec web-0 -- bash -c 'hostname')
HOSTNAME1=$(kubectl -n=chp10-ex01 exec web-1 -- bash -c 'hostname')
echo ""
echo 'kubectl -n=chp10-ex01 exec web-0 -- bash -c "echo $HOSTNAME0 > $VOLUME_MOUNTS/index.html"'
kubectl -n=chp10-ex01 exec web-0 -- bash -c "echo $HOSTNAME0 > $VOLUME_MOUNTS/index.html"

echo 'kubectl -n=chp10-ex01 exec web-1 -- bash -c "echo $HOSTNAME1 > $VOLUME_MOUNTS/index.html"'
kubectl -n=chp10-ex01 exec web-1 -- bash -c "echo $HOSTNAME1 > $VOLUME_MOUNTS/index.html"
echo $HR


echo "Check mountPath contents afterwards:"
echo "for i in 0 1; do echo web-$i; kubectl -n=chp10-ex01 exec web-$i -- sh -c 'ls -la $VOLUME_MOUNTS'; done"
echo ""
for i in 0 1; do echo ""; echo web-$i; kubectl -n=chp10-ex01 exec web-$i -- ls -la $VOLUME_MOUNTS; done
echo $HR


echo "Check contents via cat"
echo "for i in 0 1; do kubectl -n=chp10-ex01 exec web-$i --  cat $VOLUME_MOUNTS/index.html; done"
for i in 0 1; do kubectl -n=chp10-ex01 exec web-$i -- cat $VOLUME_MOUNTS/index.html; done
echo ""

echo "Check contents via curl"
echo "for i in 0 1; do kubectl -n=chp10-ex01 exec -it web-$i -- curl localhost; done"
for i in 0 1; do kubectl -n=chp10-ex01 exec -it web-$i -- curl localhost; done
echo $HR


echo "kubectl get pod -l app=nginx -n=chp10-ex01"
kubectl get pod -l app=nginx -n=chp10-ex01

echo $HR

enter

echo "Now, delete all of the StatefulSet's Pods:"
echo ""

echo "kubectl delete pod/web-0 -n=chp10-ex01"
kubectl delete pod/web-0 -n=chp10-ex01

echo "kubectl delete pod/web-1 -n=chp10-ex01"
kubectl delete pod/web-1 -n=chp10-ex01

echo $HR


echo "kubectl rollout status sts web -n=chp10-ex01"
kubectl rollout status sts web -n=chp10-ex01
echo $HR

echo "kubectl wait --for=condition=Ready pod/web-0 -n=chp10-ex01 --timeout=20s"
kubectl wait --for=condition=Ready pod/web-0 -n=chp10-ex01 --timeout=20s
echo ""



echo "Check contents via cat:"
echo "for i in 0 1; do kubectl -n=chp10-ex01 exec web-$i -- sh -c 'ls -l $VOLUME_MOUNTS'; done"
for i in 0 1; do kubectl -n=chp10-ex01 exec web-$i -- sh -c "ls $VOLUME_MOUNTS"; done
echo ""


echo "kubectl get pod -l app=nginx --show-labels -n=chp10-ex01"
kubectl get pod -l app=nginx --show-labels -n=chp10-ex01

echo $HR

enter


echo "Verify the web servers continue to serve their hostnames from their StatefulSets:"
echo ""

echo "for i in 0 1; do kubectl -n=chp10-ex01 exec -it web-$i -- curl localhost; done"
for i in 0 1; do kubectl -n=chp10-ex01 exec -it web-$i -- curl localhost; done

enter



echo "Scaling a StatefulSet"
echo ""
echo "Scaling a StatefulSet refers to increasing or decreasing the number of replicas. This is done by updating the replicas field. You can either use kubectl scale or kubectl patch to scale a StatefulSet."
echo ""

echo "If we are manually creating PVs, we have to beforehand prepare 5 PVs for these 5 pods"

echo $HR
echo "kubectl scale --replicas=5 statefulset/web -n=chp10-ex01"
kubectl scale --replicas=5 statefulset/web -n=chp10-ex01

echo $HR

echo "kubectl rollout status sts web -n=chp10-ex01"
kubectl rollout status sts web -n=chp10-ex01
echo $HR

echo "kubectl get pods -l app=nginx -n=chp10-ex01 -L app"
kubectl get pods -l app=nginx -n=chp10-ex01 -L app

echo $HR

enter

echo "Check contents via cat:"
echo "for i in 0 1 2 3 4; do kubectl -n=chp10-ex01 exec web-$i -- sh -c 'cat $VOLUME_MOUNTS/index.html'; done"
for i in 0 1 2 3 4; do kubectl -n=chp10-ex01 exec web-$i -- sh -c "cat $VOLUME_MOUNTS/index.html"; done
echo ""

echo "We can see that only web-0 and web-1 have specific contents in their volumeMounts."
echo "We have not written anything yet to the volumeMounts for web-2, web-3, web-4"
echo "This is as it should be, by the design of StatefulSets."

enter

echo "Scaling Down"
echo ""
echo "Use kubectl patch to scale the StatefulSet back down to 2 replicas"
echo $HR

echo "kubectl patch sts web -p '{spec:{replicas:2}}' -n=chp10-ex01"
kubectl patch sts web -p '{"spec":{"replicas":2}}' -n=chp10-ex01
echo $HR

sleep 5

echo "kubectl rollout status sts web -n=chp10-ex01 -w"
kubectl rollout status sts web -n=chp10-ex01 -w 
echo $HR

echo "kubectl get pods -n=chp10-ex01 -l app=nginx -L app"
kubectl get pods -n=chp10-ex01 -l app=nginx -L app

echo $HR

echo "kubectl get pvc -l app=nginx -n=chp10-ex01"
kubectl get pvc -l app=nginx -n=chp10-ex01
echo $HR

echo "kubectl get pv -l chp=chp10"
kubectl get pv -l chp=chp10

enter

##########

#updating_statefulsets:

echo $HR
# https://kubernetes.io/docs/tutorials/stateful-application/basic-stateful-set/#updating-statefulsets
echo "https://kubernetes.io/docs/tutorials/stateful-application/basic-stateful-set/#updating-statefulsets"
echo "* Updating StatefulSets:"
echo "In Kubernetes 1.7 and later, the StatefulSet controller supports automated updates. The strategy used is determined by the spec.updateStrategy field of the StatefulSet API Object. This feature can be used to upgrade the container images, resource requests and/or limits, labels, and annotations of the Pods in a StatefulSet. There are two valid update strategies, RollingUpdate and OnDelete. RollingUpdate is the default for StatefulSets.

The RollingUpdate update strategy will update all Pods in a StatefulSet, in reverse ordinal order, while respecting the StatefulSet guarantees."

echo $HR

echo "** Rolling Update"
echo "" 

echo "The RollingUpdate update strategy will update all Pods in a StatefulSet, in reverse ordinal order, while respecting the StatefulSet guarantees."
echo ""

echo "Check current updateStrategy type:"
echo "kubectl get statefulset web -n=chp10-ex01 -o jsonpath='{.spec.updateStrategy.type}'"
kubectl get statefulset web -n=chp10-ex01 -o jsonpath='{.spec.updateStrategy.type}'
echo ""
echo ""

echo "Patch the web StatefulSet to apply the RollingUpdate update strategy:"
echo "kubectl patch statefulset web -n=chp10-ex01 -p {"spec":{"updateStrategy":{"type":"RollingUpdate"}}}"
#kubectl patch statefulset web -n=chp10-ex01 -p '{"spec":{"updateStrategy":{"type":"RollingUpdate"}}}'
kubectl patch statefulset web -n=chp10-ex01 --patch '{"spec":{"updateStrategy":{"type":"RollingUpdate"}}}'
echo ""
#echo ""


echo "In one terminal window, patch the web StatefulSet to change the container image again."
echo "kubectl get sts web -n=chp10-ex01 -o jsonpath={'.spec.template.spec.containers[0].image'}"
kubectl get sts web -n=chp10-ex01 -o jsonpath={'.spec.template.spec.containers[0].image'}
echo ""
echo "kubectl patch statefulset web -n=chp10-ex01  --type='json' -p='[{"op": "replace", "path": "/spec/template/spec/containers/0/image", "value":"gcr.io/google_containers/nginx-slim:0.8"}]'"
kubectl patch statefulset web -n=chp10-ex01  --type='json' -p='[{"op": "replace", "path": "/spec/template/spec/containers/0/image", "value":"gcr.io/google_containers/nginx-slim:0.8"}]'
echo ""


echo "In another terminal, watch the Pods in the StatefulSet:"

echo "kubectl rollout status sts web -n=chp10-ex01"
kubectl rollout status sts web -n=chp10-ex01
echo ""
echo "kubectl get pods -n=chp10-ex01 -l app=nginx"
kubectl get pods -n=chp10-ex01
echo ""

echo "The Pods in the StatefulSet are updated in reverse ordinal order. The StatefulSet controller terminates each Pod, and waits for it to transition to Running and Ready prior to updating the next Pod. Note that, even though the StatefulSet controller will not proceed to update the next Pod until its ordinal successor is Running and Ready, it will restore any Pod that fails during the update to its current version. Pods that have already received the update will be restored to the updated version, and Pods that have not yet received the update will be restored to the previous version. In this way, the controller attempts to continue to keep the application healthy and the update consistent in the presence of intermittent failures.
"

echo "Get the Pods to view their container images:"
echo "for p in 0 1; do kubectl get pods -n=chp10-ex01  web-\$p --template '{{range \$i, \$c := .spec.containers}}{{\$c.image}}{{end}}'; echo; done"
for p in 0 1; do kubectl get pods -n=chp10-ex01  web-$p --template '{{range $i, $c := .spec.containers}}{{$c.image}}{{end}}'; echo; done
echo ""

echo "All the Pods in the StatefulSet are now running the previous container image."

#jumpto end

enter

##########

#staging_an_update:

# https://kubernetes.io/docs/tutorials/stateful-application/basic-stateful-set/#staging-an-update

echo "Staging an Update"
echo "https://kubernetes.io/docs/tutorials/stateful-application/basic-stateful-set/#staging-an-update"
echo ""

echo "You can stage an update to a StatefulSet by using the partition parameter of the RollingUpdate update strategy. A staged update will keep all of the Pods in the StatefulSet at the current version while allowing mutations to the StatefulSet’s .spec.template."
echo ""

echo "Check the updateStrategy type:"
echo "kubectl get sts web -n=chp10-ex01 -o jsonpath='{.spec.updateStrategy.type}'"
kubectl get sts web -n=chp10-ex01 -o jsonpath='{.spec.updateStrategy.type}'
echo ""
echo ""

echo "Patch the web StatefulSet to add a partition to the updateStrategy field:"
echo "kubectl patch statefulset web -n=chp10-ex01 -p '{"spec":{"updateStrategy":{"type":"RollingUpdate","rollingUpdate":{"partition":3}}}}'"
kubectl patch statefulset web -n=chp10-ex01 -p '{"spec":{"updateStrategy":{"type":"RollingUpdate","rollingUpdate":{"partition":3}}}}'
echo ""

echo "Patch the StatefulSet again to change the container’s image."
echo "kubectl get sts web -n=chp10-ex01 -o jsonpath='{.spec.template.spec.containers[0].image}'"
kubectl get sts web -n=chp10-ex01 -o jsonpath='{.spec.template.spec.containers[0].image}'
echo ""
echo ""
echo "kubectl patch statefulset web -n=chp10-ex01 --type='json' -p='[{"op": "replace", "path": "/spec/template/spec/containers/0/image", "value":"k8s.gcr.io/nginx-slim:0.7"}]'"
kubectl patch statefulset web -n=chp10-ex01 --type='json' -p='[{"op": "replace", "path": "/spec/template/spec/containers/0/image", "value":"k8s.gcr.io/nginx-slim:0.7"}]'
echo ""

echo "Delete a Pod in the StatefulSet."
echo "kubectl delete pod web-1 -n=chp10-ex01"
kubectl delete pod web-1 -n=chp10-ex01
echo ""

sleep 1

echo "Wait for the Pod to be Running and Ready."
echo "kubectl wait -n=chp10-ex01 --for=condition=Ready pod/web-1 --timeout=30s"
kubectl wait -n=chp10-ex01 --for=condition=Ready pod/web-1 --timeout=30s
echo ""

echo "kubectl get pods -n=chp10-ex01"
kubectl get pods -n=chp10-ex01
echo ""

echo "Get the Pod's container"
echo "kubectl get po -n=chp10-ex01 web-1 --template '{{range \$i, \$c := .spec.containers}}{{\$c.image}}{{end}}'"
kubectl get po -n=chp10-ex01 web-1 --template '{{range $i, $c := .spec.containers}}{{$c.image}}{{end}}'
echo ""
echo "Notice that, even though the update strategy is RollingUpdate the StatefulSet controller restored the Pod with its original container. This is because the ordinal of the Pod is less than the partition specified by the updateStrategy."


#jumpto end

enter

##########

#rolling_out_a_canary:

echo "Rolling Out a Canary"
echo "https://kubernetes.io/docs/tutorials/stateful-application/basic-stateful-set/#rolling-out-a-canary"
echo ""

echo "Partitions"
echo "The RollingUpdate update strategy can be partitioned, by specifying a .spec.updateStrategy.rollingUpdate.partition. If a partition is specified, all Pods with an ordinal that is greater than or equal to the partition will be updated when the StatefulSet’s .spec.template is updated. All Pods with an ordinal that is less than the partition will not be updated, and, even if they are deleted, they will be recreated at the previous version. If a StatefulSet’s .spec.updateStrategy.rollingUpdate.partition is greater than its .spec.replicas, updates to its .spec.template will not be propagated to its Pods. In most cases you will not need to use a partition, but they are useful if you want to stage an update, roll out a canary, or perform a phased roll out."
echo "https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/"
echo ""

echo "You can roll out a canary to test a modification by decrementing the partition you specified above."
echo "Patch the StatefulSet to decrement the partition:"

echo "kubectl -n=chp10-ex01 patch statefulset web -p '{"spec":{"updateStrategy":{"type":"RollingUpdate","rollingUpdate":{"partition":2}}}}'"
kubectl -n=chp10-ex01 patch statefulset web -p '{"spec":{"updateStrategy":{"type":"RollingUpdate","rollingUpdate":{"partition":2}}}}'
echo ""

sleep 1

echo "kubectl rollout status sts web -n=chp10-ex01"
kubectl rollout status sts web -n=chp10-ex01
echo ""

echo "kubectl get pods -n=chp10-ex01"
kubectl get pods -n=chp10-ex01
echo ""


echo "Get the Pod's container:"
echo "kubectl -n=chp10-ex01 get po web-1 --template '{{range \$i, \$c := .spec.containers}}{{\$c.image}}{{end}}'"
kubectl -n=chp10-ex01 get po web-1 --template '{{range $i, $c := .spec.containers}}{{$c.image}}{{end}}'
echo ""
echo ""

echo "When you changed the partition, the StatefulSet controller automatically updates the web-1 Pod because the Pod's ordinal is greater than or equal to the partition."
echo ""

echo "Delete the web-1 Pod."

echo "kubectl delete pod web-1 -n=chp10-ex01"
kubectl delete pod web-1 -n=chp10-ex01
echo ""

echo "kubectl rollout status sts web -n=chp10-ex01"
kubectl rollout status sts web -n=chp10-ex01
echo ""

echo "kubectl get pods -n=chp10-ex01"
kubectl get pods -n=chp10-ex01
echo ""

echo "Get the web-0 Pods container"
echo "kubectl get po web-0 -n=chp10-ex01 --template '{{range \$i, \$c := .spec.containers}}{{\$c.image}}{{end}}'"
kubectl get po web-0 -n=chp10-ex01 --template '{{range $i, $c := .spec.containers}}{{$c.image}}{{end}}'
echo ""
echo ""

echo "web-0 was restored to its original configuration because the Pod’s ordinal was less than the partition. When a partition is specified, all Pods with an ordinal that is greater than or equal to the partition will be updated when the StatefulSet’s .spec.template is updated. If a Pod that has an ordinal less than the partition is deleted or otherwise terminated, it will be restored to its original configuration."
    

#jumpto end

enter

##########

#phased_rollouts:

echo "Phased Roll Outs"
echo "https://kubernetes.io/docs/tutorials/stateful-application/basic-stateful-set/#phased-roll-outs"

echo "You can perform a phased roll out (e.g. a linear, geometric, or exponential roll out) using a partitioned rolling update in a similar manner to how you rolled out a canary. To perform a phased roll out, set the partition to the ordinal at which you want the controller to pause the update."
echo ""

echo "The partition is currently set to 2. Set the partition to 0."
echo "kubectl patch statefulset web -n=chp10-ex01 -p '{"spec":{"updateStrategy":{"type":"RollingUpdate","rollingUpdate":{"partition":0}}}}'"
kubectl patch statefulset web -n=chp10-ex01 -p '{"spec":{"updateStrategy":{"type":"RollingUpdate","rollingUpdate":{"partition":0}}}}'
echo ""

echo "kubectl rollout status sts web -n=chp10-ex01"
kubectl rollout status sts web -n=chp10-ex01
echo ""

#echo "kubectl wait for=condition=ready pod/web-1 -n=chp10-ex01 --timeout=20s"
#kubectl wait for=condition=ready pod/web-1 -n=chp10-ex01 --timeout=20s
#echo ""

echo "kubectl get pods -n=chp10-ex01"
kubectl get pods -n=chp10-ex01
echo ""

echo "Get the Pod's containers:"
echo "for p in 0 1; do kubectl -n=chp10-ex01 get po web-\$p --template '{{range \$i, \$c := .spec.containers}}{{$c.image}}{{end}}'; echo; done"
for p in 0 1; do kubectl -n=chp10-ex01 get po web-$p --template '{{range $i, $c := .spec.containers}}{{$c.image}}{{end}}'; echo; done
echo ""

echo "By moving the partition to 0, you allowed the StatefulSet controller to continue the update process."

#jumpto end

enter

##########

#deleting_statefulsets:

echo "* Deleting StatefulSets"
echo "https://kubernetes.io/docs/tutorials/stateful-application/basic-stateful-set/#deleting-statefulsets"

echo $HR
echo "Begin Setup:"

sleep 1
echo "kubectl wait --for=condition=Ready pods/web-0 -n=chp10-ex01 --timeout=20s"
kubectl wait --for=condition=Ready pods/web-0 -n=chp10-ex01 --timeout=20s
echo ""
echo "kubectl wait --for=condition=Ready pods/web-1 -n=chp10-ex01 --timeout=20s"
kubectl wait --for=condition=Ready pods/web-1 -n=chp10-ex01 --timeout=20s
echo ""

echo "May need to change permissions on dir mounted by the volumeMounts (due to bug in hostPath volumes)"
echo "for i in 0 1; do echo web-$i; kubectl -n=chp10-ex01 exec web-$i -- chmod a+wrx /usr/share/nginx/html; done"
for i in 0 1; do echo web-$i; kubectl -n=chp10-ex01 exec web-$i -- chmod a+wrx /usr/share/nginx/html; done
echo $HR

echo "May need to create index.html file here"
echo "for i in 0 1; do kubectl -n=chp10-ex01 exec web-$i -- touch /usr/share/nginx/html/index.html; done"
for i in 0 1; do kubectl -n=chp10-ex01 exec web-$i -- touch /usr/share/nginx/html/index.html; done
echo $HR


echo "Write host to $VOLUME_MOUNTS/index.html"
HOSTNAME0=$(kubectl -n=chp10-ex01 exec web-0 -- bash -c 'hostname')
HOSTNAME1=$(kubectl -n=chp10-ex01 exec web-1 -- bash -c 'hostname')
echo ""
echo 'kubectl -n=chp10-ex01 exec web-0 -- bash -c "echo $HOSTNAME0 > $VOLUME_MOUNTS/index.html"'
kubectl -n=chp10-ex01 exec web-0 -- bash -c "echo $HOSTNAME0 > $VOLUME_MOUNTS/index.html"

echo 'kubectl -n=chp10-ex01 exec web-1 -- bash -c "echo $HOSTNAME1 > $VOLUME_MOUNTS/index.html"'
kubectl -n=chp10-ex01 exec web-1 -- bash -c "echo $HOSTNAME1 > $VOLUME_MOUNTS/index.html"

echo ""
echo "End Setup"
echo $HR 


echo "StatefulSet supports both Non-Cascading and Cascading deletion. In a Non-Cascading Delete, the StatefulSet’s Pods are not deleted when the StatefulSet is deleted. In a Cascading Delete, both the StatefulSet and its Pods are deleted."
echo ""

echo "** Non-Cascading Delete"

echo "Use kubectl delete to delete the StatefulSet. Make sure to supply the --cascade=false parameter to the command. This parameter tells Kubernetes to only delete the StatefulSet, and to not delete any of its Pods."
echo ""


echo "kubectl delete statefulset web -n=chp10-ex01 --cascade=false"
kubectl delete statefulset web -n=chp10-ex01 --cascade=false
echo ""

echo "kubectl get pods -l app=nginx -n=chp10-ex01"
kubectl get pods -l app=nginx -n=chp10-ex01
echo ""

echo "Even though web has been deleted, all of the Pods are still Running and Ready. Delete web-0"
echo ""
echo "kubectl delete pod web-0 -n=chp10-ex01"
kubectl delete pod web-0 -n=chp10-ex01
echo ""

echo "kubectl get pods -l app=nginx -n=chp10-ex01"
kubectl get pods -l app=nginx -n=chp10-ex01
echo ""
echo "As the web StatefulSet has been deleted, web-0 has not been relaunched."

echo "kubectl get pods -l app=nginx -n=chp10-ex01"
kubectl get pods -l app=nginx -n=chp10-ex01
echo ""
echo ""

echo "Recreate the StatefulSet."
echo "kubectl apply -f ex01-3-kubia-statefulset.yaml"
kubectl apply -f ex01-3-kubia-statefulset.yaml
echo ""

sleep 1
echo "kubectl wait --for=condition=Ready pods/web-0 -n=chp10-ex01 --timeout=20s"
kubectl wait --for=condition=Ready pods/web-0 -n=chp10-ex01 --timeout=20s
echo ""
echo "kubectl wait --for=condition=Ready pods/web-1 -n=chp10-ex01 --timeout=20s"
kubectl wait --for=condition=Ready pods/web-1 -n=chp10-ex01 --timeout=20s
echo ""

echo "kubectl get pods -l app=nginx -n=chp10-ex01"
kubectl get pods -l app=nginx -n=chp10-ex01
echo ""

echo "When the web StatefulSet was recreated, it first relaunched web-0. Since web-1 was already Running and Ready, when web-0 transitioned to Running and Ready, it simply adopted this Pod. Since you recreated the StatefulSet with replicas equal to 2, once web-0 had been recreated, and once web-1 had been determined to already be Running and Ready, web-2 was terminated."
echo ""

echo "Let’s take another look at the contents of the index.html file served by the Pods’ webservers."
echo "for i in 0 1; do kubectl -n=chp10-ex01 exec -it web-\$i -- curl localhost; done"
for i in 0 1; do kubectl -n=chp10-ex01 exec -it web-$i -- curl localhost; done
echo ""

echo "Even though you deleted both the StatefulSet and the web-0 Pod, it still serves the hostname originally entered into its index.html file. This is because the StatefulSet never deletes the PersistentVolumes associated with a Pod. When you recreated the StatefulSet and it relaunched web-0, its original PersistentVolume was remounted."

#jumpto end

enter

########

#cascading_delete:

echo "Cascading Delete"
echo "https://kubernetes.io/docs/tutorials/stateful-application/basic-stateful-set/#cascading-delete"




echo $HR
echo "Begin Setup:"

sleep 1
echo "kubectl wait --for=condition=Ready pods/web-0 -n=chp10-ex01 --timeout=20s"
kubectl wait --for=condition=Ready pods/web-0 -n=chp10-ex01 --timeout=20s
echo ""
echo "kubectl wait --for=condition=Ready pods/web-1 -n=chp10-ex01 --timeout=20s"
kubectl wait --for=condition=Ready pods/web-1 -n=chp10-ex01 --timeout=20s
echo ""

echo "May need to change permissions on dir mounted by the volumeMounts (due to bug in hostPath volumes)"
echo "for i in 0 1; do echo web-$i; kubectl -n=chp10-ex01 exec web-$i -- chmod a+wrx /usr/share/nginx/html; done"
for i in 0 1; do echo web-$i; kubectl -n=chp10-ex01 exec web-$i -- chmod a+wrx /usr/share/nginx/html; done
echo $HR

echo "May need to create index.html file here"
echo "for i in 0 1; do kubectl -n=chp10-ex01 exec web-$i -- touch /usr/share/nginx/html/index.html; done"
for i in 0 1; do kubectl -n=chp10-ex01 exec web-$i -- touch /usr/share/nginx/html/index.html; done
echo $HR


echo "Write host to $VOLUME_MOUNTS/index.html"
HOSTNAME0=$(kubectl -n=chp10-ex01 exec web-0 -- bash -c 'hostname')
HOSTNAME1=$(kubectl -n=chp10-ex01 exec web-1 -- bash -c 'hostname')
echo ""
echo 'kubectl -n=chp10-ex01 exec web-0 -- bash -c "echo $HOSTNAME0 > $VOLUME_MOUNTS/index.html"'
kubectl -n=chp10-ex01 exec web-0 -- bash -c "echo $HOSTNAME0 > $VOLUME_MOUNTS/index.html"

echo 'kubectl -n=chp10-ex01 exec web-1 -- bash -c "echo $HOSTNAME1 > $VOLUME_MOUNTS/index.html"'
kubectl -n=chp10-ex01 exec web-1 -- bash -c "echo $HOSTNAME1 > $VOLUME_MOUNTS/index.html"

echo ""
echo "End Setup"
echo $HR



echo "Delete the StatefulSet again. This time, omit the --cascade=false parameter."

echo "kubectl delete sts web -n=chp10-ex01"
kubectl delete sts web -n=chp10-ex01
echo ""

echo "kubectl get pods -n=chp10-ex01 -l app=nginx"
kubectl get pods -n=chp10-ex01 -l app=nginx
echo ""

echo "kubectl wait --for=delete pod/web-0 -n=chp10-ex01"
kubectl wait --for=delete pod/web-0 -n=chp10-ex01
echo ""

#echo "kubectl wait --for=delete pod/web-1 -n=chp10-ex01"
#kubectl wait --for=delete pod/web-1 -n=chp10-ex01
#echo ""

echo "kubectl get pods -n=chp10-ex01 -l app=nginx"
kubectl get pods -n=chp10-ex01 -l app=nginx
echo ""

echo "As you saw in the Scaling Down section, the Pods are terminated one at a time, with respect to the reverse order of their ordinal indices. Before terminating a Pod, the StatefulSet controller waits for the Pod’s successor to be completely terminated.

Note that, while a cascading delete will delete the StatefulSet and its Pods, it will not delete the Headless Service associated with the StatefulSet. You must delete the nginx Service manually."
echo ""

echo "kubectl delete service nginx -n=chp10-ex01"
kubectl delete service nginx -n=chp10-ex01
echo ""

echo "Recreate the StatefulSet and Headless Service one more time."
kubectl apply -f ex01-2-kubia-service-headless.yaml
kubectl apply -f ex01-3-kubia-statefulset.yaml
echo ""

echo "kubectl rollout status sts web -n=chp10-ex01"
kubectl rollout status sts web -n=chp10-ex01
echo ""

echo "When all of the StatefulSet’s Pods transition to Running and Ready, retrieve the contents of their index.html files."
echo "for i in 0 1; do kubectl -n=chp10-ex01 exec -it web-$i -- curl localhost; done"
for i in 0 1; do kubectl -n=chp10-ex01 exec -it web-$i -- curl localhost; done
echo ""

echo "Even though you completely deleted the StatefulSet, and all of its Pods, the Pods are recreated with their PersistentVolumes mounted, and web-0 and web-1 will still serve their hostnames."
echo ""



echo "kubectl get all -n=chp10-ex01"
kubectl get all -n=chp10-ex01
echo ""

echo "kubectl get pvc -n=chp10-ex01"
kubectl get pvc -n=chp10-ex01
echo ""

echo "kubectl get pv"
kubectl get pv
echo ""

#jumpto end

enter

##########

#pod_management_policy:

echo "Pod Management Policy"
echo "https://kubernetes.io/docs/tutorials/stateful-application/basic-stateful-set/#pod-management-policy"
echo ""
echo "For some distributed systems, the StatefulSet ordering guarantees are unnecessary and/or undesirable. These systems require only uniqueness and identity. To address this, in Kubernetes 1.7, we introduced .spec.podManagementPolicy to the StatefulSet API Object."

echo $HR

echo "Setup - Start"
echo "We cannot really mutate an existing statefulset, so it's easiest to first delete the previous version."
echo "kubectl delete statefulset web -n=chp10-ex01"
kubectl delete statefulset web -n=chp10-ex01
kubectl wait --for=delete pod/web-0 -n=chp10-ex01
#sleep 3
echo "Setup - End"
echo $HR

echo "** OrderedReady Pod Management"
echo "OrderedReady pod management is the default for StatefulSets. It tells the StatefulSet controller to respect the ordering guarantees demonstrated above."
echo $HR

echo "** Parallel Pod Management"
echo "Parallel pod management tells the StatefulSet controller to launch or terminate all Pods in parallel, and not to wait for Pods to become Running and Ready or completely terminated prior to launching or terminating another Pod."
echo ""

echo "kubectl apply -f ex01-4-kubia-web-parallel.yaml"
kubectl apply -f ex01-4-kubia-web-parallel.yaml
echo ""

echo "kubectl wait --for=condition=Ready pod/web-0 -n=chp10-ex01"
echo "kubectl wait --for=condition=Ready pod/web-1 -n=chp10-ex01"
kubectl wait --for=condition=Ready pod/web-0 -n=chp10-ex01
kubectl wait --for=condition=Ready pod/web-1 -n=chp10-ex01
echo ""

echo "kubectl get po -l app=nginx -n=chp10-ex01"
kubectl get po -l app=nginx -n=chp10-ex01
echo ""

echo "The StatefulSet controller launched both web-0 and web-1 at the same time."
echo ""

echo "kubectl scale statefulset/web --replicas=4 -n=chp10-ex01"
kubectl scale statefulset/web --replicas=4 -n=chp10-ex01
echo ""


echo "kubectl rollout status sts web -n=chp10-ex01 --timeout=10s"
kubectl rollout status sts web -n=chp10-ex01 --timeout=10s
echo ""

echo "The StatefulSet controller launched two new Pods, and it did not wait for the first to become Running and Ready prior to launching the second."
echo ""

echo "kubectl get pods -n=chp10-ex01"
kubectl get pods -n=chp10-ex01
echo ""


echo "kubectl delete sts web -n=chp10-ex01"
kubectl delete sts web -n=chp10-ex01
echo ""

echo "The StatefulSet controller deletes all Pods concurrently, it does not wait for a Pod’s ordinal successor to terminate prior to deleting that Pod."


#jumpto end

enter

##########

echo "Cleaning up"
echo "https://kubernetes.io/docs/tutorials/stateful-application/basic-stateful-set/#cleaning-up"
echo "You will need to delete the persistent storage media for the PersistentVolumes used in this tutorial. Follow the necessary steps, based on your environment, storage configuration, and provisioning method, to ensure that all storage is reclaimed."
echo "TO-DO"







#######################################################################

# Use HereDoc as a hack for multi-line comments in Bash
# https://linuxize.com/post/bash-comments/
<< 'COMMENT'

echo "kubectl rollout status sts kubia -n=chp10-ex01"
kubectl rollout status sts kubia -n=chp10-ex01
echo $HR


POD_0=$(kubectl get pod -n=chp10-ex01 -o jsonpath={'.items[0].metadata.name'})
#
echo "kubectl wait --for=condition=Ready=True pod/$POD_0 -n=chp10-ex01 --timeout=21s"
kubectl wait --for=condition=Ready=True pod/$POD_0 -n=chp10-ex01 --timeout=21s
echo $HR


echo "kubectl get pods -n=chp10-ex01 --show-labels"
kubectl get pods -n=chp10-ex01 --show-labels
echo $HR

echo "kubectl get pvc -n=chp10-ex01"
kubectl get pvc -n=chp10-ex01
echo $HR

echo "2. Communicating with the API Server via 'kubectl proxy'"
echo ""

echo "kubectl proxy"
kubectl proxy &
echo $HR

sleep 3

echo "curl localhost:8001/api/v1/namespaces/chp10-ex01/pods/kubia-0/proxy/"
curl localhost:8001/api/v1/namespaces/chp10-ex01/pods/kubia-0/proxy/
echo ""

echo 'curl -X POST -d "Hey there! This greeting was submitted to kubia-0" localhost:8001/api/v1/namespaces/chp10-ex01/pods/kubia-0/proxy/'
curl -X POST -d "Hey there! This greeting was submitted to kubia-0" localhost:8001/api/v1/namespaces/chp10-ex01/pods/kubia-0/proxy/
echo ""

echo "curl localhost:8001/api/v1/namespaces/chp10-ex01/pods/kubia-0/proxy/"
curl localhost:8001/api/v1/namespaces/chp10-ex01/pods/kubia-0/proxy/
echo $HR


echo "kubectl get pvc -n=chp10-ex01"
kubectl get pvc -n=chp10-ex01
echo $HR


echo "2. Deleting a Stateful Pod to see if the rescheduled pod is reattached to the same storage"
echo ""

echo "kubectl delete pod kubia-0 -n=chp10-ex01 --now"
kubectl delete pod kubia-0 -n=chp10-ex01 --now
echo ""


echo "kubectl wait --for=condition=Ready=False pod/$POD_0 -n=chp10-ex01 --timeout=21s"
kubectl wait --for=condition=Ready=False pod/$POD_0 -n=chp10-ex01 --timeout=21s
echo $HR

echo "kubecl get pods -n=chp10-ex01"
kubectl get pods -n=chp10-ex01
echo $HR

echo "kubectl wait --for=condition=Ready=True pod/$POD_0 -n=chp10-ex01 --timeout=21s"
kubectl wait --for=condition=Ready=True pod/$POD_0 -n=chp10-ex01 --timeout=21s
echo $HR

echo "kubecl get pods -n=chp10-ex01"
kubectl get pods -n=chp10-ex01
echo $HR


echo "curl localhost:8001/api/v1/namespaces/chp10-ex01/pods/kubia-0/proxy/"
curl localhost:8001/api/v1/namespaces/chp10-ex01/pods/kubia-0/proxy/
echo $HR


echo "kubectl get pvc -n=chp10-ex01"
kubectl get pvc -n=chp10-ex01

echo $HR

echo "3. Scaling the StatefulSet"
echo ""

echo "kubectl apply -f ex01-5-kubia-statefulset-replicas4.yaml --record"
kubectl apply -f ex01-5-kubia-statefulset-replicas4.yaml --record
sleep 3
echo $HR

# not working
#echo "kubectl rollout status sts kubia -n=chp10-ex01"
#kubectl rollout status sts kubia -n=chp10-ex01
#echo ""

#echo "kubectl wait --for=condition=Ready=True pod/kubia-3 -n=chp10-ex01 --timeout=21s"
#kubectl wait --for=condition=Ready=True pod/kubia-3 -n=chp10-ex01 --timeout=21s
#echo ""
#echo "sleep 10"
#sleep 10 
#echo ""

echo "kubectl get pods -n=chp10-ex01"
kubectl get pods -n=chp10-ex01
echo ""

echo "curl localhost:8001/api/v1/namespaces/chp10-ex01/pods/kubia-0/proxy/"
curl localhost:8001/api/v1/namespaces/chp10-ex01/pods/kubia-0/proxy/
echo ""


echo "kubectl get pvc -n=chp10-ex01"
kubectl get pvc -n=chp10-ex01
echo ""


echo $HR

echo "4. Connecting to Cluster-internal services through the API Server"
echo ""


echo "curl localhost:8001/api/v1/namespaces/chp10-ex01/services/kubia-public/proxy/"
curl localhost:8001/api/v1/namespaces/chp10-ex01/services/kubia-public/proxy/
echo ""

echo $HR

echo "5. Listing DNS SRV records of the headless Service"

echo "kubectl run -it srvlookup --image=tutum/dnsutils --rm --re#start=Never -- dig SRV kubia.chp10-ex01.svc.cluster.local"
kubectl run -it srvlookup --image=tutum/dnsutils --rm --re#start=Never -- dig SRV kubia.chp10-ex01.svc.cluster.local
echo ""


echo $HR

echo "6. Updating a StatefulSet"
echo ""


echo "Need to build a container with the namespace chp10-ex01 hardcoded in"

# docker build -t georgebaptista/kubia-pet-peers .
# docker login --username georgebaptista --password CUisdfsdjfkd8937473Uhdjfjjfdfod09
# docker login --username georgebaptista --password <pwd>
# docker push georgebaptista/kubia-pet-peers
echo ""

echo "kubectl apply -f ex01-6-kubia-statefulset-image-pet-peers.yaml"
kubectl apply -f ex01-6-kubia-statefulset-image-pet-peers.yaml
echo ""


# NOT WORKING!
#echo "kubectl rollout status sts kubia -n=chp10-ex01"
#kubectl rollout status sts kubia -n=chp10-ex01
#echo ""

echo "sleep 5"
sleep 5
echo ""

echo "kubectl get pods -n=chp10-ex01"
kubectl get pods -n=chp10-ex01
echo ""

kubectl delete pods kubia-0 kubia-1 -n=chp10-ex01
echo ""

#sleep 11

echo $HR

echo "7. Trying out the clustered data store"
echo ""

echo "kubectl wait --for=condition=Ready=True pod/kubia-0 -n=chp10-ex01 --timeout=31s"
kubectl wait --for=condition=Ready=True pod/kubia-0 -n=chp10-ex01 --timeout=31s
echo ""

echo "sleep 3"
sleep 3
echo ""

echo 'curl -X POST -d "The sun is shining" localhost:8001/api/v1/namespaces/chp10-ex01/services/kubia-public/proxy/'
curl -X POST -d "The sun is shining" localhost:8001/api/v1/namespaces/chp10-ex01/services/kubia-public/proxy/
echo ""


echo 'curl -X POST -d "The weather is sweet" localhost:8001/api/v1/namespaces/chp10-ex01/services/kubia-public/proxy/'
curl -X POST -d "The weather is sweet" localhost:8001/api/v1/namespaces/chp10-ex01/services/kubia-public/proxy/
echo ""

echo "sleep 2"
sleep 2
echo ""

echo 'curl localhost:8001/api/v1/namespaces/chp10-ex01/services/kubia-public/proxy/'
curl localhost:8001/api/v1/namespaces/chp10-ex01/services/kubia-public/proxy/
echo ""


echo $HR

echo "8. Deleting namespace"
echo ""

echo "Remove port forward process"
echo "killall kubectl"
killall kubectl
echo $HR

echo "kubectl delete -f $FULLPATH -now"
kubectl delete -f $FULLPATH --now

echo $HR

COMMENT

#read -p "[Press ENTER to continue]"
#clear

#echo "Remove port forward process"
#echo "killall kubectl"
#killall kubectl

end:

echo $HR
echo "kubectl delete -f $FULLPATH --now"
kubectl delete pvc --all -n=chp10-ex01 --now --wait=true
kubectl delete sts web -n=chp10-ex01 --now --wait=true
kubectl delete ns chp10-ex01 --now --wait=true
kubectl delete pv -l set=chp10-ex01 --wait=true
#kubectl delete -f $FULLPATH --now
echo $HR

