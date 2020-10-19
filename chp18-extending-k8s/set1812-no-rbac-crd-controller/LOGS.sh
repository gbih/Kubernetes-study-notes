!/bin/sh
clear

HR=$(printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -)
HR_TOP=$(printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' "=")

#watch -n 1 -d -t "echo $HR_TOP; \
#echo "crd, controller deployment object and website"; \
#kubectl logs deployment.apps/website-controller -n=chp18-set1812 -c main; \
#echo $HR_TOP"

kubectl logs deployment.apps/website-controller -n=chp18-set1812 -c main
