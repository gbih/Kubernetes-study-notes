# Chapter 15, Section 15.1.5


### Notes

https://github.com/luksa/kubia-qps

https://medium.com/@marko.luksa/kubernetes-autoscaling-based-on-custom-metrics-without-using-a-host-port-b783ed6241ac

-------------------

https://v1-16.docs.kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/#support-for-custom-metrics

Support for custom metrics

Note: Kubernetes 1.2 added alpha support for scaling based on application-specific metrics using special annotations. Support for these annotations was removed in Kubernetes 1.6 in favor of the new autoscaling API. While the old method for collecting custom metrics is still available, these metrics will not be available for use by the Horizontal Pod Autoscaler, and the former annotations for specifying which custom metrics to scale on are no longer honored by the Horizontal Pod Autoscaler controller.

GB: So, this annotation-based method probably no longer works....

The original QPS (query-per-second) metric based on the pod has now evolved to the new per-pod custom metrics

https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/

https://github.com/kubernetes/community/blob/master/contributors/design-proposals/instrumentation/custom-metrics-api.md


