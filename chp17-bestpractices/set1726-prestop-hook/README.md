# 17.2.4c Tests for Section 17.6 pre-stop hook

### Notes

https://kubernetes.io/docs/tasks/configure-pod-container/attach-handler-lifecycle-event/

Kubernetes only sends the preStop event when a Pod is terminated. This means that the preStop hook is not invoked when the Pod is completed. 

