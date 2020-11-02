# 9.3.6 Blocking rollouts of bad versions

### Objective

### Notes
Deployment with ReadinessCheck

spec:
  selector:
    matchLabels:
      app: kubia # match spec.template.metadata.labels.app
  replicas: 3
  minReadySeconds: 20 # life of new successful pod before it is considered available
  strategy:
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 0 # make deployment replace pods one by one
    type: RollingUpdate
  template:
    metadata:
      name: kubia
      labels:
        app: kubia # match spec.selector.matchLabels.app
    spec:
      containers:
      - image: georgebaptista/kubia:v3
        name: nodejs
        readinessProbe:
          periodSeconds: 1 # readiness probe executed every second
          httpGet: # readiness probe test
            path: /
            port: 8080
