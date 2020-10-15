!/bin/sh
clear

HR=$(printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -)
HR_TOP=$(printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' "=")

watch -n 1 -d -t "echo $HR_TOP; \
kubectl top node; \
echo $HR; \
kubectl get nodes -o=custom-columns=NAME:.metadata.name,TAINTS:.spec.taints,LABEL-NAME:.metadata.labels.name,LABEL-ENV:.metadata.labels.env,LABEL-GPU:.metadata.labels.gpu; \
echo $HR; \
kubectl top pod -n=chp16-set1621; \
echo $HR; \
kubectl get deployment -n=chp16-set1621 -o wide; \
echo $HR; \
kubectl get pods -n=chp16-set1621 -o wide --show-labels; \
echo $HR; \
kubectl get events -n=chp16-set1621 -o custom-columns=LastSeen:.lastTimestamp,From:.source.component,Reason:.reason,Message:.message --sort-by=lastTimestamp | tac; \
echo $HR_TOP"

# kubectl get events -n=chp16-set1621 --sort-by=.metadata.creationTimestamp | tac | grep \"horizontalpodautoscaler\"; \
