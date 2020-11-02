# 13.2.4 Adding individual kernel capabilities to a container

### Notes

Adding individual kernel capabilities to a container

In the previous section, you saw one way of giving a container unlimited power. In the old days, traditional UNIX implementations only distinguished between privileged and unprivileged processes, but for many years, Linux has supported a much more fine-grained permission system through kernel capabilities.

Instead of making a container privileged and giving it unlimited permissions, a much safer method (from a security perspective) is to give it access only to the kernel features it really requires. Kubernetes allows you to add capabilities to each container or drop part of them, which allows you to fine-tune the container's permissions and limit the impact of a potential intrusion by an attacker.

For example, a container usually isn't allowed to change the system time (the hardware clock's time). You can confirm this by trying to set the time in your pod-with- defaults pod.

If you want to allow the container to change the system time, you can add a capability called CAP_SYS_TIME to the container's capabilities list, as shown in the following listing.

Adding capabilities like this is a much better way than giving a container full privileges with privileged: true. Admittedly, it does require you to know and understand what each capability does.

You'll find the list of Linux kernel capabilities in the Linux man pages.
