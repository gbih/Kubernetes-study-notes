#FROM scratch
# use alpine to enable logging in and using curl
FROM curlimages/curl:7.73.0
MAINTAINER marko.luksa@gmail.com
ADD website-controller /
ADD deployment-template.json /
ADD service-template.json /
CMD ["/website-controller"]
