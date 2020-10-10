#!/bin/bash
. ~/src/common/setup.sh
FULLPATH=$(pwd)
echo "14.5.4 Specifying quotas for specific pod states and/or QoS classes"
echo $HR_TOP

kubectl apply -f $FULLPATH/set1454-0-ns.yaml
kubectl apply -f $FULLPATH/set1454-1-quota-scoped.yaml
kubectl apply -f $FULLPATH/set1454-1-sa.yaml
kubectl apply -f $FULLPATH/set1454-2-psp-privileged.yaml
kubectl apply -f $FULLPATH/set1454-3-psp-restricted.yaml
kubectl apply -f $FULLPATH/set1454-4-role-rolebinding.yaml

kubectl apply -f $FULLPATH/set1454-7-pod-privileged.yaml # this should be rejected
kubectl apply -f $FULLPATH/set1454-8-pod-restrictive.yaml

echo "kubectl wait --for=condition=Ready=True pods/curl-restrictive -n=chp14-set1454 --timeout=10s"
kubectl wait --for=condition=Ready=True pods/curl-restrictive -n=chp14-set1454 --timeout=10s
echo ""

kubectl apply -f $FULLPATH/set1454-5-deployment.yaml
kubectl apply -f $FULLPATH/set1454-6-rc.yaml

enter

value=$(<set1454-1-quota-scoped.yaml)
echo "$value"

enter

echo "Note: Need timeout flag or this will hang"
echo ""
echo "kubectl rollout status deployment kubia-deploy -n=chp14-set1454 --timeout=10s"
kubectl rollout status deployment kubia-deploy -n=chp14-set1454 --timeout=10s

echo $HR

echo "Check for ReplicationController replicas:"

EXPECTED_REPLICAS=$(kubectl get replicationcontroller/kubia-rc -n=chp14-set1454 -o jsonpath={.status.fullyLabeledReplicas})
echo "EXPECTED_REPLICAS: $EXPECTED_REPLICAS"

READY_REPLICAS=$(kubectl get replicationcontroller/kubia-rc -n=chp14-set1454 -o jsonpath={.status.readyReplicas})
echo "READY_REPLICAS: $READY_REPLICAS"
echo ""

while [[ $EXPECTED_REPLICAS != $READY_REPLICAS ]]
do
kubectl get replicationcontroller/kubia-rc -n=chp14-set1454 -o custom-columns=READY_REPLICAS:..status.readyReplicas
  sleep 1.5
  READY_REPLICAS=$(kubectl get replicationcontroller/kubia-rc -n=chp14-set1454 -o jsonpath={.status.readyReplicas})
done

echo $HR



echo "kubectl get all -n=chp14-set1454"
kubectl get all -n=chp14-set1454

enter

echo "Check resourcequota"
echo ""
echo "kubectl describe resourcequota/best-effort-notterminating-pods -n=chp14-set1454"
kubectl describe resourcequota/best-effort-notterminating-pods -n=chp14-set1454

enter

echo "Inspect limits that were applied to a pod automatically"
echo ""
echo "kubectl describe rc/kubia-rc -n=chp14-set1454"
kubectl describe rc/kubia-rc -n=chp14-set1454

enter

echo "kubectl describe deployment -n=chp14-set1454"
kubectl describe deployment -n=chp14-set1454

enter

echo "Access API server via curl. To enable this, we use RoleBinding to bind the Role resource with the ServiceAccount"
echo ""

echo "Get Services from the API server"
echo "kubectl exec -it curl-restrictive -n=chp14-set1454 -- curl localhost:8001/api/v1/namespaces/chp14-set1454/services"
kubectl exec -it curl-restrictive -n=chp14-set1454 -- curl localhost:8001/api/v1/namespaces/chp14-set1454/services
echo ""

echo $HR

echo "kubectl get all -n=chp14-set1454"
kubectl get all -n=chp14-set1454

echo $HR

echo "kubectl delete -f $FULLPATH"
kubectl delete -f $FULLPATH --ignore-not-found

