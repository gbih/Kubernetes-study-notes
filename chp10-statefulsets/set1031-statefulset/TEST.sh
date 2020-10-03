#!/bin/bash
. ~/src/SETUP.sh
FULLPATH=$(pwd)
echo $HR_TOP

echo "Run this in a separate terminal:"
echo "kubectl get events -n=chp10-set1031 -w"

enter

((i++))
echo "$i. Create resources."
echo "kubectl apply -f $FULLPATH"
kubectl apply -f $FULLPATH/set1031-0-ns.yaml
kubectl apply -f $FULLPATH/set1031-1-pv-hostpath.yaml
kubectl apply -f $FULLPATH/set1031-2-kubia-service-headless.yaml
kubectl apply -f $FULLPATH/set1031-3-kubia-statefulset.yaml --record
kubectl apply -f $FULLPATH/set1031-4-kubia-service-public.yaml
sleep 2

echo $HR

echo "kubectl rollout status sts kubia -n=chp10-set1031"
kubectl rollout status sts kubia -n=chp10-set1031

enter

POD_0=$(kubectl get pod -n=chp10-set1031 -o jsonpath={'.items[0].metadata.name'})

echo "kubectl get all -n=chp10-set1031 --show-labels"
kubectl get all -n=chp10-set1031 --show-labels
echo ""

echo "kubectl get pvc -n=chp10-set1031 --show-labels"
kubectl get pvc -n=chp10-set1031 --show-labels
echo $HR

enter

((i++))
echo "$i. Communicating with the API Server via 'kubectl proxy'"
echo ""

echo "kubectl proxy --port=8001 &"
kubectl proxy --port=8001 &
echo $HR

sleep 3

echo "curl localhost:8001/api/v1/namespaces/chp10-set1031/pods/kubia-0/proxy/"
curl localhost:8001/api/v1/namespaces/chp10-set1031/pods/kubia-0/proxy/
echo $HR

echo "Submit data to server"
echo ""
echo 'curl -X POST -d "***** DATA:Hey there! This greeting was submitted to kubia-0" localhost:8001/api/v1/namespaces/chp10-set1031/pods/kubia-0/proxy/'
curl -X POST -d "***** DATA:Hey there! This greeting was submitted to kubia-0" localhost:8001/api/v1/namespaces/chp10-set1031/pods/kubia-0/proxy/
echo $HR

echo "Read data from server"
echo ""
echo "curl localhost:8001/api/v1/namespaces/chp10-set1031/pods/kubia-0/proxy/"
curl localhost:8001/api/v1/namespaces/chp10-set1031/pods/kubia-0/proxy/
echo $HR

echo "Check state of other pod (nothing should be stored yet)"
echo ""

echo "curl localhost:8001/api/v1/namespaces/chp10-set1031/pods/kubia-1/proxy/"
curl localhost:8001/api/v1/namespaces/chp10-set1031/pods/kubia-1/proxy/
echo $HR

enter

((i++))
echo "$i. Deleting a Stateful Pod to see if the rescheduled pod is reattached to the same storage"
echo "" 

echo "kubectl delete pod kubia-0 -n=chp10-set1031 --now"
kubectl delete pod kubia-0 -n=chp10-set1031 --now
echo $HR


echo "kubectl get pods -n=chp10-set1031"
kubectl get pods -n=chp10-set1031
echo $HR

echo "Should see new pod (with same name) being rescheduled"
echo "kubectl rollout status sts kubia -n=chp10-set1031"
kubectl rollout status sts kubia -n=chp10-set1031
echo $HR

echo "kubecl get pods -n=chp10-set1031"
kubectl get pods -n=chp10-set1031
echo $HR

echo "kubectl wait --for=condition=Ready=True pod/$POD_0 -n=chp10-set1031 --timeout=21s"
kubectl wait --for=condition=Ready=True pod/$POD_0 -n=chp10-set1031 --timeout=21s
echo $HR

echo "Check pod name, hostname, persistent data"
echo ""
echo "curl localhost:8001/api/v1/namespaces/chp10-set1031/pods/kubia-0/proxy/"
curl localhost:8001/api/v1/namespaces/chp10-set1031/pods/kubia-0/proxy/

enter

((i++))
echo "$i. Scaling the StatefulSet (increase replias to 4)"
echo ""

echo "kubectl apply -f set1031-5-kubia-statefulset-replicas4.yaml --record"
kubectl apply -f set1031-5-kubia-statefulset-replicas4.yaml --record
sleep 3
echo $HR

echo "kubectl get pods -n=chp10-set1031"
kubectl get pods -n=chp10-set1031
echo $HR

echo "curl localhost:8001/api/v1/namespaces/chp10-set1031/pods/kubia-0/proxy/"
curl localhost:8001/api/v1/namespaces/chp10-set1031/pods/kubia-0/proxy/
echo $HR

echo "kubectl get pvc -n=chp10-set1031"
kubectl get pvc -n=chp10-set1031

echo $HR

enter

((i++))
echo "$i. Connecting to Cluster-internal services through the API Server"
echo "Each request lands on a random cluster node, so you’ll get the data from a random node each time."
echo ""

echo "curl localhost:8001/api/v1/namespaces/chp10-set1031/services/kubia-public/proxy/"
curl localhost:8001/api/v1/namespaces/chp10-set1031/services/kubia-public/proxy/
echo ""

echo "curl localhost:8001/api/v1/namespaces/chp10-set1031/services/kubia-public/proxy/"
curl localhost:8001/api/v1/namespaces/chp10-set1031/services/kubia-public/proxy/
echo ""

echo "curl localhost:8001/api/v1/namespaces/chp10-set1031/services/kubia-public/proxy/"
curl localhost:8001/api/v1/namespaces/chp10-set1031/services/kubia-public/proxy/
echo ""

echo "curl localhost:8001/api/v1/namespaces/chp10-set1031/services/kubia-public/proxy/"
curl localhost:8001/api/v1/namespaces/chp10-set1031/services/kubia-public/proxy/
echo ""

echo "curl localhost:8001/api/v1/namespaces/chp10-set1031/services/kubia-public/proxy/"
curl localhost:8001/api/v1/namespaces/chp10-set1031/services/kubia-public/proxy/
echo ""

echo $HR

enter

((i++))
echo "$i. Discovering peers in a StatefulSet via headless Service DNS SRV records"
echo "Kubernetes creates SRV records to point to the hostnames of the pods backing a headless service."
echo ""

echo "kubectl run -it srvlookup --image=georgebaptista/dnsutils --rm --restart=Never -- dig SRV kubia.chp10-set1031.svc.cluster.local"
kubectl run -it srvlookup --image=georgebaptista/dnsutils --rm --restart=Never -- dig SRV kubia.chp10-set1031.svc.cluster.local

enter

echo "The command runs a one-off pod (--restart=Never) called curl-pod, which is attached to the console (-it) and is deleted as soon as it terminates (--rm). The pod runs a single container from the georgebaptista/dnsutils image and runs the specified following command."
echo ""

echo "kubectl run -it curl-pod --image=georgebaptista/curl --rm --restart=Never -- sh -c 'curl kubia.chp10-set1031.svc.cluster.local:8080'
"
kubectl run -it curl-pod --image=georgebaptista/curl --rm --restart=Never -- sh -c 'curl kubia.chp10-set1031.svc.cluster.local:8080'

enter

echo "kubectl run -it curl-pod --image=georgebaptista/curl --rm --restart=Never -- curl kubia.chp10-set1031.svc.cluster.local:8080"

kubectl run -it curl-pod --image=georgebaptista/curl --rm --restart=Never -- curl kubia.chp10-set1031.svc.cluster.local:8080

enter

((i++))
echo "$i. Updating a StatefulSet"
echo ""

echo "Need to use a container with the namespace chp10-set1031 hardcoded in"
echo ""

echo "kubectl apply -f set1031-6-kubia-statefulset-image-pet-peers.yaml"
kubectl apply -f set1031-6-kubia-statefulset-image-pet-peers.yaml
echo $HR

echo "kubectl get pods -n=chp10-set1031"
kubectl get pods -n=chp10-set1031
echo $HR

echo "kubectl delete pods kubia-0 kubia-1 -n=chp10-set1031"
kubectl delete pods kubia-0 kubia-1 -n=chp10-set1031

enter

((i++))
echo "$i. Trying out the clustered data store"
echo ""

echo "kubectl wait --for=condition=Ready=True pod/kubia-0 -n=chp10-set1031 --timeout=31s"
kubectl wait --for=condition=Ready=True pod/kubia-0 -n=chp10-set1031 --timeout=31s
echo $HR

echo 'curl -X POST -d "The sun is shining" localhost:8001/api/v1/namespaces/chp10-set1031/services/kubia-public/proxy/'
curl -X POST -d "The sun is shining" localhost:8001/api/v1/namespaces/chp10-set1031/services/kubia-public/proxy/
echo ""

echo 'curl -X POST -d "The weather is sweet" localhost:8001/api/v1/namespaces/chp10-set1031/services/kubia-public/proxy/'
curl -X POST -d "The weather is sweet" localhost:8001/api/v1/namespaces/chp10-set1031/services/kubia-public/proxy/
echo ""

echo 'curl localhost:8001/api/v1/namespaces/chp10-set1031/services/kubia-public/proxy/'
curl localhost:8001/api/v1/namespaces/chp10-set1031/services/kubia-public/proxy/
echo ""

echo 'curl localhost:8001/api/v1/namespaces/chp10-set1031/services/kubia-public/proxy/'
curl localhost:8001/api/v1/namespaces/chp10-set1031/services/kubia-public/proxy/
echo ""

echo 'curl localhost:8001/api/v1/namespaces/chp10-set1031/services/kubia-public/proxy/'
curl localhost:8001/api/v1/namespaces/chp10-set1031/services/kubia-public/proxy/

enter

((i++))
echo "$i. Deleting namespace"
echo ""

echo "Remove proxy process"
echo "kill -9 \`sudo fuser 8001/tcp|xargs -n 1\`"
kill -9 `sudo fuser 8001/tcp|xargs -n 1`
sleep 1

echo $HR

echo "kubectl delete ns chp10-set1031"
kubectl delete ns chp10-set1031
