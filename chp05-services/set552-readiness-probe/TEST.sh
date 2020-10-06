#!/bin/bash
. ~/src/common/setup.sh
FULLPATH=$(pwd)

echo $HR_TOP

echo "kubectl apply -f $FULLPATH"
kubectl apply -f $FULLPATH
echo $HR

sleep 6

echo "POD1=\$(kubectl get pods -n=chp05-set552 -o jsonpath='{.items[0].metadata.name}')"
echo "POD2=\$(kubectl get pods -n=chp05-set552 -o jsonpath='{.items[1].metadata.name}')"
echo "POD3=\$(kubectl get pods -n=chp05-set552 -o jsonpath='{.items[2].metadata.name}')"

POD1=$(kubectl get pods -n=chp05-set552 -o jsonpath='{.items[0].metadata.name}')
POD2=$(kubectl get pods -n=chp05-set552 -o jsonpath='{.items[1].metadata.name}')
POD3=$(kubectl get pods -n=chp05-set552 -o jsonpath='{.items[2].metadata.name}')

echo $HR

echo "kubectl get event --field-selector=involvedObject.name=$POD1 --sort-by=.metadata.creationTimestamp -n=chp05-set552"
EVENT_POD1=$(kubectl get event --field-selector=involvedObject.name=$POD1 --sort-by=.metadata.creationTimestamp -n=chp05-set552)
echo "$EVENT_POD1"
echo ""

echo "kubectl get event --field-selector=involvedObject.name=$POD2 --sort-by=.metadata.creationTimestamp -n=chp05-set552"
kubectl get event --field-selector=involvedObject.name=$POD2 --sort-by=.metadata.creationTimestamp -n=chp05-set552
echo ""

echo "kubectl get event --field-selector=involvedObject.name=$POD3 --sort-by=.metadata.creationTimestamp -n=chp05-set552"
kubectl get event --field-selector=involvedObject.name=$POD3 --sort-by=.metadata.creationTimestamp -n=chp05-set552

echo $HR



echo "kubectl wait --for=condition=Initialized=True pod/$POD3 -n=chp05-set552 --timeout=30s"
kubectl wait --for=condition=Initialized=True pod/$POD3 -n=chp05-set552 --timeout=30s
echo $HR

echo "Status of pod $POD1"
kubectl get pods $POD1 -n=chp05-set552 -o custom-columns=\
INITIALIZED:..status.conditions['?(@.type=="Initialized")'].status,\
PODSCHEDULED:..status.conditions['?(@.type=="PodScheduled")'].status,\
READY:..status.conditions['?(@.type=="Ready")'].status,\
CONTAINERSREADY:..status.conditions['?(@.type=="ContainersReady")'].status
echo $HR


enter


echo "kubectl get all -n=chp05-set552"
kubectl get all -n=chp05-set552 --show-labels
echo ""
kubectl get endpoints kubia-nodeport -n=chp05-set552

echo $HR

echo "Deleting /var/ready from all pods"
kubectl exec $POD1 -n=chp05-set552 -- rm -fr /var/ready
kubectl exec $POD2 -n=chp05-set552 -- rm -fr /var/ready
kubectl exec $POD3 -n=chp05-set552 -- rm -fr /var/ready
echo $HR


echo "Wait for pod condition to be Ready=False"
kubectl wait --for=condition=Ready=False pod/$POD1 -n=chp05-set552 --timeout=30s
kubectl wait --for=condition=Ready=False pod/$POD2 -n=chp05-set552 --timeout=30s
kubectl wait --for=condition=Ready=False pod/$POD3 -n=chp05-set552 --timeout=30s
echo $HR


echo "1. Pods should fail their Readiness Probe (Running but not Ready)"
echo ""

echo "kubectl get pods -n=chp05-set552 --show-labels"
kubectl get pods -n=chp05-set552 --show-labels
echo ""
#echo "kubectl wait --for=condition=Running pods $POD1 -n=chp05-set552 --timeout=3s"
#kubectl wait --for=condition=Running pods $POD1 -n=chp05-set552 --timeout=3s

#echo "kubectl describe endpoints kubia-nodeport -n=chp05-set552"
#kubectl describe endpoints kubia-nodeport -n=chp05-set552

echo "kubectl get endpoints kubia-nodeport -n=chp05-set552"
kubectl get endpoints kubia-nodeport -n=chp05-set552

enter

echo "Make the readiness probe of pod $POD1 return success by creating the /var/ready file"
echo "kubectl exec kubia-g5cql -n=chp05-set552 -- touch /var/ready"
kubectl exec $POD1 -n=chp05-set552 -- touch /var/ready

echo "kubectl exec $POD1 -n=chp05-set552 -- ls -la /var/ready"
kubectl exec $POD1 -n=chp05-set552 -- ls -la /var/ready

echo $HR


echo "2. Pod $POD1 should now pass the Readiness Probe test"
echo ""

while [[ $(kubectl get pods $POD1 -n=chp05-set552 -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}') != "True" ]]
do
kubectl get pods $POD1 -n=chp05-set552 -o custom-columns=\
INITIALIZED:..status.conditions['?(@.type=="Initialized")'].status,\
PODSCHEDULED:..status.conditions['?(@.type=="PodScheduled")'].status,\
READY:..status.conditions['?(@.type=="Ready")'].status,\
CONTAINERSREADY:..status.conditions['?(@.type=="ContainersReady")'].status
 sleep 1.5
done

kubectl get pods $POD1 -n=chp05-set552 -o custom-columns=\
INITIALIZED:..status.conditions['?(@.type=="Initialized")'].status,\
PODSCHEDULED:..status.conditions['?(@.type=="PodScheduled")'].status,\
READY:..status.conditions['?(@.type=="Ready")'].status,\
CONTAINERSREADY:..status.conditions['?(@.type=="ContainersReady")'].status

echo $HR

echo "kubectl get pods $POD1 -n=chp05-set552 --show-labels"
kubectl get pods $POD1 -n=chp05-set552 --show-labels
echo ""
kubectl get endpoints kubia-nodeport -n=chp05-set552
echo $HR

echo "kubectl describe endpoints kubia-nodeport -n=chp05-set552"
kubectl describe endpoints kubia-nodeport -n=chp05-set552


enter


echo "curl the nodeport ip. Only pod $POD1 should be accessible."

NODEPORT_IP=$(kubectl get svc kubia-nodeport -n=chp05-set552 -o jsonpath={'.spec.clusterIP'})

curl http://$NODEPORT_IP
curl http://$NODEPORT_IP
curl http://$NODEPORT_IP
curl http://$NODEPORT_IP
curl http://$NODEPORT_IP

echo $HR

echo "Deleting /var/ready from all pods"
kubectl exec $POD1 -n=chp05-set552 -- rm -fr /var/ready
kubectl exec $POD2 -n=chp05-set552 -- rm -fr /var/ready
kubectl exec $POD3 -n=chp05-set552 -- rm -fr /var/ready

echo $HR

echo "kubectl get event --field-selector=involvedObject.name=$POD1 --sort-by=.metadata.creationTimestamp -n=chp05-set552"
kubectl get event --field-selector=involvedObject.name=$POD1 --sort-by=.metadata.creationTimestamp -n=chp05-set552
echo ""

echo "kubectl get event --field-selector=involvedObject.name=$POD2 --sort-by=.metadata.creationTimestamp -n=chp05-set552"
kubectl get event --field-selector=involvedObject.name=$POD2 --sort-by=.metadata.creationTimestamp -n=chp05-set552
echo ""

echo "kubectl get event --field-selector=involvedObject.name=$POD3 --sort-by=.metadata.creationTimestamp -n=chp05-set552"
kubectl get event --field-selector=involvedObject.name=$POD3 --sort-by=.metadata.creationTimestamp -n=chp05-set552

enter


echo "curl the nodeport ip again. None of the pods should be accessible."

NODEPORT_IP=$(kubectl get svc kubia-nodeport -n=chp05-set552 -o jsonpath={'.spec.clusterIP'})

curl http://$NODEPORT_IP
curl http://$NODEPORT_IP
curl http://$NODEPORT_IP
curl http://$NODEPORT_IP
curl http://$NODEPORT_IP

echo $HR

echo "kubectl delete -f $FULLPATH"
kubectl delete -f $FULLPATH


# To keep formating of $EVENT_POD1, use "" quotes.
# echo line is parsed by the shell (after variable expansion), and all spaces chars between parameters are reduced to a simple space.

