# 7.4.6 Using a configMap volume to expose ConfigMap entries as files

### Objective

### Notes
- Using a configMap volume to expose ConfigMap entries as files.

- A configMap volume will expose each entry of the ConfigMap as a file.

- The process running in the container can obtain the entry’s value by reading the contents of the file.

-This method is mainly meant for passing large config files to the container.

```
spec:
  volumes:
  - name: html
    emptyDir: {}
  - name: config
    configMap: # this volume references the fortune-config ConfigMap
      name: fortune-config
      items: # populate configMap volume with only entries under this key
      - key: my-nginx-config.conf
        path: gzip.conf
      defaultMode: 0666

  containers:
  - image: georgebaptista/fortune:env
    name: html-generator
    volumeMounts:
    - name: html
      mountPath: /var/htdocs
    env:
    - name: INTERVAL
      valueFrom:
        configMapKeyRef:
          name: fortune-config
          key: sleep-interval
```
