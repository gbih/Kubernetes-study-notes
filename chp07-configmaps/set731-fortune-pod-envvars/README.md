# 7.3.1 Specifying environment variables in a container definition

### Objective

### Notes
* Containerized applications often use environment variables as a source of configuration options.

* Like the container's command and arguments, the list of environment variables also cannot be updated after the pod is created.

* In each container, Kubernetes also automatically exposes environment variables for each service in the same namespace. These environment variables are basically auto-injected configuration.

* Having values effectively hardcoded in the pod definition means you need to have separate pod definitions for your production and your development pods. To enable a more decoupled configuration, we can use the ConfigMap resource.

* Use this setting to set the env var inside the container definition:

  containers:
  - image: georgebaptista/fortune:env
    env:
    - name: INTERVAL
      value: "1"


