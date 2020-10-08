cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Namespace
metadata: 
  name: demo
---
apiVersion: v1
kind: Pod
metadata:
  name: kubia-manual
  namespace: demo
  labels:
    creation_method: manual
spec:
  containers:
  - image: georgebaptista/kubia
    name: kubia
    ports:
    - containerPort: 8080
      protocol: TCP
EOF

echo ""

echo "the Pod has been scheduled to a node"
echo "kubectl wait --for=condition=PodScheduled pod/kubia-manual -n=demo --timeout=10s"
kubectl wait --for=condition=PodScheduled pod/kubia-manual -n=demo --timeout=10s
echo ""

echo "all containers in the Pod are ready"
echo "kubectl wait --for=condition=ContainersReady pod/kubia-manual -n=demo --timeout=10s"
kubectl wait --for=condition=ContainersReady pod/kubia-manual -n=demo --timeout=10s
echo ""

echo "all init containers have started successfully"
echo "kubectl wait --for=condition=Initialized pod/kubia-manual -n=demo --timeout=10s"
kubectl wait --for=condition=Initialized pod/kubia-manual -n=demo --timeout=10s
echo ""

echo "the Pod is able to serve requests and should be added to the load balancing pools of all matching Services"
echo "kubectl wait --for=condition=Ready pod/kubia-manual -n=demo --timeout=10s"
kubectl wait --for=condition=Ready pod/kubia-manual -n=demo --timeout=10s
echo ""

sleep 3

echo "kubectl delete ns demo"
kubectl delete ns demo
