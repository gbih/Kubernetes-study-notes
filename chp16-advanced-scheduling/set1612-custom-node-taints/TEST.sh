#!/bin/bash
. ~/src/common/setup.sh
FULLPATH=$(pwd)
echo "16.1.2 Adding custom taints to a node"
echo $HR_TOP

# kubectl get nodes -l name=node1-vm
echo "kubectl taint node -l name=node1-vm node-type=production:NoSchedule"
kubectl taint node -l name=node1-vm node-type=production:NoSchedule
sleep 1
echo ""

echo "kubectl get nodes -o json | jq '.items[].spec.taints'"
kubectl get nodes -o json | jq '.items[].spec.taints'

enter

echo "kubectl label node -l name=node1-vm env=production"
kubectl label node -l name=node1-vm env=production
echo ""

echo "kubectl label node -l name=node2-vm env=development"
kubectl label node -l name=node2-vm env=development

echo "kubectl label node -l name=actionbook-vm env=control-plain"
kubectl label node -l name=actionbook-vm env=control-plain
echo $HR

echo "kubectl apply -f $FULLPATH"
kubectl apply -f $FULLPATH

echo $HR

echo "kubectl wait --for=condition=Ready=True pods/curl-restrictive -n=chp15-set1512 --timeout=10s"
kubectl wait --for=condition=Ready=True pods/curl-restrictive -n=chp15-set1512 --timeout=10s

echo $HR

echo "In a separate terminal, run ./WATCH.sh to monitor various objects"

echo $HR

enter

echo "kubectl rollout status deployment kubia-deploy -n=chp15-set1512"
kubectl rollout status deployment kubia-deploy -n=chp15-set1512

echo $HR

echo "Check PSP is set-up correctly by getting HPA from API server."
echo "We use RoleBinding with Role resource and ServiceAccount"
echo ""
echo "kubectl exec -it curl-restrictive -n=chp15-set1512 -- curl localhost:8001/apis/autoscaling/v1/namespaces/chp15-set1512/horizontalpodautoscalers/kubia | jq 'del(.metadata.managedFields, .metadata.annotations, .metadata.apiVersion)'"
echo ""

kubectl exec -it curl-restrictive -n=chp15-set1512 -- curl localhost:8001/apis/autoscaling/v1/namespaces/chp15-set1512/horizontalpodautoscalers/kubia | jq 'del(.metadata.managedFields, .metadata.annotations, .metadata.apiVersion)'

echo $HR

echo "Press enter to delete objects"

enter

echo "Reset taints"

echo "kubectl taint node -l name=node1-vm node-type:NoSchedule-"
kubectl taint node -l name=node1-vm node-type:NoSchedule-

echo $HR

echo "kubectl delete -f $FULLPATH"
kubectl delete -f $FULLPATH --ignore-not-found

