# Chapter 7, Section 7.5.6

### Objective

### Notes
Create a docker-registry Secret and use it to pull images from a private image registry.

To run a pod, which uses an image from the private repository, you need to do two things:
  1. Create a Secret holding the credentials for the Docker registry.
  2. Reference that Secret in the imagePullSecrets field of the pod manifest.

This enables pulling images from a private image registry:
```
apiVersion: v1
kind: Pod
metadata:
  name: private-pod
  namespace: chp07-set756
spec:
  imagePullSecrets:
  - name: mydockerhubsecret
  containers:
  - image: georgebaptista/mykubia:private
    name: kubia
    imagePullPolicy: Always
```

We also need to make sure `imagePullPolicy` is marked `Always`, to prevent any cached copies from being pulled without proper authentication.
