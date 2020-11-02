# 7.5.4 Comparing ConfigMaps and Secrets

### Objective

### Notes
* We can pass sensitive configuration information to the containers via the Secret object.
* Secrets are like ConfigMaps in that they are maps that hold key-value pairs.
They can be used the same way as a ConfigMap, as you can:
1. Pass Secret entries to the container as environment variables
2. Expose Secret entries as files in a volume

We define the secret volume here, referring to the fortune-https Secret.
```
spec:
  volumes:
  - name: html
    emptyDir: {}
  - name: config
    configMap:
      name: fortune-config
      items:
      - key: my-nginx-config.conf
        path: https.conf
      defaultMode: 0666
  - name: certs
    secret:
      secretName: fortune-https
```

and the corresponding container volumeMounts,

```
    volumeMounts:
    - name: certs
      mountPath: /etc/nginx/certs/
      readOnly: true
```

- May need to comment this out when generating the certificate and private key files:
`RANDFILE = ::HOME/.rnd from /etc/ssl/openssl.cnf`
