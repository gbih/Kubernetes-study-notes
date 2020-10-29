#!/bin/bash
. ~/src/common/setup.sh
echo "18.1.2 Automating custom resources with custom controllers"
echo $HR_TOP
FULLPATH=$(pwd)

# p.516 from book
# If Role Based Access Control (RBAC) is enabled in your cluster, Kubernetes will not allow the controller to watch Website resources or create Deployments or Services. To allow it to do that, you’ll need to bind the website-controller ServiceAccount to the cluster-admin ClusterRole, by creating a ClusterRoleBinding like this:
#$ kubectl create clusterrolebinding website-controller ➥ --clusterrole=cluster-admin
# --serviceaccount=default:website-controller clusterrolebinding "website-controller" created
#Once you have the ServiceAccount and ClusterRoleBinding in place, you can deploy the controller’s Deployment.

# GB We are using cluster-admin in the role, but we should try to use a less powerful role. Can we?




#kubectl create clusterrole psp-privileged --verb=use --resource=podsecuritypolicies --resource-name=restricted --dry-run=client -o yaml > CR.yaml

#kubectl create clusterrolebinding restricted --clusterrole=psp-privileged --group=system:authenticated --dry-run=client -o yaml > CRB.yaml


echo "kubectl apply -f $FULLPATH/set1812-0-ns.yaml"
kubectl apply -f $FULLPATH/set1812-0-ns.yaml
echo $HR

echo "kubectl apply -f $FULLPATH/setup-sa.yaml"
echo "kubectl apply -f $FULLPATH/setup-psp.yaml"

kubectl apply -f $FULLPATH/setup-sa.yaml
kubectl apply -f $FULLPATH/setup-psp.yaml
kubectl apply -f $FULLPATH/CR.yaml
kubectl apply -f $FULLPATH/CRB.yaml


echo "kubectl apply -f $FULLPATH/set1812-1-crd-website.yaml"
kubectl apply -f $FULLPATH/set1812-1-crd-website.yaml
#enter

echo "kubectl apply -f $FULLPATH/set1812-2-website-controller.yaml"
kubectl apply -f $FULLPATH/set1812-2-website-controller.yaml
#echo $HR

echo "kubectl rollout status deployment website-controller -n=chp18-set1812"
kubectl rollout status deployment website-controller -n=chp18-set1812
#enter

echo "kubectl apply -f $FULLPATH/set1812-3-website-kubia.yaml"
kubectl apply -f $FULLPATH/set1812-3-website-kubia.yaml
#enter

#kubectl apply -f $FULLPATH
#enter

#echo "kubectl get website kubia -n=chp18-set1812 -o yaml"
#kubectl get website -n=chp18-set1812 -o yaml
#echo $HR

echo "kubectl get all -n=chp18-set1812"
kubectl get all -n=chp18-set1812
echo $HR

echo "Press enter to start deleting objects"

enter

echo "kubectl delete website kubia -n=chp18-set1812"
kubectl delete website kubia -n=chp18-set1812

enter

echo "kubectl delete -f $FULLPATH"
kubectl delete -f $FULLPATH --ignore-not-found

kubectl delete clusterrolebinding website-controller

echo "kubectl delete clusterrolebinding psp:privileged"
kubectl delete clusterrolebinding psp:privileged

echo "kubectl delete clusterrole psp:privileged"
kubectl delete clusterrole psp:privileged
