#!/bin/bash
. ../../SETUP.sh
FULLPATH=$(pwd)

((i++))

#cat <<- "NOTES"
#NOTES: 
#Assigning different PodSecurityPolicies to different users and groups
#
#---
#SETUP NOTES:
#Have to create an authenticated user, such as Alice or Bob.
#
#
#---
#We mentioned that a PodSecurityPolicy is a cluster-level resource, which means it can't be stored in and applied to a specific namespace. Does that mean it always applies across all namespaces? No, because that would make them relatively unusable. After all, system pods must often be allowed to do things that regular pods shouldn't.
#
#Assigning different policies to different users is done through the RBAC mecha nism described in the previous chapter. The idea is to create as many policies as you need and make them available to individual users or groups by creating ClusterRole resources and pointing them to the individual policies by name. By binding those ClusterRoles to specific users or groups with ClusterRoleBindings, when the PodSecurityPolicy Admission Control plugin needs to decide whether to admit a pod definition or not, it will only consider the policies accessible to the user creating the pod.
#NOTES

#enter

value=$(<set1335-1-psp-privileged.yaml)
#echo "$value"

#enter

#echo "cat /var/snap/microk8s/current/args/kube-apiserver"
#echo ""
#cat /var/snap/microk8s/current/args/kube-apiserver
#echo ""
#echo "See more options here: https://kubernetes.io/docs/reference/command-line-tools-reference/kube-apiserver/"
#
#enter

echo "$i. Deploying the app"
echo ""

echo "kubectl apply -f $FULLPATH"
kubectl apply -f $FULLPATH/set1335-0-ns.yaml
kubectl apply -f $FULLPATH/set1335-1-psp-privileged.yaml
kubectl apply -f $FULLPATH/set1335-2-psp-default.yaml
sleep 2

enter

((i++))
echo "$i. Check Resources"
echo ""

echo "kubectl get all -n=chp13-set1335 -o wide"
kubectl get all -n=chp13-set1335 -o wide
echo ""

echo "kubectl get node"
kubectl get node
echo ""

echo "kubectl get psp"
kubectl get psp

echo $HR

echo "We should have two policies in the cluster

As you can see in the PRIV column, the default policy doesn't allow running privileged containers, whereas the privileged policy does. Because you’re currently logged in as a cluster-admin, you can see all the policies. When creating pods, if any policy allows you to deploy a pod with certain features, the API server will accept your pod.

Now imagine two additional users are using your cluster: Alice and Bob. You want Alice to only deploy restricted (non-privileged) pods, but you want to allow Bob to also deploy privileged pods. You do this by making sure Alice can only use the default PodSecurityPolicy, while allowing Bob to use both."

enter

((i++))
echo "$i. USING RBAC TO ASSIGN DIFFERENT PODSECURITYPOLICIES TO DIFFERENT USERS"
echo ""
echo "In the previous chapter, you used RBAC to grant users access to only certain resource types, but I mentioned that access can be granted to specific resource instances by referencing them by name. That’s what you’ll use to make users use different PodSecurityPolicy resources.

First, you’ll create two ClusterRoles, each allowing the use of one of the policies. You’ll call the first one psp-default and in it allow the use of the default PodSecurityPolicy resource. You can use kubectl create clusterrole to do that.
"

#echo "kubectl create clusterrole psp-default --verb=use --resource=podsecuritypolicies --resource-name=default"
#kubectl create clusterrole psp-default --verb=use --resource=podsecuritypolicies --resource-name=default
#echo ""

echo "kubectl apply -f set1335-00-clusterrole-psp-default.yaml"
kubectl apply -f set1335-00-clusterrole-psp-default.yaml
echo ""

echo "Here, As you can see, you’re referring to a specific instance of a PodSecurityPolicy resource by using the --resource-name option."

echo $HR

echo "Now, create another ClusterRole called psp-privileged, pointing to the privileged policy:"
echo ""
echo "kubectl apply -f set1335-00-clusterrole-psp-privileged.yaml"
kubectl apply -f set1335-00-clusterrole-psp-privileged.yaml

#echo "kubectl create clusterrole psp-privileged --verb=use --resource=podsecuritypolicies --resource-name=privileged"
#kubectl create clusterrole psp-privileged --verb=use --resource=podsecuritypolicies --resource-name=privileged

enter

echo "Now, you need to bind these two policies to users. As you may remember from the previous chapter, if you’re binding a ClusterRole that grants access to cluster-level resources (which is what PodSecurityPolicy resources are), you need to use a ClusterRoleBinding instead of a (namespaced) RoleBinding.

You’re going to bind the psp-default ClusterRole to all authenticated users, not only to Alice. This is necessary because otherwise no one could create any pods, because the Admission Control plugin would complain that no policy is in place. Authenticated users all belong to the system:authenticated group, so you’ll bind the ClusterRole to the group:"
echo ""

echo "kubectl create clusterrolebinding psp-all-users --clusterrole=psp-default --group=system:authenticated"
kubectl create clusterrolebinding psp-all-users --clusterrole=psp-default --group=system:authenticated
echo ""

echo "Bind the psp-privileged ClusterRole only to Bob:"
echo "kubectl create clusterrolebinding psp-bob --clusterrole=psp-privileged --user=bob"
kubectl create clusterrolebinding psp-bob --clusterrole=psp-privileged --user=bob

echo $HR



echo "Next, as an authenticated user, Alice should now have access to the default PodSecurityPolicy, whereas Bob should have access to both the default and privileged PodSecurityPolicies. Alice shouldn’t be able to create privileged pods, whereas Bob should. Let’s see if that’s true."

enter


echo "CREATING ADDITIONAL USERS FOR KUBECTL"
echo ""
echo "How do you authenticate as Alice or Bob instead of whatever you’re authenticated as currently?"
echo "First, you’ll create two new users in kubectl’s config with the following two commands:"
echo ""

# add a new cluster to your kubeconf that supports basic auth
# kubectl config set-credentials kubeuser/foo.kubernetes.com --username=kubeuser --password=kubepassword

echo "kubectl config set-credentials alice --username=alice --password=password"
kubectl config set-credentials alice --username=alice --password=password
echo ""

echo "kubectl config set-credentials bob --username=bob --password=password"
kubectl config set-credentials bob --username=bob --password=password
echo ""

echo "This sets a user entry in kubeconfig"

NOTE2="
Specifying a name that already exists will merge new fields on top of existing values.
Bearer token and basic auth are mutually exclusive.

Client-certificate flags: --client-certificate=certfile --client-key=keyfile
Bearer token flags: --token=bearer_token
Basic auth flags: --username=basic_user --password=basic_password

# Set only the "client-key" field on the "cluster-admin"
# entry, without touching other values:
kubectl config set-credentials cluster-admin --client-key=~/.kube/admin.key

# Set basic auth for the "cluster-admin" entry
kubectl config set-credentials cluster-admin --username=admin --password=uXFGweU9l35qcif

# Embed client certificate data in the "cluster-admin" entry
kubectl config set-credentials cluster-admin --client-certificate=~/.kube/admin.crt --embed-certs=true

# Enable the Google Compute Platform auth provider for the "cluster-admin" entry
kubectl config set-credentials cluster-admin --auth-provider=gcp

# Enable the OpenID Connect auth provider for the "cluster-admin" entry with additional args
kubectl config set-credentials cluster-admin --auth-provider=oidc --auth-provider-arg=client-id=foo --auth-provider-arg=client-secret=bar

# Remove the "client-secret" config value for the OpenID Connect auth provider for the "cluster-admin" entry
kubectl config set-credentials cluster-admin --auth-provider=oidc --auth-provider-arg=client-secret-
"

echo ""
echo "Because you’re setting username and password credentials, kubectl will use basic HTTP authentication for these two users (other authentication methods include tokens, client certificates, and so on)."

enter

echo "kubectl config view"
kubectl config view
echo $HR

echo "Get a list of users in kubeconfig"
echo ""
echo "kubectl config view -o jsonpath='{.users[*].name}'"
kubectl config view -o jsonpath='{.users[*].name}'
echo ""
echo $HR

echo "Display list of contexts:"
echo ""
echo "kubectl config get-contexts"
kubectl config get-contexts
echo ""
enter

echo "CREATING PODS AS A DIFFERENT USER
You can now try creating a privileged pod while authenticating as Alice. You can tell kubectl which user credentials to use by using the --user option:
"

echo "kubectl --user alice create -f pod-privileged.yaml"
kubectl --user alice create -f pod-privileged.yaml
echo ""

echo "As expected, the API server doesn’t allow Alice to create privileged pods. Now, let’s see if it allows Bob to do that:"

echo "kubectl --user bob create -f pod-privileged.yaml"
kubectl --user bob create -f pod-privileged.yaml
echo ""
echo "You’ve successfully used RBAC to make the Admission Control
plugin use different PodSecurityPolicy resources for different users."


enter

#((i++))
#echo "$i. Clean-up"
#echo ""
#echo "kubectl delete -f $FULLPATH --now --ignore-not-found"
#kubectl delete -f $FULLPATH --now --ignore-not-found
#kubectl delete clusterrolebinding psp-all-users
#kubectl config unset users.bob
#kubectl config unset users.alice

echo $HR 
