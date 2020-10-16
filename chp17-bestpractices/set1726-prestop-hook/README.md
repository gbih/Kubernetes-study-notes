17.2.4c Pre-stop hook

https://kubernetes.io/docs/tasks/configure-pod-container/attach-handler-lifecycle-event/

Kubernetes only sends the preStop event when a Pod is terminated. This means that the preStop hook is not invoked when the Pod is completed. 

