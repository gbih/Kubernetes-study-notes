# 5.6.1 Creating a headless service

### Objective
1. Explore Headless Service

### Notes

- Although headless services may seem different from regular services, they aren't that different from the clients' perspective. Even with a headless service, clients can con- nect to its pods by connecting to the service's DNS name, as they can with regular services. But with headless services, because DNS returns the pods’ IPs, clients connect directly to the pods, instead of through the service proxy.

- A headless services still provides load balancing across pods, but through the DNS round-robin mechanism instead of through the service proxy.
