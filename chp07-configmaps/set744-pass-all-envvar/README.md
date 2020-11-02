# 7.4.4 Passing all entries of a ConfigMap as environment variables at once

### Objective

### Notes
- Passing all entries of a ConfigMap as environment variables at once.

- Inside a pod, we can expose all the keys as environment variables by using the envFrom attribute, instead of env.

```
  containers:
  - image: georgebaptista/fortune:env
    name: html-generator
    envFrom:
    - prefix: CONFIG_
      configMapRef:
        name: fortune-config # configmap name
```
