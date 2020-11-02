# 8.2.2 Talking to the API server from within a pod

### Objective

### Notes
* Having problems running `curl https://kubernetes`. This is maybe because the Service called kubernetes is automatically exposed in the default namespace and configured to point to the API server, however we are using a custom namespace (chp08-set822), and haven't set up an equivalent service (which seems to use ClusterIP?)

* Talking to the API server from within a pod
* Sometimes your app will need to know more about other pods and even other resources defined in your cluster. The Downward API doesn’t help in those cases.
Here we work through how to talk to the API server from within a pod, where you (usually) don’t have kubectl. Therefore, to talk to the API server from inside a pod, you need to take care of three things:
  1. Find the location of the API server.
  2. Make sure you’re talking to the API server and not something impersonating it.
  3. Authenticate with the server; otherwise it won’t let you see or do anything.

