#!/bin/bash
. ~/src/common/setup.sh
FULLPATH=$(pwd)
echo "Limiting the number of objects that can be created"
echo $HR_TOP

kubectl apply -f $FULLPATH/set1222-0-ns.yaml
kubectl apply -f $FULLPATH/set1453-1-quota-object-count.yaml
kubectl apply -f $FULLPATH/set1222-1-sa.yaml
kubectl apply -f $FULLPATH/set1222-2-psp-privileged.yaml
kubectl apply -f $FULLPATH/set1222-3-psp-restricted.yaml
kubectl apply -f $FULLPATH/set1222-4-role-rolebinding.yaml

kubectl apply -f $FULLPATH/set1222-7-pod-privileged.yaml # this should be rejected
kubectl apply -f $FULLPATH/set1222-8-pod-restrictive.yaml

echo "kubectl wait --for=condition=Ready=True pods/curl-restrictive -n=chp12-set1222 --timeout=10s"
kubectl wait --for=condition=Ready=True pods/curl-restrictive -n=chp12-set1222 --timeout=10s
echo ""

kubectl apply -f $FULLPATH/set1222-5-deployment.yaml
kubectl apply -f $FULLPATH/set1222-6-rc.yaml

echo $HR

value=$(<set1453-1-quota-object-count.yaml)
echo "$value"

enter

echo "kubectl rollout status deployment kubia-deploy -n=chp12-set1222"
kubectl rollout status deployment kubia-deploy -n=chp12-set1222

echo $HR

echo "kubectl get all -n=chp12-set1222"
kubectl get all -n=chp12-set1222

enter

echo "Check resourcequota"
echo ""
echo "kubectl describe resourcequota/objects -n=chp12-set1222"
kubectl describe resourcequota/objects -n=chp12-set1222
echo ""

enter

echo "Inspect limits that were applied to a pod automatically"
echo ""
echo "kubectl describe rc/kubia-rc -n=chp12-set1222"
kubectl describe rc/kubia-rc -n=chp12-set1222

enter

echo "kubectl describe deployment -n=chp12-set1222"
kubectl describe deployment -n=chp12-set1222

enter

echo "Access API server via curl. To enable this, we use RoleBinding to bind the Role resource with the ServiceAccount"
echo ""

echo "Get Services from the API server"
echo "kubectl exec -it curl-restrictive -n=chp12-set1222 -- curl localhost:8001/api/v1/namespaces/chp12-set1222/services"
kubectl exec -it curl-restrictive -n=chp12-set1222 -- curl localhost:8001/api/v1/namespaces/chp12-set1222/services
echo ""

echo $HR

echo "kubectl delete -f $FULLPATH"
kubectl delete -f $FULLPATH --ignore-not-found

