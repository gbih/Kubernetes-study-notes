# Chapter 2, Section 2.3.1

### Objective
1. Deploy kubia Go app on Kubernetes
2. Use declarative-only approach
3. Setup a basic format for bash-scripting with Kubernetes commands

### Notes

- Use namespace to keep project resources organized.

- Determine path to current directory via $(pwd) bash command

- Create a project namespace, chp02-set231

- Create resources via `kubectl apply -f ...`

- Gain access to pod0 name via jsonpath query language:
```
POD0=$(kubectl get pods -n=chp02-set231 -o jsonpath={'.items[0].metadata.name'})
```

- Explore ready-status of pods via status.conditions

- The microk8s Ingress module appears be hard-wired to use 127.0.0.1, whereas the Ingress-Nginx package doesn't have the IP hard-wired in, and will result in an arbitrarily-selected number.

