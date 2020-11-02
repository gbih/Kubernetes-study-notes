# 6.2.2 Using a Git repository as the starting point for a volume - deprecated. Use init-container instead to use git repos

### Objective

### Notes

**Warning: The gitRepo volume type is deprecated and should not be used due to security issues.**

- To provision a container with a git repo, mount an EmptyDir into an InitContainer that clones the repo using git, then mount the EmptyDir into the Pod’s container.

- This is an example of using an InitContainer in place of a GitRepo volume.

- InitContainers are specialized containers that run before app containers in a Pod.

- Unlike GitRepo volumes, this approach runs the git command in a container, with the associated hardening.

- We use this Git Repo: https://github.com/gbih/kubia-website-example.git

- This container clones the desired git repo to the EmptyDir volume initContainers.

- We use the image alpine/git, but any image with git will do. Then we put it in a volume, such as /usr/share/nginx/html
