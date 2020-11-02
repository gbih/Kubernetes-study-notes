# 4.3.2 Defining a ReplicaSet

### Objective
1. Explore ReplicaSets

### Notes

- A ReplicaSet behaves exactly like a ReplicationController, but has more expressive pod selectors.

- A ReplicationController selector is `spec.selector.label`

- The simple form selector is `spec.selector.matchLabels.label`
