# Study Notes for Kubernetes In Action, v1
## Chapter 11

### Objectives
- Explore Kubernetes internals
- Use etcdctl and etcd
- Understand each component and its role
- Understand networking between pods

## etcd / etcdctl Notes

## Install and Setup

Microk8s 1.18 is the last version to use and etcd and etcdctl (1.19 uses dqlite), so confirm you are using MicroK8s 1.18
```bash
snap info microk8s
```

The installed version is indicated on this line:
```
installed:   v1.18.9   (1702) 199MB classic
```

etcdctl should be pre-installed at /snap/microk8s/current/etcdctl
```bash
/snap/microk8s/current/etcdctl version
```

Create alias:
```bash
echo 'alias etcdctl="/snap/microk8s/current/etcdctl"' >>~/.bashrc
```

Force read and execution of ~/.bashrc:
```bash
source ~/.bashrc
```

---


## etcdctl Examples


Lists all members in the cluster:
```bash
etcdctl --endpoints=http://127.0.0.1:2380 member list
```



Show list of keys stored under /registry
```bash
etcdctl --endpoints=http://127.0.0.1:2380 get /registry --prefix --keys-only=true | grep '/registry'
```

Show list of keys and values in /registry/namespaces/default:
```bash
etcdctl --endpoints=http://127.0.0.1:2380 get /registry/namespaces/default --prefix --keys-only=false -w=json
```

Show list of keys and values using Python script json.tool in pretty-print format:
```bash
etcdctl --endpoints=http://127.0.0.1:2380 get /registry/namespaces/default --prefix --keys-only=false -w=json | python3 -m json.tool
```


Show list of keys stored under /registry/apiregistration.k8s.io/apiservices/v1.apiextensions.k8s.io
```bash
etcdctl --endpoints=http://127.0.0.1:2380 get /registry/apiregistration.k8s.io/apiservices/  --prefix --keys-only=true | grep '/registry'
```



```bash
etcdctl --endpoints=http://127.0.0.1:2380 get /registry/apiregistration.k8s.io/apiservices/v1.apiextensions.k8s.io --prefix | grep '"kind":"APIService"' | python3 -m json.tool
```


Defragments the storage of the etcd members with given endpoints
```bash
etcdctl --endpoints=http://127.0.0.1:2380 defrag
```


Check the performance of the etcd cluster
```bash
etcdctl --endpoints=http://127.0.0.1:2380 check perf
```


Prints the KV history hash for each endpoint in --endpoints
```bash
etcdctl --endpoints=http://127.0.0.1:2380 endpoint hashkv
```


Checks the healthiness of endpoints specified in `--endpoints` flag
```bash
etcdctl --endpoints=http://127.0.0.1:2380 endpoint health
```


Prints out the status of endpoints specified in `--endpoints` flag
```bash
etcdctl --endpoints=http://127.0.0.1:2380 endpoint status
```


Stores an etcd node backend snapshot to a given file
```bash
etcdctl --endpoints=http://127.0.0.1:2380 snapshot save ~/etcd-backup.db
```

---

## Reference: Reverting from MicroK8s v1.19 to v1.18

If you are using MicroK8s v1.19 and want to revert to v1.18 to use etcd and etcdctl, you can revert back via

```bash
sudo snap remove microk8s --purge
sudo snap install microk8s --classic --channel=1.18/stable
```

You will also have to re-configure the microk8s add-ons:
```bash
microk8s status
microk8s enable dns ingress metallb storage 
```

Check snap.microk8s.daemon-etcd is among running services:
```bash
microk8s.inspect
sudo journalctl -u snap.microk8s.daemon-etcd
```

Check output from etcd
```bash
/snap/microk8s/current/etcd
```

You Should see a log entry resembling something like this:
```bash
2020-10-04 17:57:43.335106 C | etcdmain: listen tcp 127.0.0.1:2380: bind: address already in use
```

