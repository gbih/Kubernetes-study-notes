# Chapter 5, Section 5.1.2

### Objective
1. Explore Services

### Notes
- In order to get a shell to a container, we cannot use Docker image created with Scratch. Instead we use a minimal Docker base image, such as Alpine.

- Slightly different presentation of TEST.sh bash file:
  1. Embed certain yaml file via `value=$(<filename.yaml)`
  2. Progress to next screen via `[[ Press ENTER to continue ]]`
