# 17.2.4b USING A POST-START CONTAINER LIFECYCLE HOOK

Selected material from:
https://kubernetes.io/docs/tasks/configure-pod-container/attach-handler-lifecycle-event/

> Attach Handlers to Container Lifecycle Events
> This page shows how to attach handlers to Container lifecycle events. Kubernetes supports the postStart and preStop events. Kubernetes sends the postStart event immediately after a Container is started, and it sends the preStop event immediately before the Container is terminated.

```
# Create the Pod:
kubectl apply -f https://k8s.io/examples/pods/lifecycle-events.yaml

# Verify that the Container in the Pod is running:
kubectl get pod lifecycle-demo

# Get a shell into the Container running in your Pod:
kubectl exec -it lifecycle-demo -- /bin/bash

# In your shell, verify that the postStart handler created the message file:
root@lifecycle-demo:/# cat /usr/share/message

# The output shows the text written by the postStart handler:
Hello from the postStart handler
```

> Discussion

> Kubernetes sends the postStart event immediately after the Container is created. There is no guarantee, however, that the postStart handler is called before the Container's entrypoint is called. The postStart handler runs asynchronously relative to the Container's code, but Kubernetes' management of the container blocks until the postStart handler completes. The Container's status is not set to RUNNING until the postStart handler completes.

> Kubernetes sends the preStop event immediately before the Container is terminated. Kubernetes' management of the Container blocks until the preStop handler completes, unless the Pod's grace period expires. For more details, see Pod Lifecycle.

> Note: Kubernetes only sends the preStop event when a Pod is terminated. This means that the preStop hook is not invoked when the Pod is completed. 
