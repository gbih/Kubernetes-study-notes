!/bin/sh
clear

HR=$(printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -)
HR_TOP=$(printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' "=")

watch -n 1 -d -t "echo $HR_TOP; \
kubectl top node; \
echo $HR; \
kubectl get nodes -o=custom-columns=NAME:.metadata.name,TAINTS:.spec.taints,LABEL-NAME:.metadata.labels.name,LABEL-ENV:.metadata.labels.env; \
echo $HR; \
kubectl top pod -n=chp18-set1812; \
echo $HR; \
echo "get website kubia"; \
kubectl get website kubia -n=chp18-set1812; \
echo $HR; \
echo "SERVICE:"; \
kubectl get svc -n=chp18-set1812 -o wide; \
echo $HR; \
echo "get deployment"; \
kubectl get deployment -n=chp18-set1812 -o wide; \
echo $HR; \
echo "get pods"; \
kubectl get pods -n=chp18-set1812; \
echo $HR; \
kubectl get events -n=chp18-set1812 -o custom-columns=LastSeen:.lastTimestamp,From:.source.component,Reason:.reason,Message:.message --sort-by=lastTimestamp | tac; \
echo $HR_TOP"

# kubectl get events -n=chp18-set1812 --sort-by=.metadata.creationTimestamp | tac | grep \"horizontalpodautoscaler\"; \
