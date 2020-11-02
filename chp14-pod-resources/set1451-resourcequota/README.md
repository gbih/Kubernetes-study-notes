# 14.5.1 Introducing the ResourceQuota object

### NOTES:
Limiting the total resources available in a namespace

As you've seen, LimitRanges only apply to individual pods, but cluster admins also need a way to limit the total amount of resources available in a namespace. This is achieved by creating a ResourceQuota object.

* Introducing the ResourceQuota object

In chapter 10 we said that several Admission Control plugins running inside the API server verify whether the pod may be created or not. In the previous section, I said that the LimitRanger plugin enforces the policies configured in LimitRange resources. Similarly, the ResourceQuota Admission Control plugin checks whether the pod being created would cause the configured ResourceQuota to be exceeded. If that's the case, the pod's creation is rejected. Because resource quotas are enforced at pod creation time, a ResourceQuota object only affects pods created after the ResourceQuota object is created—creating it has no effect on existing pods.

A ResourceQuota limits the amount of computational resources the pods and the amount of storage PersistentVolumeClaims in a namespace can consume. It can also limit the number of pods, claims, and other API objects users are allowed to create inside the namespace. Because you've mostly dealt with CPU and memory so far, let's start by looking at how to specify quotas for them.

A ResourceQuota object applies to the namespace it's created in, like a Limit- Range, but it applies to all the pods' resource requests and limits in total and not to each individual pod or container separately.

LimitRanges apply to individual pods; ResourceQuotas apply to all pods in the namespace.

One caveat when creating a ResourceQuota is that you will also want to create a LimitRange object alongside it. In your case, you have a LimitRange configured from the previous section, but if you didn't have one, you couldn't run the kubia-manual pod, because it doesn't specify any resource requests or limits.

When a quota for a specific resource (CPU or memory) is configured (request or limit), pods need to have the request or limit (respectively) set for that same resource; otherwise the API server will not accept the pod. That's why having a LimitRange with defaults for those resources can make life a bit easier for people creating pods.

