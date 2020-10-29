# Chapter 13, Section 13.12

### Objective

### Notes
Binding to a host port without using the host's network namespace

NOTE - SETUP
In order to use hostPort, either
--enable-admission-plugins="PodSecurityPolicy"
needs to be off, or the PodSecurityPolicy needs to enable a hostPort,
either as a range, or RunAsAny

---

https://kubernetes.io/docs/concepts/policy/pod-security-policy/#example-policies

Example Policies
This is the least restrictive policy you can create, equivalent to not using the pod security policy admission controller:

apiVersion: policy/v1beta1
kind: PodSecurityPolicy
metadata:
  name: privileged
spec:
  privileged: true
  allowPrivilegeEscalation: true
  allowedCapabilities:
  - '*'
  volumes:
  - '*'
  hostNetwork: true
  hostPorts:
  - min: 0
    max: 65535
  hostIPC: true
  hostPID: true
  runAsUser:
    rule: 'RunAsAny'
  seLinux:
    rule: 'RunAsAny'
  supplementalGroups:
    rule: 'RunAsAny'
  fsGroup:
    rule: 'RunAsAny'



---

A related feature allows pods to bind to a port in the node's default namespace, but still have their own network namespace. This is done by using the hostPort property in one of the container's ports defined in the spec.containers.ports field.

Don't confuse pods using hostPort with pods exposed through a NodePort service. They're two different things, as explained in figure 13.2.

The first thing you'll notice in the figure is that when a pod is using a hostPort, a connection to the node's port is forwarded directly to the pod running on that node, whereas with a NodePort service, a connection to the node’s port is forwarded to a randomly selected pod (possibly on another node). The other difference is that with pods using a hostPort, the node’s port is only bound on nodes that run such pods, whereas NodePort services bind the port on all nodes, even on those that don’t run such a pod (as on node 3 in the figure).

It's important to understand that if a pod is using a specific host port, only one instance of the pod can be scheduled to each node, because two processes can't bind to the same host port. The Scheduler takes this into account when scheduling pods, so it doesn’t schedule multiple pods to the same node, as shown in figure 13.3. If you have three nodes and want to deploy four pod replicas, only three will be scheduled (one pod will remain Pending).

After you create this pod, you can access it through port 9000 of the node it's sched- uled to. If you have multiple nodes, you'll see you can’t access the pod through that port on the other nodes.

The hostPort feature is primarily used for exposing system services, which are deployed to every node using DaemonSets. Initially, people also used it to ensure two replicas of the same pod were never scheduled to the same node, but now you have a better way of achieving this—it's explained in chapter 16.

You can either map a port using HostPorts (which exposes a service on a specified port on a single node) or NodePorts (which exposes a service on all nodes on a single port).

MISC:

https://kubernetes.io/docs/concepts/configuration/overview/#services
Don’t specify a hostPort for a Pod unless it is absolutely necessary. When you bind a Pod to a hostPort, it limits the number of places the Pod can be scheduled, because each <hostIP, hostPort, protocol> combination must be unique. If you don’t specify the hostIP and protocol explicitly, Kubernetes will use 0.0.0.0 as the default hostIP and TCP as the default protocol.

If you explicitly need to expose a Pod’s port on the node, consider using a NodePort Service before resorting to hostPort.

Avoid using hostNetwork, for the same reasons as hostPort.

MISC2:
https://rancher.com/docs/rancher/v2.x/en/v1.6-migration/expose-services/#hostport
A HostPort is a port exposed to the public on a specific node running one or more pod. Traffic to the node and the exposed port (<HOST_IP>:<HOSTPORT>) are routed to the requested container’s private port. Using a HostPort for a Kubernetes pod in Rancher v2.x is synonymous with creating a public port mapping for a container in Rancher v1.6.

In the following diagram, a user is trying to access an instance of Nginx, which is running within a pod on port 80. However, the Nginx deployment is assigned a HostPort of 9890. The user can connect to this pod by browsing to its host IP address, followed by the HostPort in use (9890 in case).

HostPort Pros
*Any port available on the host can be exposed.
*Configuration is simple, and the HostPort is set directly in the Kubernetes pod specifications. Unlike NodePort, no other objects need to be created to expose your app.

HostPort Cons
*Limits the scheduling options for your pod, as only hosts with vacancies for your chosen port can be used.
*If the scale of your workload is larger than the number of nodes in your Kubernetes cluster, the deployment fails.
*Any two workloads that specify the same HostPort cannot be deployed to the same node.
*If the host where your pods are running becomes unavailable, Kubernetes reschedules the pods to different nodes. Thus, if the IP address for your workload changes, external clients of your application will lose access to the pod. The same thing happens when you restart your pods—Kubernetes reschedules them to a different node.
