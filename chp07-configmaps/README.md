# Study Notes for Kubernetes In Action, v1
## Chapter 7

### Objectives
- Work through ConfigMaps and Secrets

### Notes
- Passing configuration options to app running in K8s is critical.

- Baking the configuration into the containerized app is a very bad option, for both work-flow and security reasons.

- The K8s resource for storing configuration data is called a ConfigMap.

- ConfigMap makes it easier to configure containerized apps via:
  1. Passing cmd-line arguments to containers
  2. Setting customer env vars for each container
  3. Mounting config file into containers through a special volume type.

- K8s offers another type of first-class cofiguration object called Secret.

