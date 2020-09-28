# Study Notes for Kubernetes In Action, v1

1. Use multipass on OSX with microk8s
2. As much as possible, build Go demo programs (instead of Node.js)
3. Update any outdated or deprecated APIs
4. Eventually translate to Japanese

* Original source at:
[Kubernetes In Action, v1](https://www.manning.com/books/kubernetes-in-action)

------------

## Multipass installation

1. Install multipass. Possible defaults are:
--cpus 1
--disk 5G
--mem 1G

```shell
multipass launch --name actionbook-vm --disk 50G
```

2. Gather info about instance
```shell
multipass info actionbook-vm
```


* Log into multipass shell
```shell
multipass shell actionbook-vm
```

* Install MicroK8s
```shell
sudo snap install microk8s --classic
```

* Add the user ubuntu to the 'microk8s' group:
```shell
sudo usermod -a -G microk8s ubuntu
sudo chown -f -R ubuntu ~/.kube
```

Then logout and login.

* Check the status while Kubernetes starts
```shell
microk8s status --wait-ready
microk8s config > microk8s.yaml
```

* Create alias
```shell
sudo snap alias microk8s.kubectl kubectl
```

* Turn on the services you want
```shell
microk8s enable dns storage ingress metrics-server
microk8s status
```

-----------------------

## Docker installation

```shell
sudo apt-get update
sudo apt install docker.io
sudo docker version
sudo docker login --username **** --password ****
```

If you don’t want to preface the docker command with sudo, create a Unix group called docker and add users to it. When the Docker daemon starts, it creates a Unix socket accessible by members of the docker group.
To create the docker group and add your user:

Create the docker group.
`sudo groupadd docker`

Add your user to the docker group.
`sudo usermod -aG docker $USER`

Log out and log in


`docker info`

* Test
`docker run busybox echo "Hello world"`

-----------------------

## Terminal setup

1. Shorten bash shell:

Add to ~/.bashrc

`vi ~/.bashrc`
`PS1='\W\$ '`


```shell
export PROMPT_DIRTRIM=1
PS1='\u:\W\$ '
```

????


Reload these scripts:
`source ~/.bashrc`
`source ~/.bash_profile`


2. Install resize

```shell
sudo apt-get update
sudo apt-get install xterm
sudo apt-get install rename
```




-----------------------

## Backup script

* Backup from multipass instance to host computer

Assuming you keep your work files on instance 'actionbook-vm' in the directory /home/ubuntu/src, create a tar.gz file and transfer it to a local host.

```shell
multipass exec actionbook-vm -- tar -cvzf /home/ubuntu/src.tar.gz /home/ubuntu/src && multipass transfer actionbook-vm:/home/ubuntu/src.tar.gz /Users/username/K8s-in-Action-Book/src
```


* Restore from host to multipass instance

```shell

multipass transfer /Users/username/Desktop/K8s-in-Action-Book/src.tar.gz actionbook-vm:/home/ubuntu/src/src.tar.gz
```

Note that multipass transfer requires the destination to be a file.


To extract a tar.gz file, use the --extract (-x) operator and specify the archive file name after the f option:
`tar -xvf src.tar.gz`


cd into install directory
`mv /home/ubuntu/install/home/ubuntu/src /home/ubuntu/src`

-----------------------

## Check Initial install:

Confirm available disk space:

`df`

Something like:

```shell
Filesystem     1K-blocks    Used Available Use% Mounted on
udev             5103820       0   5103820   0% /dev
tmpfs            1023320    1092   1022228   1% /run
/dev/sda1       40470732 4272660  36181688  11% /
tmpfs            5116580       0   5116580   0% /dev/shm
tmpfs               5120       0      5120   0% /run/lock
tmpfs            5116580       0   5116580   0% /sys/fs/cgroup
/dev/sda15        106858    3668    103190   4% /boot/efi
/dev/loop0         93568   93568         0 100% /snap/core/8689
/dev/loop1        196608  196608         0 100% /snap/microk8s/1293
```


