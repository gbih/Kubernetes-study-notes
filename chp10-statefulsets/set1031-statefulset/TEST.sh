#!/bin/bash
. ~/src/SETUP.sh
FULLPATH=$(pwd)
echo $HR_TOP

echo "Run this in a separate terminal:"
echo "kubectl get events -n=chp10-set1031 -w"
echo ""

echo "Cleaning up.."
kubectl delete pv -l set=chp10-set1031 --now
kubectl delete statefulset --all -n=chp10-set1031 --now
kubectl delete pvc --all -n=chp10-set1031 --now
sleep 1
#
#echo $HR

memo=$(cat <<- 'MEMO_VAR'
NOTES:
10.3.1 StatefulSet

Deploying the app via StatefulSet

With the nodes of your data store cluster now running, you can start exploring it. 

IMPORTANT:
You can't communicate with your pods through the Service you created because it's headless. 
You'll need to connect to individual pods directly (or create a regular Service, but that wouldn’t allow you to talk to a specific pod).

Here we will communicate directly with the pod by using the API server as a proxy to the pods.

One useful feature of the API server is the ability to proxy connections directly to individual pods. Because the API server is secured, sending requests to pods through the API server is cumbersome.

<apiServerHost>:<port>/api/v1/namespaces/default/pods/kubia-0/proxy/<path>
so, we use:
localhost:8001/api/v1/namespaces/chp10-set1031/pods/kubia-0/proxy/

Goals here:
 Give replicated pods individual storage
 Provide a stable identity to a pod
 Create a StatefulSet and a corresponding headless governing Service 
 Scale and update a StatefulSet
 Discover other members of the StatefulSet through DNS
 Connect to other members through their host names
 Forcibly delete stateful pods
MEMO_VAR
)

echo "$memo"

enter

((i++))
echo "$i. Create resources."
echo "kubectl apply -f $FULLPATH"
kubectl apply -f $FULLPATH/set1031-0-ns.yaml
kubectl apply -f $FULLPATH/set1031-1-pv-hostpath.yaml
kubectl apply -f $FULLPATH/set1031-2-kubia-service-headless.yaml
kubectl apply -f $FULLPATH/set1031-3-kubia-statefulset.yaml --record
kubectl apply -f $FULLPATH/set1031-4-kubia-service-public.yaml
sleep 1

echo $HR

echo "kubectl rollout status sts kubia -n=chp10-set1031"
kubectl rollout status sts kubia -n=chp10-set1031
echo $HR


POD_0=$(kubectl get pod -n=chp10-set1031 -o jsonpath={'.items[0].metadata.name'})

echo "kubectl get pods -n=chp10-set1031 --show-labels"
kubectl get pods -n=chp10-set1031 --show-labels
echo $HR

echo "kubectl get pvc -n=chp10-set1031"
kubectl get pvc -n=chp10-set1031
echo $HR

enter

((i++))
echo "$i. Communicating with the API Server via 'kubectl proxy'"
echo ""

echo "kubectl proxy &"
kubectl proxy &
echo $HR

sleep 3

echo "curl localhost:8001/api/v1/namespaces/chp10-set1031/pods/kubia-0/proxy/"
curl localhost:8001/api/v1/namespaces/chp10-set1031/pods/kubia-0/proxy/
echo ""

echo "SUBMIT DATA TO SERVER:"
echo 'curl -X POST -d "***** DATA:Hey there! This greeting was submitted to kubia-0" localhost:8001/api/v1/namespaces/chp10-set1031/pods/kubia-0/proxy/'
curl -X POST -d "***** DATA:Hey there! This greeting was submitted to kubia-0" localhost:8001/api/v1/namespaces/chp10-set1031/pods/kubia-0/proxy/
echo ""

echo "curl localhost:8001/api/v1/namespaces/chp10-set1031/pods/kubia-0/proxy/"
curl localhost:8001/api/v1/namespaces/chp10-set1031/pods/kubia-0/proxy/
echo ""
echo $HR


echo "kubectl get pvc -n=chp10-set1031"
kubectl get pvc -n=chp10-set1031
echo $HR


MOUNT_PATH=$(kubectl get statefulset kubia -n=chp10-set1031 -o jsonpath={'.spec.template.spec.containers[0].volumeMounts[0].mountPath'})

echo "Confirm data at mountPath: $MOUNT_PATH"

echo "kubectl exec pod/kubia-0 -n=chp10-set1031 -- ls $MOUNT_PATH"
kubectl exec pod/kubia-0 -n=chp10-set1031 -- ls $MOUNT_PATH
echo ""

echo "kubectl exec pod/kubia-0 -n=chp10-set1031 -- cat $MOUNT_PATH/kubia.txt"
kubectl exec pod/kubia-0 -n=chp10-set1031 -- cat $MOUNT_PATH/kubia.txt
echo ""

enter

((i++))
echo "$i. Deleting a Stateful Pod to see if the rescheduled pod is reattached to the same storage"
echo ""

echo "kubectl delete pod kubia-0 -n=chp10-set1031 --now"
kubectl delete pod kubia-0 -n=chp10-set1031 --now
echo ""

echo "kubectl wait --for=condition=Ready=False pod/$POD_0 -n=chp10-set1031 --timeout=41s"
kubectl wait --for=condition=Ready=False pod/$POD_0 -n=chp10-set1031 --timeout=41s


echo "kubectl rollout status sts kubia -n=chp10-set1031"
kubectl rollout status sts kubia -n=chp10-set1031
echo $HR


echo "kubectl exec pod/kubia-0 -n=chp10-set1031 -- cat $MOUNT_PATH/kubia.txt"
kubectl exec pod/kubia-0 -n=chp10-set1031 -- cat $MOUNT_PATH/kubia.txt
echo ""


echo "kubecl get pods -n=chp10-set1031"
kubectl get pods -n=chp10-set1031
echo $HR

echo "kubectl wait --for=condition=Ready=True pod/$POD_0 -n=chp10-set1031 --timeout=41s"
kubectl wait --for=condition=Ready=True pod/$POD_0 -n=chp10-set1031 --timeout=41s
echo $HR

echo "kubectl get pods -n=chp10-set1031"
kubectl get pods -n=chp10-set1031
echo $HR





echo "kubectl exec pod/kubia-0 -n=chp10-set1031 -- ls $MOUNT_PATH"
kubectl exec pod/kubia-0 -n=chp10-set1031 -- ls $MOUNT_PATH 
echo ""
echo "kubectl exec pod/kubia-0 -n=chp10-set1031 -- cat $MOUNT_PATH/kubia.txt"
kubectl exec pod/kubia-0 -n=chp10-set1031 -- cat $MOUNT_PATH/kubia.txt
echo ""


echo "::::BIG TEST::::"
echo "curl localhost:8001/api/v1/namespaces/chp10-set1031/pods/kubia-0/proxy/"
curl localhost:8001/api/v1/namespaces/chp10-set1031/pods/kubia-0/proxy/
echo ""
echo $HR


echo "kubectl get pvc -n=chp10-set1031"
kubectl get pvc -n=chp10-set1031

echo $HR


enter

((i++))
echo "$i. Scaling the StatefulSet"
echo ""

echo "kubectl apply -f set1031-5-kubia-statefulset-replicas4.yaml --record"
kubectl apply -f set1031-5-kubia-statefulset-replicas4.yaml --record
sleep 3
echo $HR


echo "kubectl get pods -n=chp10-set1031"
kubectl get pods -n=chp10-set1031
echo ""

echo "curl localhost:8001/api/v1/namespaces/chp10-set1031/pods/kubia-0/proxy/"
curl localhost:8001/api/v1/namespaces/chp10-set1031/pods/kubia-0/proxy/
echo ""


echo "kubectl get pvc -n=chp10-set1031"
kubectl get pvc -n=chp10-set1031
echo ""


echo $HR

enter

((i++))
echo "$i. Connecting to Cluster-internal services through the API Server"
echo ""

echo "curl localhost:8001/api/v1/namespaces/chp10-set1031/services/kubia-public/proxy/"
curl localhost:8001/api/v1/namespaces/chp10-set1031/services/kubia-public/proxy/
echo ""

echo $HR

enter

((i++))
echo "$i. Listing DNS SRV records of the headless Service"

echo "kubectl run -it srvlookup --image=tutum/dnsutils --rm --restart=Never -- dig SRV kubia.chp10-set1031.svc.cluster.local"
kubectl run -it srvlookup --image=tutum/dnsutils --rm --restart=Never -- dig SRV kubia.chp10-set1031.svc.cluster.local
echo ""


echo $HR

enter

((i++))
echo "$i. Updating a StatefulSet"
echo ""


echo "Need to build a container with the namespace chp10-set1031 hardcoded in"
echo ""

echo "kubectl apply -f set1031-6-kubia-statefulset-image-pet-peers.yaml"
kubectl apply -f set1031-6-kubia-statefulset-image-pet-peers.yaml
echo ""


echo "sleep 5"
sleep 5
echo ""

echo "kubectl get pods -n=chp10-set1031"
kubectl get pods -n=chp10-set1031
echo ""

echo "kubectl delete pods kubia-0 kubia-1 -n=chp10-set1031"
kubectl delete pods kubia-0 kubia-1 -n=chp10-set1031
echo ""

echo $HR

enter

((i++))
echo "$i. Trying out the clustered data store"
echo ""

echo "kubectl wait --for=condition=Ready=True pod/kubia-0 -n=chp10-set1031 --timeout=31s"
kubectl wait --for=condition=Ready=True pod/kubia-0 -n=chp10-set1031 --timeout=31s
echo ""

echo "sleep 3"
sleep 3
echo ""

echo 'curl -X POST -d "The sun is shining" localhost:8001/api/v1/namespaces/chp10-set1031/services/kubia-public/proxy/'
curl -X POST -d "The sun is shining" localhost:8001/api/v1/namespaces/chp10-set1031/services/kubia-public/proxy/
echo ""


echo 'curl -X POST -d "The weather is sweet" localhost:8001/api/v1/namespaces/chp10-set1031/services/kubia-public/proxy/'
curl -X POST -d "The weather is sweet" localhost:8001/api/v1/namespaces/chp10-set1031/services/kubia-public/proxy/
echo ""

echo "sleep 2"
sleep 2
echo ""

echo 'curl localhost:8001/api/v1/namespaces/chp10-set1031/services/kubia-public/proxy/'
curl localhost:8001/api/v1/namespaces/chp10-set1031/services/kubia-public/proxy/
echo ""


echo 'curl localhost:8001/api/v1/namespaces/chp10-set1031/services/kubia-public/proxy/'
curl localhost:8001/api/v1/namespaces/chp10-set1031/services/kubia-public/proxy/
echo ""

echo 'curl localhost:8001/api/v1/namespaces/chp10-set1031/services/kubia-public/proxy/'
curl localhost:8001/api/v1/namespaces/chp10-set1031/services/kubia-public/proxy/
echo ""

echo $HR

enter

((i++))
echo "$i. Deleting namespace"
echo ""

echo "Remove port forward process"
echo "killall kubectl"
killall kubectl
echo $HR

echo "kubectl delete -f $FULLPATH -now"
kubectl delete -f $FULLPATH --now --ignore-not-found
kubectl delete pv -l set=chp10-set1031 --ignore-not-found
kubectl delete statefulset -n=chp10-set1031 --ignore-not-found
kubectl delete pvc -n=chp10-set1031 --ignore-not-found
echo $HR

