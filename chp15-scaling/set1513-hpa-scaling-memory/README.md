# Chapter 12, Section 12.2

### Objective

### Notes
- Need to make sure RBAC is enabled in your cluster.

- With microk8s, we enable this via:
```
microk8s status
microk8s enable rbac
microk8s status
``` 

This will essentially block scripts from chapter 1-11 from working, however.
To disable rbac so we can again run these earlier scripts, run:
```
microk8s disable rbac
```

- Check admission plugins that should be enabled in addition to default enabled ones 

vi /var/snap/microk8s/current/args/kube-apiserver

```
--cert-dir=${SNAP_DATA}/certs
--service-cluster-ip-range=10.152.183.0/24
--authorization-mode=RBAC,Node
--basic-auth-file=${SNAP_DATA}/credentials/basic_auth.csv
--service-account-key-file=${SNAP_DATA}/certs/serviceaccount.key
--client-ca-file=${SNAP_DATA}/certs/ca.crt
--tls-cert-file=${SNAP_DATA}/certs/server.crt
--tls-private-key-file=${SNAP_DATA}/certs/server.key
--kubelet-client-certificate=${SNAP_DATA}/certs/server.crt
--kubelet-client-key=${SNAP_DATA}/certs/server.key
--secure-port=16443
--token-auth-file=${SNAP_DATA}/credentials/known_tokens.csv
--token-auth-file=${SNAP_DATA}/credentials/known_tokens.csv
--etcd-servers='https://127.0.0.1:12379'
--etcd-cafile=${SNAP_DATA}/certs/ca.crt
--etcd-certfile=${SNAP_DATA}/certs/server.crt
--etcd-keyfile=${SNAP_DATA}/certs/server.key
--insecure-port=0

# Enable the aggregation layer
--requestheader-client-ca-file=${SNAP_DATA}/certs/front-proxy-ca.crt
--requestheader-allowed-names=front-proxy-client
--requestheader-extra-headers-prefix=X-Remote-Extra-
--requestheader-group-headers=X-Remote-Group
--requestheader-username-headers=X-Remote-User
--proxy-client-cert-file=${SNAP_DATA}/certs/front-proxy-client.crt
--proxy-client-key-file=${SNAP_DATA}/certs/front-proxy-client.key
#~Enable the aggregation layer
```


- Sample configuration:
```
...
--insecure-port=0


# custom-setting
--allow-privileged

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
NamespaceLifecycle"

#PodSecurityPolicy,\


# Enable the aggregation layer
...
```
