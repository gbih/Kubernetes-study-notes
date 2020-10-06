#!/bin/bash
. ~/src/common/setup.sh
FULLPATH=$(pwd)

cat <<- 'NOTES'
Tests for Section: Manually Replicated MongoDB with StatefulSets
Deploy a replicated MongoDB cluster

NOTES
((i++))


kubectl delete -f $FULLPATH --now --ignore-not-found
echo $HR

echo "$i. Create Resources"

echo "kubectl apply -f $FULLPATH"
kubectl apply -f $FULLPATH/set1510-0-ns.yaml
kubectl apply -f $FULLPATH/mongo-configmap.yaml
kubectl apply -f $FULLPATH/set1510-1-mongo-ss.yaml --record
kubectl apply -f $FULLPATH/set1510-2-mongo-headless-service.yaml
sleep 3

echo $HR

enter
echo "kubectl describe pod/mongo-0 -n=chp10-set1510"
kubectl describe pod/mongo-0 -n=chp10-set1510

enter

#echo "kubectl rollout status sts mongo -n=chp10-set1510"
#kubectl rollout status sts mongo -n=chp10-set1510
#echo $HR


POD_0=$(kubectl get pod -n=chp10-set1510 -o jsonpath={'.items[0].metadata.name'})
#
echo "kubectl wait --for=condition=Ready=True pod/$POD_0 -n=chp10-set1510 --timeout=21s"
kubectl wait --for=condition=Ready=True pod/$POD_0 -n=chp10-set1510 --timeout=21s
echo ""

enter

echo "kubectl get storageclass"
kubectl get storageclass
echo ""

echo "kubectl get pv"
kubectl get pv
echo ""

echo "kubectl get pvc -n=chp10-set1510"
kubectl get pvc -n=chp10-set1510
echo ""

echo "kubectl get pods -n=chp10-set1510"
kubectl get pods -n=chp10-set1510
echo ""

echo "kubectl get service -n=chp10-set1510"
kubectl get service -n=chp10-set1510
echo ""

echo "kubectl get statefulset -n=chp10-set1510"
kubectl get statefulset -n=chp10-set1510
echo ""

enter

echo "Confirm init-mongo volume:"
echo ""
echo "kubectl -n=chp10-set1510 -it exec mongo-0 -c init-mongo -- sh -c 'cat /config/init.sh'"
kubectl -n=chp10-set1510 -it exec mongo-0 -c init-mongo -- sh -c 'cat /config/init.sh'

enter

#################################


((i++))
echo "$i. Confirm DNS"
echo ""

echo "Get db.serverStatus().host"
echo ""
echo 'kubectl exec mongo-0  -n=chp10-set1510 -- mongo --eval="printjson(db.serverStatus().host)"'
kubectl exec mongo-0  -n=chp10-set1510 -- mongo --eval="printjson(db.serverStatus().host)"

echo $HR

((i++))


echo "$i. Check DNS entries via attached container."
echo ""
echo "kubectl run -it busybox --image=busybox --rm --restart=Never  -n=chp10-set1510 -- ping mongo-1.mongo -w 5"
kubectl run -it busybox --image=busybox --rm --restart=Never -n=chp10-set1510 -- ping mongo-1.mongo -w 5
#echo ""
#echo "Tell mongodb to initiate the ReplicaSet rs0 with mongo-0.mongo as the primary replica"


enter

((i++))
echo "$i. Manually set up Mongo replication using these per-Pod hostnames"
echo ""
echo "Choose mongo-0.mongo to be our initial primary and run the mongo tool in that Pod"
echo "This command tells mongodb to initiate the ReplicaSet rs0 with mongo-0.mongo as the primary replica"
echo ""
echo "kubectl exec mongo-0  -n=chp10-set1510 -- mongo --eval='rs.initiate( {_id: \"rs0\", members:[ { _id: 0, host: \"mongo-0.mongo:27017\" } ] })'"
kubectl exec mongo-0  -n=chp10-set1510 -- mongo --eval='rs.initiate( {_id: "rs0", members:[ { _id: 0, host: "mongo-0.mongo:27017" } ] })'


enter

((i++))
echo "$i. Add the remaining replicas"
echo ""

echo "rs.add(mongo01.mongo:27017)"
kubectl exec mongo-0 -n=chp10-set1510 -- mongo --eval='rs.add("mongo-1.mongo:27017")'
echo ""

echo  "rs.add(mongo02-mongo:27017)"
kubectl exec mongo-0 -n=chp10-set1510 -- mongo --eval='rs.add("mongo-2.mongo:27017")'
echo ""


echo $HR


echo "kubectl delete -f $FULLPATH --now --ignore-not-found"
kubectl delete -f $FULLPATH --now --ignore-not-found
echo $HR
