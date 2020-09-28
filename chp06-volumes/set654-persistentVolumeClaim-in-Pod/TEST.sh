#!/bin/bash
. ~/src/SETUP.sh
FULLPATH=$(pwd)
echo $HR_TOP

kubectl apply -f $FULLPATH
echo $HR

echo "kubectl wait --for=condition=Ready=True pod mongodb -n=chp06-set654 --timeout=20s"
kubectl wait --for=condition=Ready=True pod mongodb -n=chp06-set654 --timeout=20s
echo $HR

echo "kubectl get pods -n=chp06-set654"
kubectl get pods -n=chp06-set654
echo ""

echo "kubectl get pv -l app=mongodb-pv"
kubectl get pv -l app=mongodb-pv
echo ""

echo "kubectl get pvc -n=chp06-set654"
kubectl get pvc -n=chp06-set654
echo $HR

enter

echo "kubectl describe pod/mongodb -n=chp06-set654"
kubectl describe pod/mongodb -n=chp06-set654

enter

echo 'kubectl exec mongodb -c mongodb -n=chp06-set654 -- mongo --eval="printjson(db.mystore.insert({ mydate: new Date() }))"'
kubectl exec mongodb -c mongodb -n=chp06-set654 -- \
mongo --eval="printjson(db.mystore.insert({ mydate: new Date() }))"
echo ""

echo $HR

echo 'kubectl exec mongodb -c mongodb -n=chp06-set654 -- mongo --eval="rs.secondaryOk(); db.mystore.find({}, {mydate:1, _id:0}).forEach(printjson)"'
kubectl exec mongodb -c mongodb -n=chp06-set654 -- \
mongo --eval="rs.secondaryOk(); db.mystore.find({}, {mydate:1, _id:0}).forEach(printjson)"

enter

echo "kubectl delete -f $FULLPATH/set654-3-mongodb-pod-pvc.yaml"
kubectl delete -f $FULLPATH/set654-3-mongodb-pod-pvc.yaml
echo ""

sleep 1

echo "kubectl apply -f $FULLPATH/set654-3-mongodb-pod-pvc.yaml"
kubectl apply -f $FULLPATH/set654-3-mongodb-pod-pvc.yaml
echo ""

sleep 1

echo "kubectl wait --for=condition=Ready=True pod mongodb -n=chp06-set654 --timeout=21s"
kubectl wait --for=condition=Ready=True pod mongodb -n=chp06-set654 --timeout=21s

echo $HR

sleep 1

echo 'kubectl exec mongodb -c mongodb -n=chp06-set654 -- mongo --eval="rs.secondaryOk(); db.mystore.find({}, {mydate:1, _id:0}).forEach(printjson)"'
kubectl exec mongodb -c mongodb -n=chp06-set654 -- \
mongo --eval="rs.secondaryOk(); db.mystore.find({}, {mydate:1, _id:0}).forEach(printjson)"

enter

echo "kubectl get events -n=chp06-set654"
kubectl get events -n=chp06-set654
echo $HR

echo "Clean up database..."
echo "kubectl exec mongodb -c mongodb -n=chp06-set654 -- mongo --eval=\"printjson(db.mystore.remove({}))\""
kubectl exec mongodb -c mongodb -n=chp06-set654 -- \
mongo --eval="printjson(db.mystore.remove({}))"

echo $HR

echo "kubectl delete -f $FULLPATH"
kubectl delete -f $FULLPATH

