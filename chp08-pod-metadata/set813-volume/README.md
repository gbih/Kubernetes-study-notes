# Chapter 8, Section 8.1.3

### Objective

### Notes
* We can expose the metadata through files instead of environment variables by defining a downwardAPI volume and mount it into your container.

* You must use a downwardAPI volume for exposing the pod’s labels or its annotations, because neither can be exposed through environment variables.

* Each item specifies the path (the filename) where the metadata should be written to and references either a pod-level field or a container resource field whose value you want stored in the file.

* Instead of passing the metadata through environment variables, you’re defining a volume called downward and mounting it in your container under /etc/downward. The files this volume will contain are configured under the downwardAPI.items attribute in the volume specification.
