PodSecurityPolicy is a cluster-level (non-namespaced) resource, which defines what security-related features users can or can't use in their pods. The job of upholding the policies configured in PodSecurityPolicy resources is performed by the PodSecurityPolicy admission control plugin running in the API server.

When someone posts a pod resource to the API server, the PodSecurityPolicy admission control plugin validates the pod definition against the configured PodSecurityPolicies. If the pod conforms to the cluster's policies, it's accepted and stored into etcd; otherwise it’s rejected immediately. The plugin may also modify the pod resource according to defaults configured in the policy.

UNDERSTANDING WHAT A PODSECURITYPOLICY CAN DO
A PodSecurityPolicy resource defines things like the following:
* Whether a pod can use the host's IPC, PID, or Network namespaces
* Which host ports a pod can bind to
* What user IDs a container can run as
* Whether a pod with privileged containers can be created
* Which kernel capabilities are allowed, which are added by default and which are always dropped
* What SELinux labels a container can use
* Whether a container can use a writable root filesystem or not
* Which filesystem groups the container can run as
* Which volume types a pod can use

NOTES FOR PLUGINS:
The PodSecurityPolicy admission control plugin may not be enabled in your cluster.

Enabling PodSecurityPolicy admission control in microk8s
https://gist.github.com/antonfisher/d4cb83ff204b196058d79f513fd135a6

To run multik8s with the PodSecurityPolicy plugsin enabled,
sudo vim /var/snap/microk8s/current/args/kube-apiserver

Add PodSecurityPolicy to the admission plugins:
--enable-admission-plugins="NamespaceLifecycle,LimitRanger,ServiceAccount,DefaultStorageClass,DefaultTolerationSeconds,MutatingAdmissionWebhook,ValidatingAdmissionWebhook,ResourceQuota,PodSecurityPolicy,ServiceAccount"

Then,
microk8s.stop
microk8s.start
