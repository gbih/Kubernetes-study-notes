NOTES:

* Limiting resources available to a container

Setting resource requests for containers in a pod ensures each container gets the min- imum amount of resources it needs. Now let's see the other side of the coin — the maximum amount the container will be allowed to consume.

* Setting a hard limit for the amount of resources a container can use

We've seen how containers are allowed to use up all the CPU if all the other processes are sitting idle. But you may want to prevent certain containers from using up more than a specific amount of CPU. And you’ll always want to limit the amount of memory a container can consume.
CPU is a compressible resource, which means the amount used by a container can be throttled without affecting the process running in the container in an adverse way. Memory is obviously different—it's incompressible. Once a process is given a chunk of memory, that memory can’t be taken away from it until it’s released by the process itself. That’s why you need to limit the maximum amount of memory a container can be given.
Without limiting memory, a container (or a pod) running on a worker node may eat up all the available memory and affect all other pods on the node and any new pods scheduled to the node (remember that new pods are scheduled to the node based on the memory requests and not actual memory usage). A single malfunctioning or malicious pod can practically make the whole node unusable.

CREATING A POD WITH RESOURCE LIMITS
To prevent this from happening, Kubernetes allows you to specify resource limits for every container (along with, and virtually in the same way as, resource requests). The following listing shows an example pod manifest with resource limits.

