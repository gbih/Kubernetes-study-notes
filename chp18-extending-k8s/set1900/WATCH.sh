!/bin/sh
clear

HR=$(printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -)
HR_TOP=$(printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' "=")

NODE_IP=$(kubectl get node actionbook-vm -o jsonpath={.status.addresses[0].address})
SITE_IP="http://$NODE_IP:30007"

CURL_TEST=$(curl -o /dev/null -s -w "time:%{time_total}, code:%{http_code}" $SITE_IP)

watch -n 1 -d -t "echo $HR_TOP; \
echo "Site deployed at " $SITE_IP; \
echo $CURL_TEST; \
echo $HR; \
kubectl get clusterrole clusterrole-psp; \
kubectl get clusterrolebinding restricted; \
kubectl get psp restricted; \
echo $HR; \
kubectl get crd -n=chp18-set1900; \
echo $HR; \
kubectl get deployment -n=chp18-set1900; \
kubectl get websites -n=chp18-set1900 -o wide; \
kubectl get svc -n=chp18-set1900 -o wide; \
kubectl get pods -n=chp18-set1900 -o wide; \
echo $HR; \
kubectl get events -n=chp18-set1900 -o custom-columns=LastSeen:.lastTimestamp,From:.source.component,Reason:.reason,Message:.message --sort-by=lastTimestamp | tac; \
echo $HR_TOP"

# kubectl get events -n=chp18-set1900 --sort-by=.metadata.creationTimestamp | tac | grep \"horizontalpodautoscaler\"; \
