!/bin/sh
clear

# arg1 is $1
namespace=$1
echo "\$namespace is $namespace"

HR=$(printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -)
HR_TOP=$(printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' "=")

watch -n 1 -d -t "echo $HR_TOP; \
kubectl top node; \
echo $HR; \
kubectl get nodes -o=custom-columns=NAME:.metadata.name,TAINTS:.spec.taints,LABEL-NAME:.metadata.labels.name,LABEL-ENV:.metadata.labels.env; \
echo $HR; \
kubectl top pod -n=$namespace; \
echo $HR; \
kubectl get deployment -n=$namespace -o wide; \
echo $HR; \
kubectl get pods -n=$namespace -o wide --show-labels; \
echo $HR; \
kubectl get events -n=$namespace | tac; \
echo $HR_TOP"

