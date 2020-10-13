!/bin/sh
clear

HR=$(printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -)
HR_TOP=$(printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' "=")

watch -n 1 -d -t "echo $HR_TOP; \
date \+\"Time: %T\"; \
echo $HR; \
kubectl top node; \
echo $HR; \
kubectl top pod -n=chp15-set1514; \
echo $HR; \
kubectl get deployment -n=chp15-set1514; \
echo $HR; \
kubectl get hpa -n=chp15-set1514; \
echo $HR; \
kubectl get pods -n=chp15-set1514; \
echo $HR; \
kubectl get events -n=chp15-set1514 -o custom-columns=LastSeen:.lastTimestamp,From:.source.component,Reason:.reason,Message:.message --sort-by=lastTimestamp | tac | grep \"horizontal-pod-autoscaler\"; \
echo $HR_TOP"

# kubectl get events -n=chp15-set1514 --sort-by=.metadata.creationTimestamp | tac | grep \"horizontalpodautoscaler\"; \
