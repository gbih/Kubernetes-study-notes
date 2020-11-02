# 14.4.2 Creating a LimitRange object

### NOTES:

Setting default requests and limits for pods per namespace
We've looked at how resource requests and limits can be set for each individual container. If you don’t set them, the container is at the mercy of all other containers that do specify resource requests and limits. It’s a good idea to set requests and limits on every container.

14.4.1 Introducing the LimitRange resource
Instead of having to do this for every container, you can also do it by creating a LimitRange resource. It allows you to specify (for each namespace) not only the minimum and maximum limit you can set on a container for each resource, but also the default resource requests for containers that don't specify requests explicitly, as depicted in figure 14.6.

LimitRange resources are used by the LimitRanger Admission Control plugin (we explained what those plugins are in chapter 11). When a pod manifest is posted to the API server, the LimitRanger plugin validates the pod spec. If validation fails, the manifest is rejected immediately. Because of this, a great use-case for LimitRange objects is to prevent users from creating pods that are bigger than any node in the cluster. Without such a LimitRange, the API server will gladly accept the pod, but then never schedule it.

The limits specified in a LimitRange resource apply to each individual pod/container or other kind of object created in the same namespace as the LimitRange object. They don't limit the total amount of resources available across all the pods in the namespace. This is specified through ResourceQuota objects, which are explained in section 14.5.

The minimum and maximum limits for a whole pod can be configured. They apply to the sum of all the pod's containers’ requests and limits.

Because the validation (and defaults) configured in a LimitRange object is performed by the API server when it receives a new pod or PVC manifest, if you modify the limits afterwards, existing pods and PVCs will not be revalidated—the new limits will only apply to pods and PVCs created afterward.

