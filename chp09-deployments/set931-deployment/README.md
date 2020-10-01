# Chapter 9, Section 9.3.1

### Objective

### Notes
Using Deployments for updating apps declaratively.

* A Deployment is a higher-level resource meant for deploying applications and updating them declaratively, instead of doing it through a ReplicationController or a ReplicaSet, which are both considered lower-level concepts.
* When you create a Deployment, a ReplicaSet resource is created underneath.
* When updating the app, you need to introduce an additional ReplicationController and coordinate the two controllers to dance around each other without stepping on each other’s toes. You need something coordinating this dance. A Deployment resource takes care of that (it’s not the Deployment resource itself, but the controller process running in the Kubernetes control plane that does that).
* Using a Deployment instead of the lower-level constructs makes updating an app much easier, because you’re defining the desired state through the single Deployment resource and letting Kubernetes take care of the rest.
* A Deployment creates multiple ReplicaSets, one for each version of the pod template.
* Using the hash value of the pod template allows the Deployment to always use the same ReplicaSet for a given version of the pod template.
* During a deployment, an additional ReplicaSet is created and scaled up slowly, while the previous ReplicaSet is scaled down to zero.

