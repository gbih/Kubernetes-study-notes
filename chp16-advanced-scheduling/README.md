# Study Notes for Kubernetes In Action, v1
## Chapter 16

### Objectives
- Learn how to use node taints and pod tolerations
- Learn node affinity rules
- Learn how to co-locate pods via pod affinity
- Keep pods separate via pod anti-affinity

### SET UP

## Create a multi-node cluster in Multipass

- Use MicroK8s to turn VMs into Kubernetes worker nodes

- Confirm defaults to use for worker VMs

https://github.com/ubuntu/microk8s/blob/master/installer/common/definitions.py

```
# listed defaults

DEFAULT_CORES: int = 2
DEFAULT_MEMORY: int = 4
DEFAULT_DISK: int = 50
```

We can use a slightly smaller size for the worker nodes, such as 30G

```
multipass launch --name node1-vm --disk 30G --mem 4G
multipass shell node1-vm
sudo snap install microk8s --channel=1.18 --classic
sudo usermod -a -G microk8s ubuntu
sudo chown -f -R ubuntu ~/.kube
logout
multipass shell node1-vm
sudo microk8s.config > microk8s.yaml
sudo snap alias microk8s.kubectl kubectl

(sudo apt-get install iptables-persistent) ????

microk8s.enable dns metrics-server ingress storage metallb
* Possible bug: rbac seems to block metrics-server here
* Try installing either rbac or metrics manually.
* For now, we can get by through installing metrics-server first, then rbac later
microk8s status

cd /home/ubuntu
mkdir src

# Quick check
kubectl get nodes
NAME            STATUS   ROLES    AGE     VERSION
192.168.64.5    Ready    <none>   10h     v1.18.9
192.168.64.6    Ready    <none>   6h26m   v1.18.9
actionbook-vm   Ready    <none>   10d     v1.18.9


kubectl top nodes
NAME            CPU(cores)   CPU%   MEMORY(bytes)   MEMORY%
192.168.64.5    17m          1%     446Mi           11%
192.168.64.6    16m          1%     415Mi           10%
actionbook-vm   174m         17%    1408Mi          14%

```

- Repeat the above steps with 2-3x, with node2-vm, node3-vm, etc


## Create worker nodes
- Return to host 
logout

- Log into the node you want to be the control-plane
multipass shell actionbook-vm

microk8s add-node

You should see a token displayed in this format:
```
microk8s join 192.168.64.88:25000/tSttJctChpuZuXXxudINTJYkeviwiMjr
```

While logged into a workder-node, apply that command:
```
microk8s join 192.168.64.88:25000/tSttJctChpuZuXXxudINTJYkeviwiMjr
```

On the control-plane node, check to see the new worker node:
```
kubectl get nodes

# Should see output similar to:
NAME            STATUS     ROLES    AGE     VERSION
192.168.64.5    Ready    <none>   4h27m   v1.18.9
actionbook-vm   Ready    <none>   10d     v1.18.9
```

For each individual worker node, you need to generate a separate token on the master via the `microk8s add-node` command, and use that token in each individual worker node.

### Misc

#### Adding labels
- The `node1-vm`, `node2-vm` does not display as names in the control-plance, so it can be useful to use labels instead. The format is,
```
kubectl label node actionbook-vm name=actionbook-vm
kubectl label node 192.168.64.5 name=node1-vm
kubectl label node 192.168.64.6 name=node2-vm
```

which we can use in queries as in,
```
kubectl get nodes -l name=node1-vm
```

To delete a label, append `-` to the name
```
kubectl label nodes actionbook-vm gpu-
```

#### Adding Taints

- Add
```
kubectl taint nodes actionbook-vm key=value:NoSchedule
```

- Remove
```
kubectl taint nodes actionbook-vm key:NoSchedule-
```







