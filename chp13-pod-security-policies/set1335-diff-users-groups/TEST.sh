#!/bin/bash
. ~/src/common/setup.sh
FULLPATH=$(pwd)
echo "Assigning different PodSecurityPolicies to different users and groups"
echo ""
echo "You don't need to play around with clusters or context."
echo "These are the important things:"
echo "1. Set up a user account or service account"
echo "2. Set up a PodSecurityPolicy"
echo "3. Set up a ClusterRole / Role"
echo "4. Set up a ClusterRoleBinding / RoleBinding"
echo $HR_TOP


echo "kubectl config set-credentials bob --username=bob --password=password"
kubectl config set-credentials bob --username=bob --password=password

echo $HR


((i++))
echo "$i. Get reference to microk8s cluster certificate (ca.crt) and certificate key (ca.key):"
CA_CRT=/var/snap/microk8s/current/certs/ca.crt
CA_KEY=/var/snap/microk8s/current/certs/ca.key
echo $CA_CRT
echo $CA_KEY
echo $HR

#echo "Creating a K8s User Account with X509 Client Certificate"
#echo ""
#
#((i++))
#echo "$i. Create the client key (need OpenSSL installed on the system):"
#echo "openssl genrsa -out magalix.key 2048"
openssl genrsa -out magalix.key 2048 >> /dev/null
#echo ""

#((i++))
#echo "$i. Next, create a certificate signing request"
#echo "The CN part of the subject must contain the username:"
#echo 'openssl req -new -key magalix.key -out magalix.csr -subj "/CN=magalix"'
openssl req -new -key magalix.key -out magalix.csr -subj "/CN=magalix"
#echo ""
#
#((i++))
#echo "$i. Since we have the user key and signing request, we can use the cluster certificate and certificate key to sign this request:"
#echo "openssl x509 -req -in magalix.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out magalix.crt -days 300"
openssl x509 -req -in magalix.csr -CA $CA_CRT -CAkey $CA_KEY -CAcreateserial -out magalix.crt -days 300
#echo ""
#
#((i++))
#echo "$i. Add the user's credentials to kubeconfig:"
#echo "kubectl config set-credentials magalix --client-certificate=magalix.crt --client-key=magalix.key"
kubectl config set-credentials magalix --client-certificate=magalix.crt --client-key=magalix.key
#echo ""

#echo "$i. Create a context for this user and associate it with a cluster:"
#echo "kubectl config set-context magalix-context --cluster=microk8s-cluster --user=magalix"
kubectl config set-context magalix-context --cluster=microk8s-cluster --user=magalix

#((i++))
#echo "$i. Try changing context:"
#echo "kubectl config use-context microk8s"
kubectl config use-context microk8s


#((i++))
#echo "$i. Get all clusters:"
#echo "kubectl config get-clusters"
#kubectl config get-clusters
#echo ""
echo $HR
((i++))
echo "$i. Get all contexts:"
echo "kubectl config get-contexts"
kubectl config get-contexts
echo $HR1

#((i++))
#echo "$i. Check current context:"
#echo "kubectl config current-context"
#kubectl config current-context
#echo ""
echo $HR

((i++))
echo "$i. Get list of users:"
echo "kubectl config view -o jsonpath='{.users[*].name}'"
kubectl config view -o jsonpath='{.users[*].name}'
echo ""

echo $HR

enter




###########################################

((i++))

echo "$i. Deploy the app"
echo ""

echo "kubectl apply -f $FULLPATH"
kubectl apply -f $FULLPATH/set1335-0-ns.yaml
kubectl apply -f $FULLPATH/set1335-1-psp-privileged.yaml
kubectl apply -f $FULLPATH/set1335-2-psp-default.yaml
#kubectl apply -f $FULLPATH/serviceaccount.yaml
sleep 2


# kubectl get sa --all-namespaces=true

echo $HR

((i++))
echo "$i. Check Resources"
echo ""

#echo "kubectl get psp"
#kubectl get psp

#enter

echo "kubectl apply -f set1335-00-clusterrole-psp-default.yaml"
kubectl apply -f set1335-00-clusterrole-psp-default.yaml
echo ""

echo "kubectl apply -f set1335-00-clusterrole-psp-privileged.yaml"
kubectl apply -f set1335-00-clusterrole-psp-privileged.yaml
echo ""

echo "kubectl apply -f clusterrolebinding-all-users.yaml"
kubectl apply -f clusterrolebinding-all-users.yaml
echo ""

echo "Bind the psp-privileged ClusterRole only to Bob:"
echo "kubectl apply -f clusterrolebinding-bob.yaml"
kubectl apply -f clusterrolebinding-bob.yaml
echo ""

echo $HR

echo "kubectl apply -f clusterrolebinding-magalix.yaml"
kubectl apply -f clusterrolebinding-magalix.yaml
echo ""



#echo "Bind the psp-privileged ClusterRole only to Bob:"
#echo "kubectl create clusterrolebinding psp-bob --clusterrole=psp-privileged --user=bob"
#kubectl create clusterrolebinding psp-bob --clusterrole=psp-privileged --user=bob



#echo "Assume both users have been authenticated."
#echo "Alice (regular user): has access to default PodSecurityPolicies."
#echo "Bob (privileged user): has access to default and privileged PodSecurityPolicies."
#echo ""

#echo "kubectl config set-credentials alice --username=alice --password=password"
#kubectl config set-credentials alice --username=alice --password=password
#echo ""


echo $HR


##################################

#echo "kubectl --username admin create -f pod-privileged.yaml"
#kubectl --username admin create -f pod-privileged.yaml
#echo ""

#echo "kubectl --user alice create -f pod-privileged.yaml"
#kubectl --user alice create -f pod-privileged.yaml
#echo ""
#
#echo "kubectl --user alice create -f pod-non-privileged.yaml"
#kubectl --user alice create -f pod-non-privileged.yaml
#echo ""

#echo "As expected, the API server doesn’t allow Alice to create privileged pods. Now, let’s see if it allows Bob to do that:"

echo "kubectl --user magalix create -f pod-privileged.yaml"
kubectl --user magalix create -f pod-privileged.yaml
echo ""

echo "kubectl --user bob create -f pod-privileged.yaml"
kubectl --user bob create -f pod-privileged.yaml

#echo ""
#echo "You’ve successfully used RBAC to make the Admission Control
#plugin use different PodSecurityPolicy resources for different users."

##########################################

enter

echo "$i. Clean-up"
echo ""
echo "kubectl delete -f $FULLPATH"
kubectl delete -f $FULLPATH --ignore-not-found
kubectl delete clusterrolebinding psp-all-users
kubectl config unset users.bob
kubectl config unset users.alice

