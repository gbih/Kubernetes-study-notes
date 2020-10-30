# 18.1.2 Automating custom resources with custom controllers

### Objective

### Notes
- This image is outdated:
https://github.com/luksa/k8s-website-controller
and needs to be updated, otherwise it will not work!

- Creating service imperatively:
```
kubectl expose deployment.apps/website-controller  --name kubia-http --dry-run=client -o yaml -n=chp18-set1900 --port=80
```
