# 4.1.2 Creating an HTTP-based liveness probe

### Objective
1. Explore using liveness probe with pods
2. Set up effective liveness probe parameters

### Notes

- Without a liveness probe, Kubernetes has no way to know whether the app is still running or now.

- There are 3 types of liveness probes:
  1. HTTP GET
  2. TCP Socket
  3. Exec probe

- We can live stream logs via CLI with --follow flag
```
kubectl logs --follow --timestamps --pod-running-timeout=5s pod/kubia-liveness -n=chp04-set412
```

- Explore reasons for container termination via https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/#my-container-is-terminated

- Configuring the liveness and readiness probes
https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/#configure-probes

| field               | description                                                                                                                                                                                                                                        |
|---------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| initialDelaySeconds | Number of seconds after the container has started before liveness or readiness probes are initiat ed. Defaults to 0 seconds. Minimum value is 0.                                                                                                   |
| periodSeconds       | How often (in seconds) to perform the probe. Default to 10 seconds. Minimum value is 1.                                                                                                                                                            |
| timeoutSeconds      | Number of seconds after which the probe times out. Defaul ts to 1 second. Minimum value is 1.                                                                                                                                                      |
| successThreshold    | Minimum consecutive successes for the probe to be considered successful after having failed. Defaults to 1. Must be 1 for liveness. Minimum value is 1                                                                                           |
| failureThreshold    | When a probe fails, Kubernetes will try failureThreshold times before giving up. Giving up in case of liveness probe means restarting the container. In case of readiness probe the Pod will be marked Unready. Defaults to 3. Minimum value is 1. |

- Recreated "kubia-unheathy" app in Go. Used this resource go status-codes: https://golang.org/pkg/net/http/#example_ResponseWriter_trailers

