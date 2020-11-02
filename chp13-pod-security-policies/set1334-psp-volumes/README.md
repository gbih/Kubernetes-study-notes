# 13.3.4 Constraining the types of volumes pods can use

### Notes
Constraining the types of volumes pods can use

The last thing a PodSecurityPolicy resource can do is define which volume types users can add to their pods. At the minimum, a PodSecurityPolicy should allow using at least the emptyDir, configMap, secret, downwardAPI, and the persistentVolume- Claim volumes. The pertinent part of such a PodSecurityPolicy resource is shown in the following listing.

If multiple PodSecurityPolicy resources are in place, pods can use any volume type defined in any of the policies (the union of all volumes lists is used).
