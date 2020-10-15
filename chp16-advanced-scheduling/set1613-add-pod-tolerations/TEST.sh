#!/bin/bash
. ~/src/common/setup.sh
FULLPATH=$(pwd)
echo "Adding tolerations to pods"
echo $HR_TOP

# Control-plane node
echo "Control-plane node"
echo "kubectl taint node actionbook-vm node-type=master:NoSchedule"
kubectl taint node actionbook-vm node-type=master:NoSchedule
echo ""

# Production node
echo "Production node"
echo "kubectl taint node -l name=node1-vm node-type=production:NoSchedule"
kubectl taint node -l name=node1-vm node-type=production:NoSchedule
echo ""

# Development node
echo "Development node"
echo "Also need to taint the non-production pods with a taint"
echo "kubectl taint node -l name=node2-vm node-type=non-production:NoSchedule"
kubectl taint node -l name=node2-vm node-type=non-production:NoSchedule

echo $HR

echo "kubectl label node -l name=node1-vm env=production"
kubectl label node -l name=node1-vm env=production
echo ""

echo "kubectl label node -l name=node2-vm env=development"
kubectl label node -l name=node2-vm env=development
echo ""

echo "kubectl label node -l name=actionbook-vm env=control-plain"
kubectl label node -l name=actionbook-vm env=control-plain

enter

echo "kubectl apply -f $FULLPATH"
kubectl apply -f $FULLPATH

enter

echo "Getting taints, style 1"
echo "kubectl get nodes -o json | jq '.items[].spec.taints'"
kubectl get nodes -o json | jq '.items[].spec.taints'
echo $HR

echo "Alternative 2"
echo "kubectl get nodes -o=custom-columns=NAME:.metadata.name,TAINTS:.spec.taints,LABEL-NAME:.metadata.labels.name,LABEL-ENV:.metadata.labels.env"
kubectl get nodes -o=custom-columns=NAME:.metadata.name,TAINTS:.spec.taints,LABEL-NAME:.metadata.labels.name,LABEL-ENV:.metadata.labels.env

enter



echo "kubectl wait --for=condition=Ready=True pods/curl-restrictive -n=chp16-set1613 --timeout=10s"
kubectl wait --for=condition=Ready=True pods/curl-restrictive -n=chp16-set1613 --timeout=10s

echo $HR

echo "In a separate terminal, run ./WATCH.sh to monitor various objects"

echo $HR

enter

echo "kubectl rollout status deployment kubia-deploy -n=chp16-set1613"
kubectl rollout status deployment kubia-deploy -n=chp16-set1613

echo $HR

echo "Check PSP is set-up correctly by accessing API server."
echo "We use RoleBinding with Role resource and ServiceAccount"
echo ""

echo "kubectl exec -it curl-restrictive -n chp16-set1613 -- curl localhost:8001/api/v1/namespaces/chp16-set1613/services | jq 'del(.metadata.uid, .items[].metadata.managedFields, .items[].metadata.annotations, .status)' | yq r -P -"
echo ""

kubectl exec -it curl-restrictive -n chp16-set1613 -- curl localhost:8001/api/v1/namespaces/chp16-set1613/services | jq 'del(.metadata.uid, .items[].metadata.managedFields, .items[].metadata.annotations, .status)' | yq r -P -


echo $HR

echo "Press enter to delete taints and objects"

enter
echo "Remove taints"
echo "kubectl taint node actionbook-vm node-type=master:NoSchedule-"
echo "kubectl taint node -l name=node1-vm node-type=production:NoSchedule-"
echo "kubectl taint node -l name=node2-vm node-type=non-production:NoSchedule-"
kubectl taint node actionbook-vm node-type=master:NoSchedule-
kubectl taint node -l name=node1-vm node-type=production:NoSchedule-
kubectl taint node -l name=node2-vm node-type=non-production:NoSchedule-

echo $HR

echo "Remove labels"
echo "kubectl label node -l name=node1-vm env-"
echo "kubectl label node -l name=node2-vm env-"
echo "kubectl label node -l name=actionbook-vm env-"
kubectl label node -l name=node1-vm env-
kubectl label node -l name=node2-vm env-
kubectl label node -l name=actionbook-vm env-


echo $HR


echo "kubectl delete -f $FULLPATH"
kubectl delete -f $FULLPATH --ignore-not-found

