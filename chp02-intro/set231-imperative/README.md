# Chapter 2, Section 2.3.1

### Objective
1. Deploy kubia Go app on Kubernetes
2. Use imperative-only commands (for now)
3. Setup a basic format for bash-scripting with Kubernetes commands

### Notes
1. `generator=run/v1` is now deprecated
2. `kubectl get ingress` is now deprecated (use `kubectl get svc` instead)
3. Use jsonpath to access specific properties

---

SETUP.sh (in project root at /home/ubuntu/src)

```bash
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
```
