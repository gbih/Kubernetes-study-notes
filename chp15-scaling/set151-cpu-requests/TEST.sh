#!/bin/bash
. ~/src/common/setup.sh
FULLPATH=$(pwd)


((i++))

cat <<- "NOTES"
Use this setting in kube-apiserver in /var/snap/microk8s/current/args/kube-controller-manager
--horizontal-pod-autoscaler-use-rest-clients=true

microk8s.enable metrics-server
metrics-server: enabled

Reference:
https://github.com/ubuntu/microk8s/blob/master/microk8s-resources/actions/metrics-server.yaml

NOTES

enter

echo "$i. Deploy the app"
echo ""
kubectl apply -f $FULLPATH/set151-0-ns.yaml
kubectl apply -f $FULLPATH/set151-0-psp.yaml
kubectl apply -f $FULLPATH/set151-1-sa.yaml
kubectl apply -f $FULLPATH/set151-3-deployment.yaml --record=true
kubectl apply -f $FULLPATH/set151-5-regular-pod.yaml --record=true
echo $HR

echo "We created a regular Deployment object that doesn't use autoscaling yet."
echo "To enable horizontal autoscaling of a Deployment's pods, we need to create a HorizontalPodAutoscaler (HPA) object and point it to the Deployment."

echo $HR
echo "kubectl rollout status deployment kubia -n=chp15-set151"
kubectl rollout status deployment kubia -n=chp15-set151


echo $HR

echo "This is a regular Deployment object that doesn't use autoscaling yet:"

kubectl get all -n=chp15-set151
sleep 2

enter

echo "To enable horizontal autoscaling of a Deployment's pods, we need to create a HorizontalPodAutoscaler (HPA) object and point it to the Deployment."
echo ""

value=$(<set151-4-ha.yaml)
echo "$value"
echo $HR


echo "kubectl apply -f $FULLPATH/set151-4-ha.yaml"
kubectl apply -f $FULLPATH/set151-4-ha.yaml

enter

kubectl get hpa -n=chp15-set151

echo $HR

echo "kubectl apply -f $FULLPATH/set151-2-svc.yaml"
kubectl apply -f $FULLPATH/set151-2-svc.yaml


#echo "watch -n 1 kubectl get hpa,deployment -n=chp15-set151"
#enter
#watch -n 1 kubectl get hpa,deployment -n=chp15-set151

echo $HR

kubectl get pods -n=chp15-set151

echo $HR

kubectl describe hpa -n=chp15-set151

enter

#echo "kubectl delete -f $FULLPATH"
#kubectl delete -f $FULLPATH --force --grace-period=0
