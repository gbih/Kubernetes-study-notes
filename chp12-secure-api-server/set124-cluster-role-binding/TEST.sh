#!/bin/bash
. ~/src/common/setup.sh
FULLPATH=$(pwd)

echo "The default system:discovery ClusterRole"
echo ""


echo "The API server also exposes non-resource URLs."
echo "Access to these URLs is granted via the predefined system:discovery ClusterRole and ClusterRoleBinding."
echo ""
echo "kubectl get clusterrole system:discovery -o json | jq 'del(.metadata.managedFields, .metadata.selfLink, .metadata.annotations)' | yq r -P -"
echo ""
kubectl get clusterrole system:discovery -o json | jq 'del(.metadata.managedFields, .metadata.selfLink, .metadata.annotations)' | yq r -P -

enter

echo "The default system:discovery ClusterRoleBinding"
echo ""

echo "kubectl get clusterrolebinding system:discovery -o json | jq 'del(.metadata.managedFields, .metadata.selfLink, .metadata.annotations)' | yq r -P -"
echo ""
kubectl get clusterrolebinding system:discovery -o json | jq 'del(.metadata.managedFields, .metadata.selfLink, .metadata.annotations)' | yq r -P -

enter

echo "Create namespace and pod resources"
echo ""
kubectl apply -f $FULLPATH/set1224-0-ns.yaml
echo ""

echo "kubectl run test --image=georgebaptista/kubectl-proxy --restart=Never -n=foo"
kubectl run test --image=georgebaptista/kubectl-proxy --restart=Never -n=foo
echo ""

echo "kubectl -n=foo wait --for=condition=Ready=True pod/test --timeout=31s"
kubectl -n=foo wait --for=condition=Ready=True pod/test --timeout=31s

enter

echo "Get enn var from the test pod"
echo "kubectl -n=foo exec -it test -- printenv"
kubectl -n=foo exec -it test -- printenv

echo $HR

echo "PODIP=\$(kubectl -n=foo exec test -it -- sh -c \"printenv KUBERNETES_SERVICE_HOST\")"
PODIP=$(kubectl -n=foo exec test -it -- sh -c "printenv KUBERNETES_SERVICE_HOST")
echo "PODIP is $PODIP"
echo $HR

#echo "Check for illegal characters"
#echo "printf %s "$PODIP" | xxd"
#printf %s "$PODIP" | xxd
#echo $HR

#echo "URL=${PODIP%$'\r'}"
URL=${PODIP%$'\r'}
#echo $HR

echo "kubectl -n=foo exec -it test -- curl https://$URL:443/healthz -k"
kubectl -n=foo exec -it test -- curl https://$URL:443/healthz -k
echo ""
echo $HR

echo "kubectl -n=foo exec -it test -- curl https://$URL:443/api -k"
kubectl -n=foo exec -it test -- curl https://$URL:443/api -k
echo ""

enter

kubectl delete ns foo
kubectl delete ns bar
kubectl delete clusterrole pv-reader
kubectl delete clusterrolebinding pv-test
