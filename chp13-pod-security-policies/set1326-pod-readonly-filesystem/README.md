# 13.2.6 Preventing processes from writing to the container's filesystem

### Notes
Preventing processes from writing to the container's filesystem

GB: If we are using PodSecurityPolicy, then maybe we really don't need the pod/container-level securityContext mechanism???

You may want to prevent the processes running in the container from writing to the container's filesystem, and only allow them to write to mounted volumes. You'd want to do that mostly for security reasons.
Let's imagine you're running a PHP application with a hidden vulnerability, allowing an attacker to write to the filesystem. The PHP files are added to the container image at build time and are served from the container’s filesystem. Because of the vulnerability, the attacker can modify those files and inject them with malicious code.

These types of attacks can be thwarted by preventing the container from writing to its filesystem, where the app's executable code is normally stored. This is done by setting the container's securityContext.readOnlyRootFilesystem property to true.

