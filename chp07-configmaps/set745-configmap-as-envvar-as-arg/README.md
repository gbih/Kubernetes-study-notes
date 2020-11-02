# 7.4.5 Passing a ConfigMap entry as a command-line argument

### Objective

### Notes
- Passing a ConfigMap entry as a command-line argument

- We can pass values from a ConfigMap as arguments to the main process running in the container.

- We cannot reference ConfigMap entries directly in the pod.spec.containers.args field.

- We have to first initialize an environment variable from the ConfigMap entry and then refer to the variable inside the arguments.

```
  containers:
  - image: georgebaptista/fortune:env
    name: html-generator
    env:
    - name: INTERVAL
      valueFrom:
        configMapKeyRef:
          name: fortune-config
          key: sleep-interval
    args: ["$(INTERVAL)"]
```
