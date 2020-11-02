# 13.2.3 Running pods in privileged mode

### Objective

### Setup
To allows priviledge mode in microk8s, use this cluster-configuration:

1. Add --allow-privileged /var/snap/microk8s/current/args/kube-apiserver
2. microk8s.stop
3. microk8s.start


### Notes
Running pods in privileged mode

Sometimes pods need to do everything that the node they're running on can do, such as use protected system devices or other kernel features, which aren't accessible to regular containers.

An example of such a pod is the kube-proxy pod, which needs to modify the node's iptables rules to make services work, as was explained in chapter 11. If you follow the instructions in appendix B and deploy a cluster with kubeadm, you'll see every cluster node runs a kube-proxy pod and you can examine its YAML specification to see all the special features it's using.

To get full access to the node's kernel, the pod's container runs in privileged mode. This is achieved by setting the privileged property in the container's securityContext property to true. You’ll create a privileged pod from the YAML in the following listing.

If you're familiar with Linux, you may know it has a special file directory called /dev, which contains device files for all the devices on the system. These aren't regular files on disk, but are special files used to communicate with devices. Let's see what devices are visible in the non-privileged container you deployed earlier (the pod-with-defaults pod), by listing files in its /dev directory

