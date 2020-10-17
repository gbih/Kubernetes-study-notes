# 18.1.2 Automating custom resources with custom controllers

### Objective

### Notes

p.513
> To make your Website objects run a web server pod exposed through a Service, you’ll need to build and deploy a Website controller, which will watch the API server for the creation of Website objects and then create the Service and the web server Pod for each of them.

> To make sure the Pod is managed and survives node failures, the controller will create a Deployment resource instead of an unmanaged Pod directly. 
