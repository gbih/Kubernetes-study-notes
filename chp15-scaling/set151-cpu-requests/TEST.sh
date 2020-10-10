#!/bin/bash
. ~/src/common/setup.sh
FULLPATH=$(pwd)


((i++))

cat <<- "NOTES"
Use this setting in kube-apiserver in /var/snap/microk8s/current/args/kube-apiserver:
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
kubectl apply -f $FULLPATH/psp.yaml
kubectl apply -f $FULLPATH/set151-00-sa.yaml
kubectl apply -f $FULLPATH/set151-2-deployment.yaml
kubectl apply -f $FULLPATH/set151-3-regular-pod.yaml
echo $HR

echo "We created a regular Deployment object that doesn't use autoscaling yet."
echo "To enable horizontal autoscaling of a Deployment's pods, we need to create a HorizontalPodAutoscaler (HPA) object and point it to the Deployment."

echo $HR

echo "This is a regular Deployment object that doesn't use autoscaling yet:"

kubectl get all -n=chp15-set151
sleep 2

enter

echo "To enable horizontal autoscaling of a Deployment's pods, we need to create a HorizontalPodAutoscaler (HPA) object and point it to the Deployment."

#echo "kubectl autoscale -n=chp15-set151 deployment kubia --cpu-percent=30 --min=1  --max=5"
#kubectl autoscale -n=chp15-set151 deployment kubia --cpu-percent=30 --min=1  --max=5

enter

kubectl -n=chp15-set151 get hpa

echo $HR

kubectl describe hpa -n=chp15-set151

enter

echo "kubectl expose deployment kubia --port=80 --target-port=8080 -n=chp15-set151"
kubectl expose deployment kubia --port=80 --target-port=8080 -n=chp15-set151

enter

#echo "watch -n 1 kubectl get hpa,deployment -n=chp15-set151"
#enter

#watch -n 1 kubectl get hpa,deployment -n=chp15-set151

echo $HR

kubectl get pods -n=chp15-set151

#echo "kubectl delete -f $FULLPATH"
#kubectl delete -f $FULLPATH
