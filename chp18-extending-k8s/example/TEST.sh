#!/bin/bash
. ~/src/common/setup.sh
echo "thorsten.com"
echo $HR_TOP
FULLPATH=$(pwd)

#kubectl create clusterrole psp-privileged --verb=use --resource=podsecuritypolicies --resource-name=restricted --dry-run=client -o yaml > CR.yaml

#kubectl create clusterrolebinding restricted --clusterrole=psp-privileged --group=system:authenticated --dry-run=client -o yaml > CRB.yaml

echo "kubectl apply -f 01_namespace.yaml"
kubectl apply -f 01_namespace.yaml

echo $HR

echo "kubectl apply -f 01b_psp.yaml"
kubectl apply -f 01b_psp.yaml

echo $HR

echo "kubectl apply -f 02_service_account.yaml"
kubectl apply -f 02_service_account.yaml

echo $HR

echo "kubectl apply -f 03_custom_resource_definition.yaml"
kubectl apply -f 03_custom_resource_definition.yaml
echo ""
echo "kubectl api-resources --api-group thns.com"
kubectl api-resources --api-group thns.com

echo $HR

echo "kubectl apply -f 04_tenant_config_1.yaml"
kubectl apply -f 04_tenant_config_1.yaml
echo ""
echo "kubectl get tc"
kubectl get tc

echo $HR

echo "kubectl apply -f 05_cluster_role.yaml"
kubectl apply -f 05_cluster_role.yaml
echo ""
echo "kubectl get clusterrole thns.com:tenantconfig:reader"
kubectl get clusterrole thns.com:tenantconfig:reader

echo $HR

echo "kubectl apply -f 06_cluster_role_binding.yaml"
kubectl apply -f 06_cluster_role_binding.yaml
echo ""
echo "kubectl get clusterrolebinding thns.com:tenantconfig:cdreader-read"
kubectl get clusterrolebinding thns.com:tenantconfig:cdreader-read

echo $HR

echo "kubectl apply -f 03b_controller.yaml"
kubectl apply -f 03b_controller.yaml
echo ""
echo "kubectl get deployment/website-controller"
kubectl get deployment/website-controller

echo $HR

echo "kubectl auth can-i get tenantconfigs.thns.com --as=system:serviceaccount:thns:crdreader"
kubectl auth can-i get tenantconfigs.thns.com --as=system:serviceaccount:thns:crdreader

echo $HR

echo "delete all resources"

enter

echo "kubectl delete -f $FULLPATH"
kubectl delete -f $FULLPATH








