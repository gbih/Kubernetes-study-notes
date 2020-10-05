#!/bin/bash 
# -li is used to simulate an interactive login shell, needed for expanding aliases 
. ~/src/SETUP.sh
FULLPATH=$(pwd)
echo $HR_TOP

shopt -s expand_aliases
source ~/.bashrc

echo "kubectl apply -f $FULLPATH"
kubectl apply -f $FULLPATH
echo $HR_TOP
sleep 2


echo "kubectl rollout status deployment kubia -n=chp11-set1112"
kubectl rollout status deployment kubia -n=chp11-set1112
echo ""



echo "Check kubectl version"
echo "kubectl version --short"
kubectl version --short

echo $HR

echo "Check Control Plane components"
echo "kubectl get cs"
#kubectl get componentstatuses
kubectl get cs

echo $HR

echo "Kubernetes components running as pods"
echo "kubectl get pods -o custom-columns=POD:metadata.name,NODE:spec.nodeName --sort-by spec.nodeName -n=kube-system"
kubectl get pods -o custom-columns=POD:metadata.name,NODE:spec.nodeName --sort-by spec.nodeName -n=kube-system

echo $HR

enter


echo "List all members in the cluster via etcdctl"
echo ""

echo "etcdctl --endpoints=http://127.0.0.1:2380 member list"
etcdctl --endpoints=http://127.0.0.1:2380 member list
echo $HR


echo "Same query, but in different format"
echo "Output in JSON format via -w=json, and pretty-print by piping to 'python3 -m json.tool'"
echo ""
echo "etcdctl --endpoints=http://127.0.0.1:2380 member list -w=json | python3 -m json.tool"
etcdctl --endpoints=http://127.0.0.1:2380 member list -w=json | python3 -m json.tool


enter

echo "Kubernetes stores all its data in etcd under /registry"
echo "List all keys stored under /registry"
echo "Need to remove empty lines. We have 3 ways: piping to awk 'NF', or sed '/^\s*$/d', or grep '/registry'"
echo ""
echo "etcdctl --endpoints=http://127.0.0.1:2380 get /registry --prefix --keys-only | awk 'NF'"
etcdctl --endpoints=http://127.0.0.1:2380 get /registry --prefix --keys-only | awk 'NF'
echo $HR

enter

echo "Show entries in the /registry/pods directory"
echo ""
echo "etcdctl --endpoints=http://127.0.0.1:2380 get /registry/pods --prefix --keys-only | awk 'NF'"
etcdctl --endpoints=http://127.0.0.1:2380 get /registry/pods --prefix --keys-only | awk 'NF'
echo $HR

enter

echo "Show entries in the /registry/pods/chp11-set1112 directory"
echo ""
echo "etcdctl --endpoints=http://127.0.0.1:2380 get /registry/pods/chp11-set1112/ --prefix --keys-only | awk 'NF'"
etcdctl --endpoints=http://127.0.0.1:2380 get /registry/pods/chp11-set1112/ --prefix --keys-only | awk 'NF'
echo $HR

enter

echo "Show entries in the /registry/deployments/chp11-set1112/ directory"
echo ""
echo "etcdctl --endpoints=http://127.0.0.1:2380 get /registry/deployments/chp11-set1112 --prefix --keys-only | awk 'NF'"
etcdctl --endpoints=http://127.0.0.1:2380 get /registry/deployments/chp11-set1112 --prefix --keys-only | awk 'NF'
echo $HR

enter

echo "Show etcd entry representing a deployment in /registry/deployments/chp11-set1112"
echo "Output in JSON format via -w=json, and pretty-print by piping to 'python3 -m json.tool'"
echo ""
echo "etcdctl --endpoints=http://127.0.0.1:2380 get /registry/deployments/chp11-set1112 --prefix --keys-only=false -w=json | python3 -m json.tool"
etcdctl --endpoints=http://127.0.0.1:2380 get /registry/deployments/chp11-set1112 --prefix --keys-only=false -w=json | python3 -m json.tool
echo $HR

#echo "kubectl delete -f $FULLPATH"
#kubectl delete -f $FULLPATH
