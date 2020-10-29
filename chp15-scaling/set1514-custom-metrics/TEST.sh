#!/bin/bash
. ~/src/common/setup.sh
FULLPATH=$(pwd)
echo "15.1.4 Scaling based on other and custom metrics"
echo ""
echo "These custom metrics may have names which are cluster specific, and require a more advanced cluster monitoring setup, such as Prometheus. The metrics-server looks like it does not handle these metrics."

echo $HR_TOP


echo "kubectl apply -f $FULLPATH"
kubectl apply -f $FULLPATH

echo $HR

echo "kubectl wait --for=condition=Ready=True pods/curl-restrictive -n=chp15-set1514 --timeout=10s"
kubectl wait --for=condition=Ready=True pods/curl-restrictive -n=chp15-set1514 --timeout=10s

enter

echo "In a separate terminal, run ./WATCH.sh to monitor various objects"

echo $HR

enter

echo "kubectl rollout status deployment kubia-deploy -n=chp15-set1514"
kubectl rollout status deployment kubia-deploy -n=chp15-set1514

echo $HR

echo "kubectl get all -n=chp15-set1514"
kubectl get all -n=chp15-set1514

enter

echo "Check PSP is set-up correctly by getting HPA from API server."
echo "We use RoleBinding with Role resource and ServiceAccount"
echo ""
echo "kubectl exec -it curl-restrictive -n=chp15-set1514 -- curl localhost:8001/apis/autoscaling/v1/namespaces/chp15-set1514/horizontalpodautoscalers/kubia | jq 'del(.metadata.managedFields, .metadata.annotations, .metadata.apiVersion)'"
echo ""

kubectl exec -it curl-restrictive -n=chp15-set1514 -- curl localhost:8001/apis/autoscaling/v1/namespaces/chp15-set1514/horizontalpodautoscalers/kubia | jq 'del(.metadata.managedFields, .metadata.annotations, .metadata.apiVersion)'

#enter

#echo "Wait for HPA to scale deployment pods down to 1. This might take 2-3 minutes"
#while [[ $(kubectl get deployments -n=chp15-set1514 -o jsonpath={.items[0].status.availableReplicas}) > 1 ]]
#do
#  kubectl get deployment/kubia-deploy -n=chp15-set1514 --template 'Available Relicas: {{.status.availableReplicas}}{{"\n"}}'
#  sleep 10
#done

#echo $HR
#echo "Done scaling down.."
#kubectl get deployments -n=chp15-set1514
#echo $HR

#enter

#echo "In another terminal, run ./GO.sh"

#echo "Run a load-generating pod"
#echo "Use 'ctrl-c' to escape"
#echo ""

#echo 'do
#  # POSIX portable syntax
#  kubectl exec -it curl-restrictive -n=chp15-set1514 -- sh -c "for i in \`seq 1 1000\`; do curl kubia.chp15-set1514.svc.cluster.local; done"
#  sleep 2
#done
#'

enter

#while [[ $(kubectl get deployments -n=chp15-set1514 -o jsonpath={.items[0].status.availableReplicas}) < 3 ]]
#do
  # POSIX portable syntax
#  kubectl exec -it curl-restrictive -n=chp15-set1514 -- sh -c "for i in \`seq 1 1000\`; do curl kubia.chp15-set1514.svc.cluster.local; done"
#  sleep 2
#done

#echo $HR
#echo "Done scaling up.."

echo "Press enter to delete objects"

enter

#echo "kubectl get events -n=chp15-set1514 | grep \"horizontalpodautoscaler\""
#kubectl get events -n=chp15-set1514 | grep "horizontalpodautoscaler"

echo "kubectl delete -f $FULLPATH"
kubectl delete -f $FULLPATH --ignore-not-found

