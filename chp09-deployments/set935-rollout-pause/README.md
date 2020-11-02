# 9.3.5 Pausing the rollout process

### Objective

### Notes
Pausing the rollout process
By using pause, then changing the image, then using resume, we essentially create a manual canary release.
Run a single v4 pod next to existing v1 pods and see how it behaves with only a fraction of all your users. After confirming success of v2, resume the rollout and replace all old pods with v4.

- Recommended Labels
- https://kubernetes.io/docs/concepts/overview/working-with-objects/common-labels/
app.kubernetes.io/version: "3.0"
