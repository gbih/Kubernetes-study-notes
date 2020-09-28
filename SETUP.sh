#!/bin/bash
clear

# Use for debugging
KUBE_APISERVER="/var/snap/microk8s/current/args/kube-apiserver"

enter () {
  echo ""
  read -p "[[ Press ENTER to continue ]]"
  clear
  echo $HR
}

resize > /dev/null 2>&1 # redirect output and error

HR=$(printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -)

HR_TOP=$(printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' "#")

