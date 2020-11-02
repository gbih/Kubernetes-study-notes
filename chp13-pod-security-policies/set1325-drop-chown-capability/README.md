# 13.2.5 Dropping capabilities from a container

### Notes
Dropping capabilities from a container

You've seen how to add capabilities, but you can also drop capabilities that may otherwise be available to the container. For example, the default capabilities given to a container include the CAP_CHOWN capability, which allows processes to change the ownership of files in the filesystem.

To prevent the container from doing that, you need to drop the capability by listing it under the container's securityContext.capabilities.drop property

By dropping the CHOWN capability, you're not allowed to change the owner of the /tmp directory in a pod.

