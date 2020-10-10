#!/bin/bash
. ~/src/common/setup.sh
FULLPATH=$(pwd)
echo "12.2.3 Applying PSP via RBAC clusterrole/clusterrolebinding on deployments, replicationcontrollers, pods"
echo $HR_TOP

kubectl apply -f $FULLPATH/set1223-0-ns.yaml
kubectl apply -f $FULLPATH/set1223-1-sa.yaml
kubectl apply -f $FULLPATH/set1223-2-psp-privileged.yaml
kubectl apply -f $FULLPATH/set1223-3-psp-restricted.yaml
kubectl apply -f $FULLPATH/set1223-4-clusterrole-clusterrolebinding.yaml
kubectl apply -f $FULLPATH/set1223-5-deployment.yaml
kubectl apply -f $FULLPATH/set1223-6-rc.yaml
kubectl apply -f $FULLPATH/set1223-7-pod-privileged.yaml # this should be rejected
kubectl apply -f $FULLPATH/set1223-8-pod-restrictive.yaml

echo $HR

echo "kubectl rollout status deployment kubia-deploy -n=chp12-set1223"
kubectl rollout status deployment kubia-deploy -n=chp12-set1223

echo $HR

echo "Check for ReplicationController replicas:"

EXPECTED_REPLICAS=$(kubectl get replicationcontroller/kubia-rc -n=chp12-set1223 -o jsonpath={.status.fullyLabeledReplicas})
echo "EXPECTED_REPLICAS: $EXPECTED_REPLICAS"

READY_REPLICAS=$(kubectl get replicationcontroller/kubia-rc -n=chp12-set1223 -o jsonpath={.status.readyReplicas})
echo "READY_REPLICAS: $READY_REPLICAS"
echo ""

while [[ $EXPECTED_REPLICAS != $READY_REPLICAS ]]
do
kubectl get replicationcontroller/kubia-rc -n=chp12-set1223 -o custom-columns=READY_REPLICAS:..status.readyReplicas
  sleep 1.5
  READY_REPLICAS=$(kubectl get replicationcontroller/kubia-rc -n=chp12-set1223 -o jsonpath={.status.readyReplicas})
done

echo $HR



echo "kubectl get all -n=chp12-set1223"
kubectl get all -n=chp12-set1223

enter

echo "Access API server via curl. To enable this, we use RoleBinding to bind the Role resource with the ServiceAccount"
echo ""

echo "Get Services from the API server"
echo "kubectl exec -it curl-restrictive -n=chp12-set1223 -- curl localhost:8001/api/v1/namespaces/chp12-set1223/services"
kubectl exec -it curl-restrictive -n=chp12-set1223 -- curl localhost:8001/api/v1/namespaces/chp12-set1223/services
echo ""

echo $HR

echo "kubectl delete -f $FULLPATH"
kubectl delete -f $FULLPATH --ignore-not-found

