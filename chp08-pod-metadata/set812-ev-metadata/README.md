# Chapter 8, Section 8.1.2

### Objective

### Notes
* https://kubernetes.io/docs/tasks/inject-data-application/downward-api-volume-expose-pod-information/

* The Kubernetes Downward API allows you to pass metadata about the pod and its environment through environment variables or files (in a downwardAPI volume).
* It is a way of having environment variables or files populated with values from the pod’s specification or status.
* The Downward API enables you to expose the pod’s own metadata to the processes running inside that pod. Currently, it allows you to pass the following information to your containers:
  * The pod’s name
  * The pod’s IP address
  * The namespace the pod belongs to
  * The name of the node the pod is running on
  * The name of the service account the pod is running under
  * The CPU and memory requests for each container
  * The CPU and memory limits for each container
  * The pod’s labels
  * The pod’s annotations

Here we work-out how to expose metadata through env vars in the pod manifest:

spec:
  containers:
  - env:
    # info available from downwardAPI volumes
    - name: POD_NAME
      valueFrom: # use to reference env vars, think valueFromEnvVar
        fieldRef: # use to reference env var field
          fieldPath: metadata.name # access via pod manifest
