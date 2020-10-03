#!/bin/bash
. ~/src/SETUP.sh
FULLPATH=$(pwd)

echo "Run this in a separate terminal:"
echo "kubectl get events -n=chp10-set1031 -w"
echo ""

echo "Cleaning up.."
kubectl delete pv -l set=chp10-set1031 --now
kubectl delete statefulset --all -n=chp10-set1031 --now
kubectl delete pvc --all -n=chp10-set1031 --now
kubectl delete -f $FULLPATH --now --ignore-not-found
sleep 1


enter

((i++))
echo "$i. Create resources."
echo "kubectl apply -f $FULLPATH"
kubectl apply -f $FULLPATH/set1031-0-ns.yaml
kubectl apply -f $FULLPATH/set1031-2-kubia-service-headless.yaml
kubectl apply -f $FULLPATH/set1031-3-kubia-statefulset.yaml --record
sleep 1

echo $HR

echo "kubectl rollout status sts kubia -n=chp10-set1031"
kubectl rollout status sts kubia -n=chp10-set1031
echo $HR

POD_0=$(kubectl get pod -n=chp10-set1031 -o jsonpath={'.items[0].metadata.name'})

echo "kubectl get pods -n=chp10-set1031 -o wide"
kubectl get pods -n=chp10-set1031 -o wide
echo $HR

echo "kubectl get pvc -n=chp10-set1031"
kubectl get pvc -n=chp10-set1031
echo $HR

echo "kubectl get pv"
kubectl get pv
echo $HR

echo "kubectl get sc"
kubectl get sc

enter

((i++))
echo "$i. Listing DNS SRV records of the headless Service"

echo "kubectl run -it srvlookup --image=tutum/dnsutils --rm --restart=Never -- dig SRV kubia.chp10-set1031.svc.cluster.local"
kubectl run -it srvlookup --image=tutum/dnsutils --rm --restart=Never -- dig SRV kubia.chp10-set1031.svc.cluster.local
echo ""

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

enter

((i++))
echo "$i. Deleting namespace"
echo ""


echo "kubectl delete -f $FULLPATH -now"
kubectl delete -f $FULLPATH
kubectl delete pv -l set=chp10-set1031
kubectl delete statefulset -n=chp10-set1031
kubectl delete pvc -n=chp10-set1031

