!/bin/sh
clear

HR=$(printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -)
HR_TOP=$(printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' "=")

# watch -t -n1 "echo $HR_TOP; kubectl top node; echo $HR; kubectl top pod -n=chp15-set1513; echo $HR; kubectl get deployments -n=chp15-set1512; echo $HR; kubectl get events -n=chp15-set1512| grep \"horizontalpodautoscaler\"; echo $HR; kubectl get pods -n=chp15-set1512; echo $HR_TOP"

watch -t -n1 "echo $HR_TOP; \
kubectl top node; \
echo $HR; \
kubectl top pod -n=chp15-set1513; \
echo $HR; \
kubectl get deployments -n=chp15-set1513; \
echo $HR; \
kubectl get pods -n=chp15-set1513; \
echo $HR; \
kubectl get events -n=chp15-set1513 --sort-by=.metadata.creationTimestamp | tac | grep \"horizontalpodautoscaler\"; \
echo $HR_TOP"
