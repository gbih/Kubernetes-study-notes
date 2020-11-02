# 7.4.2 Creating a ConfigMap

### Objective

### Notes
* The whole point of an app’s configuration is to keep the config options that vary between environments, or change frequently, separate from the application’s source code. We can do this with ConfigMaps.
* With ConfigMaps, we can move the configuration out of the pod description.
* Kubernetes allows separating configuration options into a separate object called a ConfigMap, which is a map containing key/value pairs with the values ranging from short literals to full config files.
* An application doesn’t need to read the ConfigMap directly or even know that it exists.
* The contents of the map are instead passed to containers as either environment variables or as files in a volume.
* ConfigMap keys must be a valid DNS subdomain (they may only contain alphanumeric characters, dashes, underscores, and dots). They may optionally include a leading dot.
* ConfigMaps usually contain more than one entry.
* In this simple example, we first create a map with a single key and use it to fill the INTERVAL environment variable.

apiVersion: v1
kind: List
items:
- apiVersion: v1
  kind: ConfigMap
  metadata:
    name: fortune-config
    namespace: chp07-set742
  data:
    sleep-interval: "23"
    location: Japan
