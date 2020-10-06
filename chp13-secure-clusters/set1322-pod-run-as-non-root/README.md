# Chapter 13, Section 13.22

### Objective

### Notes
Preventing a container from running as root

What if you don't care what user the container runs as, but you still want to prevent it from running as root?

Imagine having a pod deployed with a container image that was built with a USER daemon directive in the Dockerfile, which makes the container run under the daemon user. What if an attacker gets access to your image registry and pushes a different image under the same tag? The attacker's image is configured to run as the root user. When Kubernetes schedules a new instance of your pod, the Kubelet will download the attacker’s image and run whatever code they put into it.

Although containers are mostly isolated from the host system, running their pro- cesses as root is still considered a bad practice. For example, when a host directory is mounted into the container, if the process running in the container is running as root, it has full access to the mounted directory, whereas if it's running as non-root, it won’t.

To prevent the attack scenario described previously, you can specify that the pod's container needs to run as a non-root user
