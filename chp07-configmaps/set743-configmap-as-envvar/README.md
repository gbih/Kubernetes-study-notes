# 7.4.3 Passing a ConfigMap entry to a container as an environment variable

### Objective

### Notes
- This is one option to get the values from this map into a pod's container.
Here we set an environment variable.
```
spec:
  volumes:
  - name: html # match spec.containers[].volumeMounts.name
    emptyDir: {}
  containers:
  - image: georgebaptista/fortune:env
    name: html-generator
    env:
    - name: INTERVAL # define env var
      valueFrom: # init from ConfigMap key, sleep-interval
        configMapKeyRef:
          name: fortune-config # name of ConfigMap to use
          key: sleep-interval # value to inject from ConfigMap
    - name: LOCATION
      valueFrom:
        configMapKeyRef:
          name: fortune-config
          key: location
    volumeMounts:
    - name: html
      mountPath: /var/htdocs
```

- We define an environment variable called INTERVAL and set its value to whatever is stored in the fortune-config ConfigMap under the key sleep-interval.

- When the process running in the html-generator container reads the INTERVAL environment variable, it will see the value 25.
