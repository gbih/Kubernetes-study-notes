# Study Notes for Kubernetes In Action, v1
## Chapter 12

### Objectives
- Work through securing the API server via RBAC, ServiceAccounts, Roles, RoleBindings

### Setup Notes
- RBAC
Need to enable RBAC on microk8s
microk8s enable rbac
microk8s status




- Admission plugins that should be enabled in addition to default enabled ones 

 /var/snap/microk8s/current/args/kube-apiserver

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
NamespaceLifecycle\
"

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
PodSecurityPolicy



