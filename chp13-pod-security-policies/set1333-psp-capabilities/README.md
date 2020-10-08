Configuring allowed, default, and disallowed capabilities

As you learned, containers can run in privileged mode or not, and you can define a more fine-grained permission configuration by adding or dropping Linux kernel capabilities in each container. Three fields influence which capabilities containers can or cannot use:
* allowedCapabilities
* defaultAddCapabilities
* requiredDropCapabilities

We'll look at an example first, and then discuss what each of the three fields does. The following listing shows a snippet of a PodSecurityPolicy resource defining three fields related to capabilities.

SPECIFYING WHICH CAPABILITIES CAN BE ADDED TO A CONTAINER
The allowedCapabilities field is used to specify which capabilities pod authors can add in the securityContext.capabilities field in the container spec. In one of the previous examples, you added the SYS_TIME capability to your container. If the PodSecurityPolicy admission control plugin had been enabled, you wouldn’t have been able to add that capability, unless it was specified in the PodSecurityPolicy as shown in listing 13.18.

ADDING CAPABILITIES TO ALL CONTAINERS
All capabilities listed under the defaultAddCapabilities field will be added to every deployed pod’s containers. If a user doesn’t want certain containers to have those capabilities, they need to explicitly drop them in the specs of those containers.
The example in listing 13.18 enables the automatic addition of the CAP_CHOWN capability to every container, thus allowing processes running in the container to change the ownership of files in the container (with the chown command, for example).

DROPPING CAPABILITIES FROM A CONTAINER
The final field in this example is requiredDropCapabilities. I must admit, this was a somewhat strange name for me at first, but it’s not that complicated. The capabilities listed in this field are dropped automatically from every container (the PodSecurityPolicy Admission Control plugin will add them to every container’s securityContext.capabilities.drop field).

If a user tries to create a pod where they explicitly add one of the capabilities listed in the policy’s requiredDropCapabilities field, the pod is rejected

