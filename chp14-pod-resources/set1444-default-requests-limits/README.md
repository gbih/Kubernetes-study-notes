NOTES:
Applying default resource requests and limits

Default resource requests and limits can be set on containers that don't specify them.

Before you set up your LimitRange object, all your pods were created without any resource requests or limits, but now the defaults are applied automatically when creating the pod.

The container's requests and limits match the ones you specified in the LimitRange object. If you used a different LimitRange specification in another namespace, pods created in that namespace would obviously have different requests and limits. This allows admins to configure default, min, and max resources for pods per namespace.

If namespaces are used to separate different teams or to separate development, QA, staging, and production pods running in the same Kubernetes cluster, using a different LimitRange in each namespace ensures large pods can only be created in certain namespaces, whereas others are constrained to smaller pods.

But remember, the limits configured in a LimitRange only apply to each individual pod/container. It's still possible to create many pods and eat up all the resources available in the cluster. LimitRanges don’t provide any protection from that. A ResourceQuota object, on the other hand, does. You’ll learn about them next.
