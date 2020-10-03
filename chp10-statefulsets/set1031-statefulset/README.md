IMPORTANT:
You can't communicate with your pods through the Service you created because it's headless.
You'll need to connect to individual pods directly (or create a regular Service, but that wouldn’t allow you to talk to a specific pod).

Here we will communicate directly with the pod by using the API server as a proxy to the pods.

One useful feature of the API server is the ability to proxy connections directly to individual pods. Because the API server is secured, sending requests to pods through the API server is cumbersome.

<apiServerHost>:<port>/api/v1/namespaces/default/pods/kubia-0/proxy/<path>
so, we use:
localhost:8001/api/v1/namespaces/chp10-set1031/pods/kubia-0/proxy/

Goals here:
 Give replicated pods individual storage
 Provide a stable identity to a pod
 Create a StatefulSet and a corresponding headless governing Service
 Scale and update a StatefulSet
 Discover other members of the StatefulSet through DNS
 Connect to other members through their host names
 Forcibly delete stateful pods

