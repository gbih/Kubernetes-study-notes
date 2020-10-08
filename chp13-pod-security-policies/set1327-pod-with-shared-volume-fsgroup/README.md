Sharing volumes when containers run as different users

In chapter 6, we explained how volumes are used to share data between the pod's containers. You had no trouble writing files in one container and reading them in the other.

But this was only because both containers were running as root, giving them full access to all the files in the volume. Now imagine using the runAsUser option we explained earlier. You may need to run the two containers as two different users (perhaps you're using two third-party container images, where each one runs its process under its own specific user). If those two containers use a volume to share files, they may not necessarily be able to read or write files of one another.

That's why Kubernetes allows you to specify supplemental groups for all the pods running in the container, allowing them to share files, regardless of the user IDs they’re running as. This is done using the following two properties:
* fsGroup
* supplementalGroups

What they do is best explained in an example, so let's see how to use them in a pod and then see what their effect is. The next listing describes a pod with two containers sharing the same volume.
