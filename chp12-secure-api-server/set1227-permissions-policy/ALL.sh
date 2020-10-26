# root-level
#kubectl create clusterrolebinding permissive-binding --clusterrole=cluster-admin --group=system:serviceaccounts

kubectl create clusterrolebinding permissive-binding --clusterrole=service-reader --group=system:serviceaccounts

#####

kubectl get clusterrolebinding.rbac.authorization.k8s.io/permissive-binding -o yaml
