# 13.1.1 Using the node’s network namespace in a pod

### Objective

### Notes
* Using the host node's namespaces in a pod

---
If we are using a PSP, make sure we don't have multiple PSP's around that conflict with each other.
---

Containers in a pod usually run under separate Linux namespaces, which isolate their processes from processes running in other containers or in the node's default namespaces.

For example, we learned that each pod gets its own IP and port space, because it uses its own network namespace. Likewise, each pod has its own process tree, because it has its own PID namespace, and it also uses its own IPC namespace, allowing only processes in the same pod to communicate with each other through the Inter-Process Communication mechanism (IPC).


* Using the node's network namespace in a pod

Certain pods (usually system pods) need to operate in the host's default namespaces, allowing them to see and manipulate node-level resources and devices. For example, a pod may need to use the node’s network adapters instead of its own virtual network adapters. This can be achieved by setting the hostNetwork property in the pod spec to true.

In that case, the pod gets to use the node's network interfaces instead of having its own set, as shown in figure 13.1. This means the pod doesn’t get its own IP address and if it runs a process that binds to a port, the process will be bound to the node’s port.
