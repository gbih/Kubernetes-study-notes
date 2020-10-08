# Chapter 13, Section 13.13

### Objective

### Notes
Using the node’s PID and IPC namespaces

Similar to the hostNetwork option are the hostPID and hostIPC pod spec properties. When you set them to true, the pod’s containers will use the node’s PID and IPC namespaces, allowing processes running in the containers to see all the other processes on the node or communicate with them through IPC, respectively.

You’ll remember that pods usually see only their own processes, but if you run this pod and then list the processes from within its container, you’ll see all the processes run- ning on the host node, not only the ones running in the container, as shown in the following listing.

By setting the hostIPC property to true, processes in the pod’s containers can also communicate with all the other processes running on the node, through Inter-Process Communication.
