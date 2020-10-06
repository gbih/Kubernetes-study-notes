#!/bin/bash
. ~/src/COMMON/SETUP.sh
FULLPATH=$(pwd)

echo $HR_TOP

echo "kubectl apply -f $FULLPATH"
kubectl apply -f $FULLPATH
echo $HR

value=$(<set641-1-mongodb-pod-hostpath.yaml)
echo "$value"
enter

value=$(<set641-2-svc.yaml)
echo "$value"
enter

POD0=$(kubectl get pods -n=chp06-set641 -o jsonpath={'.items[0].metadata.name'})
echo "kubectl wait --for=condition=Ready=True pod/\$POD0 -n=chp06-set641 --timeout=20s"
kubectl wait --for=condition=Ready=True pod/$POD0 -n=chp06-set641 --timeout=20s

echo $HR

NODE0=$(kubectl get node -o jsonpath='{.items[0].metadata.name}')

echo "We mount the hostPath /tmp/mongodb on this node, $NODE0"
echo "kubectl get node"
kubectl get node
echo $HR

echo "Check volume /tmp/mongodb on this node, $NODE0"
echo "ls /tmp/mongodb"
ls /tmp/mongodb

echo $HR

echo "kubectl get all -n=chp06-set641 --show-labels"
kubectl get all -n=chp06-set641 --show-labels
echo ""

echo "kubectl get endpoints -n=chp06-set641"
kubectl get endpoints -n=chp06-set641

enter

echo "kubectl exec pod/mongodb -c mongodb -n=chp06-set641 -- ls /data/db"
kubectl exec pod/mongodb -c mongodb -n=chp06-set641 -- ls /data/db 
echo $HR

enter

echo 'kubectl exec mongodb -c mongodb -n=chp06-set641 -- mongo --eval="printjson(db.mystore.insert({name: 'foo'}))"'
echo ""
kubectl exec mongodb -c mongodb -n=chp06-set641 -- mongo --eval="printjson(db.mystore.insert({name: 'foo'}))"
echo $HR

echo 'kubectl exec mongodb -c mongodb -n=chp06-set641 -- mongo --eval="rs.secondaryOk(); db.mystore.find().forEach(printjson)"'
echo ""
kubectl exec mongodb -c mongodb -n=chp06-set641 -- mongo --eval="rs.secondaryOk(); db.mystore.find().forEach(printjson)"
echo $HR

echo "kubectl delete pod mongodb -n=chp06-set641"
kubectl delete pod mongodb -n=chp06-set641
echo ""

echo "kubectl apply -f set641-1-mongodb-pod-hostpath.yaml"
kubectl apply -f $FULLPATH/set641-1-mongodb-pod-hostpath.yaml
echo ""

enter

POD0=$(kubectl get pods -n=chp06-set641 -o jsonpath={'.items[0].metadata.name'})
echo "kubectl wait --for=condition=Ready=True pod/\$POD0 -n=chp06-set641 --timeout=20s"
kubectl wait --for=condition=Ready=True pod/$POD0 -n=chp06-set641 --timeout=20s
echo ""

echo "sleep 3"
sleep 3

echo $HR

echo 'kubectl exec mongodb -c mongodb -n=chp06-set641 -- mongo --eval="rs.secondaryOk(); db.mystore.find().forEach(printjson)"'
echo ""
kubectl exec mongodb -c mongodb -n=chp06-set641 -- mongo --eval="rs.secondaryOk(); db.mystore.find().forEach(printjson)"
echo $HR

echo "kubectl delete -f $FULLPATH"
kubectl delete -f $FULLPATH
