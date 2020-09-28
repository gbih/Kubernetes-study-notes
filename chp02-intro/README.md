# Study Notes for Kubernetes In Action, v1
## Chapter 2

### Objectives
- Build container images and run it inside a Kubernetes cluster
- Explore basic imperative commands
- Explore basic declarative syntax (YAML files) 
- Setup template for bash files

### SET UP

* Create various helper utilities/properties and import in the project bash scripts

SETUP.sh

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
