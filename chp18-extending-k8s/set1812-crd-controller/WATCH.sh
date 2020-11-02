!/bin/sh
clear

HR=$(printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -)
HR_TOP=$(printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' "=")

NODE_IP=$(kubectl get node actionbook-vm -o jsonpath={.status.addresses[0].address})
SITE_IP="http://$NODE_IP:30007"

CURL_TEST=$(curl -o /dev/null -s -w "time:%{time_total}, code:%{http_code}" $SITE_IP)

watch -n 1 -d -t "echo $HR_TOP; \
echo "Site deployed at " $SITE_IP; \
curl -o /dev/null -s -w "code:%{http_code}" $SITE_IP; echo ""; \
echo $HR; \
kubectl get clusterrole clusterrole-psp -L type; \
kubectl get clusterrolebinding restricted -L type; \
kubectl get psp restricted -L type; \
echo $HR; \
kubectl get crd -n=chp18-set1812 -L type; \
echo $HR; \
echo "TEST"; \
kubectl get deployment -n=chp18-set1812 -L type; \
kubectl get website  -n chp18-set1812 -o custom-columns=NAME:metadata.name,NAMESPACE:metadata.namespace,SERVICEACCOUNTNAME:spec.serviceAccountName,KIND:kind,LABEL:metadata.labels; \
echo $HR; \
kubectl get svc -n=chp18-set1812 -L type; \
kubectl get pods -n=chp18-set1812 -L type; \
echo $HR; \
kubectl get events -n=chp18-set1812 | tac; \
echo $HR_TOP"

# kubectl get events -n=chp18-set1812 --sort-by=.metadata.creationTimestamp | tac | grep \"horizontalpodautoscaler\"; \
