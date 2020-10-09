Requesting resources for a pod's containers

Setting both how much a pod is expected to consume and the maximum amount it's allowed to consume is a vital part of any pod definition. Setting these two sets of parameters makes sure that a pod takes only its fair share of the resources provided by the Kubernetes cluster and also affects how pods are scheduled across the cluster.

When creating a pod, you can specify the amount of CPU and memory that a container needs (these are called requests) and a hard limit on what it may consume (known as limits). They're specified for each container individually, not for the pod as a whole. The pod's resource requests and limits are the sum of the requests and limits of all its containers.

When you don't specify a request for CPU, you're saying you don’t care how much CPU time the process running in your container is allotted. In the worst case, it may not get any CPU time at all (this happens when a heavy demand by other processes exists on the CPU). Although this may be fine for low-priority batch jobs, which aren’t time-critical, it obviously isn’t appropriate for containers handling user requests.

