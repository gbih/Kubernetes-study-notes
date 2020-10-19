!/bin/sh
clear

HR=$(printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -)
HR_TOP=$(printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' "=")

NODE_IP=$(kubectl get node -o jsonpath={'.items[0].status.addresses[0].address'})
SITE_IP="http://$NODE_IP:30007"

watch -n 1 -d -t "echo $HR_TOP; \
echo "Site deployed at " $SITE_IP; \
echo $HR; \
echo "crd, controller, website, svc"; \
kubectl get crd -n=chp18-set1812 -o wide; \
kubectl get deployment/website-controller -n=chp18-set1812; \
kubectl get websites -n=chp18-set1812 -o wide; \
kubectl get svc -n=chp18-set1812 -o wide; \
echo $HR; \
echo "deployment"; \
kubectl get deployment -n=chp18-set1812 -o wide; \
echo $HR; \
kubectl get pods -n=chp18-set1812 -o wide; \
echo $HR; \
kubectl get events -n=chp18-set1812 -o custom-columns=LastSeen:.lastTimestamp,From:.source.component,Reason:.reason,Message:.message --sort-by=lastTimestamp | tac; \
echo $HR_TOP"

# kubectl get events -n=chp18-set1812 --sort-by=.metadata.creationTimestamp | tac | grep \"horizontalpodautoscaler\"; \
