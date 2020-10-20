#!/bin/sh
clear
# watch utility executes commands with sh -c

HR=$(printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -)
HR_TOP=$(printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' "=")

watch -n 1 -d -t "echo $HR_TOP; \
kubectl get ns chp02-set231-imperative; \
echo $HR; \
kubectl get all -n=chp02-set231-imperative -o wide; \
echo $HR; \
kubectl get events -n=chp02-set231-imperative; \
echo $HR_TOP"

