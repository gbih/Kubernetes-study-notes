# 7.2.2 Overriding the command and arguments in Kubernetes

### Objective

### Notes
- Kubernetes allows overriding the command as part of the pod’s container definition when you want to run a different executable instead of the one specified in the image, or want to run it with a different set of commmand-line arguments.

- The key setting we use to override the default command and arguments are:
  containers:
  - image: luksa/fortune:args
    args: ["2"]

- The shell process is unnecessary, which is why you should always use the exec form of the ENTRYPOINT instruction.

- K8s allows overriding the command as part of the pod's container definition when you want to run a different executable instead of the one specified in the image, or want to run it with a different set of command-line arguments. 

- The whole command that gets executed in the container is composed of two parts:
  1. the command
  2. the arguments

- In a Dockerfile, two instructions define the two parts:
  1. ENTRYPOINT defines the executable invoked when the container is started.
  2. CMD specifies the arguments that get passed to the ENTRYPOINT.

- Although you can use the CMD instruction to specify the command you want to execute when the image is run, the correct way is to do it through the ENTRYPOINT instruction and to only specify the CMD if you want to define the default arguments. 

- The image can then be run without specifying any arguments.
