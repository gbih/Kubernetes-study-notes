# 4.5.4 Running multiple pod instances in a Job

### Objective
1. Explore multiple job instances in a Job

### Notes

- Created containerized job that finished in 3 seconds

- Jobs can be configured to create more than one pod instance and run them in parallel or sequentially

- This is done via the `completions` and `parallelism` Job spec properties

- Sequentially-running batch-job object:
```
apiVersion: batch/v1
kind: Job
metadata:
  name: multi-completion-batch-job
  namespace: chp04-set454
spec:
  completions: 5 # make this Job run 5 pods sequentially
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
