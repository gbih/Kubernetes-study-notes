!/bin/sh
clear

HR=$(printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -)
HR_TOP=$(printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' "=")

watch -n 1 -d -t "echo $HR_TOP; \
kubectl top node; \
echo $HR; \
kubectl get nodes -L name,env; \
echo $HR; \
kubectl top pod -n=chp15-set1512; \
echo $HR; \
kubectl get deployment -n=chp15-set1512 -o wide; \
echo $HR; \
kubectl get pods -n=chp15-set1512 -o wide --show-labels; \
echo $HR; \
kubectl get events -n=chp15-set1512 -o custom-columns=LastSeen:.lastTimestamp,From:.source.component,Reason:.reason,Message:.message --sort-by=lastTimestamp | tac; \
echo $HR_TOP"

# kubectl get events -n=chp15-set1512 --sort-by=.metadata.creationTimestamp | tac | grep \"horizontalpodautoscaler\"; \
