#!/bin/bash
. ~/src/COMMON/SETUP.sh
FULLPATH=$(pwd)

echo $HR_TOP

echo "kubectl apply -f $FULLPATH/set511-0-ns.yaml"
kubectl apply -f $FULLPATH/set511-0-ns.yaml

echo $HR

echo "kubectl apply -f $FULLPATH"
kubectl apply -f $FULLPATH
sleep 3

echo $HR
#clear

value=$(<set511-1-rs.yaml)
echo "$value"

enter

value=$(<set511-2-svc.yaml)
echo "$value"

enter

echo "kubectl get all -o wide -n=chp05-set511"
kubectl get all -o wide -n=chp05-set511

enter

echo "POD0=\$(kubectl get pod -n=chp05-set511 -o jsonpath={'.items[0].metadata.name'})"
echo "POD1=\$(kubectl get pod -n=chp05-set511 -o jsonpath={'.items[1].metadata.name'})"
echo "POD2=\$(kubectl get pod -n=chp05-set511 -o jsonpath={'.items[2].metadata.name'})"

POD0=$(kubectl get pod -n=chp05-set511 -o jsonpath={'.items[0].metadata.name'})
POD1=$(kubectl get pod -n=chp05-set511 -o jsonpath={'.items[1].metadata.name'})
POD2=$(kubectl get pod -n=chp05-set511 -o jsonpath={'.items[2].metadata.name'})

echo "kubectl wait --for=condition=Ready=True pod/$POD0 -n=chp05-set511 --timeout 20s"
echo "kubectl wait --for=condition=Ready=True pod/$POD1 -n=chp05-set511 --timeout 20s"
echo "kubectl wait --for=condition=Ready=True pod/$POD2 -n=chp05-set511 --timeout 20s"

kubectl wait --for=condition=Ready=True pod/$POD0 -n=chp05-set511 --timeout 20s
kubectl wait --for=condition=Ready=True pod/$POD1 -n=chp05-set511 --timeout 20s
kubectl wait --for=condition=Ready=True pod/$POD2 -n=chp05-set511 --timeout 20s

echo $HR

echo "kubectl get all -n=chp05-set511 --sort-by=..metadata.name --show-labels"
kubectl get all -n=chp05-set511 --sort-by=..metadata.name --show-labels
echo ""

echo "kubectl get endpoints -n=chp05-set511"
kubectl get endpoints -n=chp05-set511 -o wide

enter

echo "Directly accessing pod-1 via its podIP, with containerPort 8080"
echo "POD0_PODIP=$(kubectl get pods/$POD0 -n=chp05-set511 -o jsonpath={'.status.podIP'})"
POD0_PODIP=$(kubectl get pods/$POD0 -n=chp05-set511 -o jsonpath={'.status.podIP'})
echo "curl http://$POD0_PODIP:8080"
curl http://$POD0_PODIP:8080

echo $HR

echo "Testing service via curl on Service IP"

TEST_CLUSTER_IP=$(kubectl get svc -n=chp05-set511 -o=jsonpath={'.items[0].spec.clusterIP'})
echo "curl http://$TEST_CLUSTER_IP"
curl http://$TEST_CLUSTER_IP
#echo ""

echo $HR

echo "Testing Service IP via kubectl exec command inside an existing pod"
TEST_POD_NAME=$(kubectl get pods -n=chp05-set511 -o=jsonpath={'.items[0].metadata.name'})
echo "kubectl exec -it $TEST_POD_NAME -n=chp05-set511 -- curl -s http://$TEST_CLUSTER_IP"
kubectl exec -it $TEST_POD_NAME -n=chp05-set511 -- curl -s http://$TEST_CLUSTER_IP

echo $HR

echo "kubectl label pod $POD0 -n=chp05-set511 app=none --overwrite"
echo "kubectl label pod $POD2 -n=chp05-set511 app=none --overwrite"
kubectl label pod $POD0 -n=chp05-set511 app=none --overwrite
kubectl label pod $POD2 -n=chp05-set511 app=none --overwrite
sleep 6
echo ""

kubectl get pod -n=chp05-set511 --sort-by=.metadata.creationTimestamp -o custom-columns=\
NAME:.metadata.name,\
PORT:..spec.containers[].ports[].containerPort,\
APP:.metadata.labels.app,\
STATUS:.status.phase,\
READY:.status.containerStatuses[].ready,\
PODIP:.status.podIP,\
TIMESTAMP:.metadata.creationTimestamp

echo ""

echo "kubectl get endpoints -n=chp05-set511"
kubectl get endpoints -n=chp05-set511 -o wide

enter

echo "kubectl -n kube-system logs $POD0 -n=chp05-set511"
kubectl -n kube-system logs $POD0 -n=chp05-set511
kubectl -n=chp05-set511 logs $POD0
echo $HR

echo "Each Kubernetes Service belongs to a namespace and gets a corresponding DNS address that has the namespace in the form of,"
echo "<service-name>.<namespace-name>.svc.cluster.local"
echo "So the namespace name is in the URI of every Service belonging to the given namespace."
echo ""

echo "Check the name of the service:"
echo "kubectl get services -n=chp05-set511"
kubectl get services -n=chp05-set511
echo ""

echo "kubectl exec -n=chp05-set511 -it $POD0 -- sh -c 'curl kubia.chp05-set511.svc.cluster.local'"
kubectl exec -n=chp05-set511 -it $POD0 -- sh -c 'curl kubia.chp05-set511.svc.cluster.local'
echo ""


echo "kubectl exec -n=chp05-set511 -it $POD1 -- sh -c 'curl kubia.chp05-set511.svc.cluster.local'"
kubectl exec -n=chp05-set511 -it $POD1 -- sh -c 'curl kubia.chp05-set511.svc.cluster.local'

echo $HR

echo "kubectl delete -f $FULLPATH"
kubectl delete -f $FULLPATH
