# Chapter 13, Section 13.21

### Objective

### Notes
SETUP NOTES:
* If we have
--enable-admission-plugins="PodSecurityPolicy" without "ServiceAccount", this will fail.

* If there is no no --enable-mission-plugins,
this will run.

Full plug-in setup:
--enable-admission-plugins="\
NamespaceLifecycle,\
LimitRanger,\
ServiceAccount,\
TaintNodesByCondition,\
Priority,\
DefaultTolerationSeconds,\
DefaultStorageClass,\
StorageObjectInUseProtection,\
PersistentVolumeClaimResize,\
MutatingAdmissionWebhook,\
ValidatingAdmissionWebhook,\
RuntimeClass,\
ResourceQuota,\
PodSecurityPolicy,\
NamespaceLifecycle,\
ServiceAccount\
"
---

To run a pod under a different user ID than the one that's baked into the container image, you’ll need to set the pod’s securityContext.runAsUser property. You’ll make the container run as user guest, whose user ID in the alpine container image is 405.

To see the effect of the runAsUser property, run the id command in this new pod.
