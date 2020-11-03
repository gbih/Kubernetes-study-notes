!/bin/sh
clear

HR=$(printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -)
HR_TOP=$(printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' "=")

watch -n 1 -d -t "echo $HR_TOP; \
kubectl get ns chp12-set1227; \
echo $HR; \
kubectl get all -n=chp12-set1227 --show-labels; \
echo $HR; \
kubectl get sa -n=chp12-set1227; \
echo $HR; \
kubectl get role -n=chp12-set1227; \
echo $HR; \
kubectl get rolebinding -n=chp12-set1227; \
echo $HR; \
kubectl get clusterrolebinding my-binding; \
echo $HR; \
kubectl get events -n=chp12-set1227; \
echo $HR_TOP"

