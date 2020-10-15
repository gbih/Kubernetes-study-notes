!/bin/sh
clear

HR=$(printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -)
HR_TOP=$(printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' "=")

watch -n 1 -d -t "echo $HR_TOP; \
kubectl get nodes -o=custom-columns=NAME:.metadata.name,TAINTS:.spec.taints,LABEL-AVAILABILITY-ZONE:.metadata.labels.availability-zone,LABEL-SHARE-TYPE:.metadata.labels.share-type; \
echo $HR; \
kubectl get deployment -n=chp16-set1634 -o wide; \
echo $HR; \
kubectl get pods -n=chp16-set1634 -o wide; \
echo $HR; \
kubectl get events -n=chp16-set1634 -o custom-columns=LastSeen:.lastTimestamp,From:.source.component,Reason:.reason,Message:.message --sort-by=lastTimestamp | tac; \
echo $HR_TOP"

# kubectl get events -n=chp16-set1634 --sort-by=.metadata.creationTimestamp | tac | grep \"horizontalpodautoscaler\"; \
