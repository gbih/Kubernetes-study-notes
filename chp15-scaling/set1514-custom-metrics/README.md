# 15.1.4 Scaling based on other and custom metrics

### Objective

### Notes
There are two other types of metrics, both of which are considered custom metrics: pod metrics and object metrics. These metrics may have names which are cluster specific, and require a more advanced cluster monitoring setup.

The first of these alternative metric types is pod metrics. These metrics describe Pods, and are averaged together across Pods and compared with a target value to determine the replica count. They work much like resource metrics, except that they only support a target type of AverageValue.
