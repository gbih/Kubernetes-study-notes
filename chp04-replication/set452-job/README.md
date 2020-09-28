# Chapter 4, Section 4.5.2

### Objective
1. Explore Jobs

### Notes

- Created containerized job that finished in 3 seconds

- This is a job performing a single completable task

- Jobs cannot use default restart policy, which is Always

- Job resource created via:
```
apiVersion: batch/v1
kind: Job
metadata:
  name: batch-job
  namespace: chp04-set452
spec:
  template:
    metadata:
      labels:
        app: batch-job
    spec:
      restartPolicy: OnFailure # needs to be either OnFailure or Never
      containers:
      - name: main
        image: georgebaptista/batch-job # based on busybox image
```
