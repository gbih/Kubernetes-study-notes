#!/bin/sh
clear
# watch utility executes commands with sh -c

HR=$(printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -)
HR_TOP=$(printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' "=")

watch -n 1 -d -t "echo $HR_TOP; \
kubectl get ns chp03-set322; \
echo $HR; \
kubectl get all -n=chp03-set322 -o wide; \
echo $HR; \
kubectl get events -n=chp03-set322; \
echo $HR_TOP"

