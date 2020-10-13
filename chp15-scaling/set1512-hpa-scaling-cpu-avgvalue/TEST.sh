#!/bin/bash
. ~/src/common/setup.sh
FULLPATH=$(pwd)
echo "14.5.3 Limiting the number of objects that can be created"
echo $HR_TOP


echo "kubectl apply -f $FULLPATH"
kubectl apply -f $FULLPATH

echo $HR

echo "kubectl wait --for=condition=Ready=True pods/curl-restrictive -n=chp15-set1512 --timeout=10s"
kubectl wait --for=condition=Ready=True pods/curl-restrictive -n=chp15-set1512 --timeout=10s

echo $HR

echo "In a separate terminal, run ./WATCH.sh to monitor various objects"

echo $HR

enter

echo "kubectl rollout status deployment kubia-deploy -n=chp15-set1512"
kubectl rollout status deployment kubia-deploy -n=chp15-set1512

echo $HR

echo "kubectl get all -n=chp15-set1512"
kubectl get all -n=chp15-set1512

enter

echo "Check PSP is set-up correctly by getting HPA from API server."
echo "We use RoleBinding with Role resource and ServiceAccount"
echo ""
echo "kubectl exec -it curl-restrictive -n=chp15-set1512 -- curl localhost:8001/apis/autoscaling/v1/namespaces/chp15-set1512/horizontalpodautoscalers/kubia | jq 'del(.metadata.managedFields, .metadata.annotations, .metadata.apiVersion)'"
echo ""

kubectl exec -it curl-restrictive -n=chp15-set1512 -- curl localhost:8001/apis/autoscaling/v1/namespaces/chp15-set1512/horizontalpodautoscalers/kubia | jq 'del(.metadata.managedFields, .metadata.annotations, .metadata.apiVersion)'

enter

echo "Wait for HPA to scale deployment pods down to 1. This might take 2-3 minutes"
while [[ $(kubectl get deployments -n=chp15-set1512 -o jsonpath={.items[0].status.availableReplicas}) > 1 ]]
do
  kubectl get deployment/kubia-deploy -n=chp15-set1512 --template 'Available Relicas: {{.status.availableReplicas}}{{"\n"}}'
  sleep 10
done

echo $HR
echo "Done scaling down.."
kubectl get deployments -n=chp15-set1512
echo $HR

enter

echo "In another terminal, run ./GO.sh"

echo "Run a load-generating pod"
echo "Use 'ctrl-c' to escape"
echo ""

echo 'do
  # POSIX portable syntax
  kubectl exec -it curl-restrictive -n=chp15-set1512 -- sh -c "for i in \`seq 1 1000\`; do curl kubia.chp15-set1512.svc.cluster.local; done"
  sleep 2
done
'

enter

while [[ $(kubectl get deployments -n=chp15-set1512 -o jsonpath={.items[0].status.availableReplicas}) < 3 ]]
do
  # POSIX portable syntax
  kubectl exec -it curl-restrictive -n=chp15-set1512 -- sh -c "for i in \`seq 1 1000\`; do curl kubia.chp15-set1512.svc.cluster.local; done"
  sleep 2
done

echo $HR
echo "Done scaling up.."

echo "Press enter to delete objects"

enter

#echo "kubectl get events -n=chp15-set1512 | grep \"horizontalpodautoscaler\""
#kubectl get events -n=chp15-set1512 | grep "horizontalpodautoscaler"

echo "kubectl delete -f $FULLPATH"
kubectl delete -f $FULLPATH --ignore-not-found

