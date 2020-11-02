# 4.5.5 Limiting the time allowed for a Job pod to complete

### Objective
1. Explore multiple job instances running parallel

### Notes

- Created containerized job that finished in 3 seconds

- Jobs here here are configured to run in parallel

- This is done via the `completions` and `parallelism` Job spec properties

- Parallel-running batch-job object:
```
apiVersion: batch/v1
kind: Job
metadata:
  namespace: chp04-set455
  name: multi-completion-batch-job
spec:
  completions: 5 # ensure 5 pods complete successfully
  parallelism: 3 # up to 3 pods can run in parallel
  template:
    metadata:
      labels:
        app: batch-job
    spec:
      restartPolicy: OnFailure
      containers:
      - name: main
        image: georgebaptista/batch-job
```
