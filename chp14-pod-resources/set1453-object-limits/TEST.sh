#!/bin/bash
. ~/src/common/setup.sh
FULLPATH=$(pwd)
echo "14.5.3 Limiting the number of objects that can be created"
echo $HR_TOP

kubectl apply -f $FULLPATH/set1453-0-ns.yaml
kubectl apply -f $FULLPATH/set1453-1-quota-object-count.yaml
kubectl apply -f $FULLPATH/set1453-1-sa.yaml
kubectl apply -f $FULLPATH/set1453-2-psp-privileged.yaml
kubectl apply -f $FULLPATH/set1453-3-psp-restricted.yaml
kubectl apply -f $FULLPATH/set1453-4-role-rolebinding.yaml

kubectl apply -f $FULLPATH/set1453-7-pod-privileged.yaml # this should be rejected
kubectl apply -f $FULLPATH/set1453-8-pod-restrictive.yaml

echo "kubectl wait --for=condition=Ready=True pods/curl-restrictive -n=chp14-set1453 --timeout=10s"
kubectl wait --for=condition=Ready=True pods/curl-restrictive -n=chp14-set1453 --timeout=10s
echo ""

kubectl apply -f $FULLPATH/set1453-5-deployment.yaml
kubectl apply -f $FULLPATH/set1453-6-rc.yaml

echo $HR

value=$(<set1453-1-quota-object-count.yaml)
echo "$value"

enter

echo "kubectl rollout status deployment kubia-deploy -n=chp14-set1453"
kubectl rollout status deployment kubia-deploy -n=chp14-set1453

echo $HR



echo "Check for ReplicationController replicas:"

EXPECTED_REPLICAS=$(kubectl get replicationcontroller/kubia-rc -n=chp14-set1453 -o jsonpath={.status.fullyLabeledReplicas})
echo "EXPECTED_REPLICAS: $EXPECTED_REPLICAS"

READY_REPLICAS=$(kubectl get replicationcontroller/kubia-rc -n=chp14-set1453 -o jsonpath={.status.readyReplicas})
echo "READY_REPLICAS: $READY_REPLICAS"
echo ""

while [[ $EXPECTED_REPLICAS != $READY_REPLICAS ]]
do
kubectl get replicationcontroller/kubia-rc -n=chp14-set1453 -o custom-columns=READY_REPLICAS:..status.readyReplicas
  sleep 1.5
  READY_REPLICAS=$(kubectl get replicationcontroller/kubia-rc -n=chp14-set1453 -o jsonpath={.status.readyReplicas})
done

echo $HR



echo "kubectl get all -n=chp14-set1453"
kubectl get all -n=chp14-set1453

enter

echo "Check resourcequota"
echo ""
echo "kubectl describe resourcequota/objects -n=chp14-set1453"
kubectl describe resourcequota/objects -n=chp14-set1453

enter

echo "Inspect limits that were applied to a pod automatically"
echo ""
echo "kubectl describe rc/kubia-rc -n=chp14-set1453"
kubectl describe rc/kubia-rc -n=chp14-set1453

enter

echo "kubectl describe deployment -n=chp14-set1453"
kubectl describe deployment -n=chp14-set1453

enter

echo "Access API server via curl. To enable this, we use RoleBinding to bind the Role resource with the ServiceAccount"
echo ""

echo "Get Services from the API server"
echo "kubectl exec -it curl-restrictive -n=chp14-set1453 -- curl localhost:8001/api/v1/namespaces/chp14-set1453/services"
kubectl exec -it curl-restrictive -n=chp14-set1453 -- curl localhost:8001/api/v1/namespaces/chp14-set1453/services
echo ""

echo $HR

echo "kubectl delete -f $FULLPATH"
kubectl delete -f $FULLPATH --ignore-not-found

