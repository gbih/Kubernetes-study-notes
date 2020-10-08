Understanding runAsUser, fsGroup, and supplementalGroups policies

The policy in the previous example doesn't impose any limits on which users and groups containers can run as, because you've used the RunAsAny rule for the runAs- User, fsGroup, and supplementalGroups fields. If you want to constrain the list of allowed user or group IDs, you change the rule to MustRunAs and specify the range of allowed IDs.

Using the MustRunAs rule
Let's look at an example. To only allow containers to run as user ID 2 and constrain the default filesystem group and supplemental group IDs to be anything from 2–10 or 20–30 (all inclusive), you'd include the following snippet in the PodSecurityPolicy resource.

If the pod spec tries to set either of those fields to a value outside of these ranges, the pod will not be accepted by the API server. To try this, delete the previous PodSecurityPolicy and create the new one from the psp-must-run-as.yaml file.

