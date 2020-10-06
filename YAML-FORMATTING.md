ON and YAML output from kubectl


## Objective 
Usually YAML is easy to read, but there can be times when it is particularly "noisy".

Using grep directly with kubectl does not usually work, as it will not filter the children of the selected parent object.

For example:
```
kubectl get svc -o yaml | grep -vE "managedFields|selfLink|creationTimestamp"
```

Instead, we can use a combination of yq and jq for fitered output.


## Install 

#### [jq: Lightweight and flexible command-line JSON processor.](https://stedolan.github.io/jq/ "jq")

#### [yq: Lightweight and portable command-line YAML processor](https://mikefarah.gitbook.io/yq/ "yq")


## Original example


```
kubectl get svc -o yaml
```

<details><summary>Output</summary>
<p>

```
apiVersion: v1
items:
- apiVersion: v1
  kind: Service
  metadata:
    creationTimestamp: "2020-10-04T03:38:58Z"
    labels:
      component: apiserver
      provider: kubernetes
    managedFields:
    - apiVersion: v1
      fieldsType: FieldsV1
      fieldsV1:
        f:metadata:
          f:labels:
            .: {}
            f:component: {}
            f:provider: {}
        f:spec:
          f:clusterIP: {}
          f:ports:
            .: {}
            k:{"port":443,"protocol":"TCP"}:
              .: {}
              f:name: {}
              f:port: {}
              f:protocol: {}
              f:targetPort: {}
          f:sessionAffinity: {}
          f:type: {}
      manager: kube-apiserver
      operation: Update
      time: "2020-10-04T03:38:58Z"
    name: kubernetes
    namespace: default
    resourceVersion: "58"
    selfLink: /api/v1/namespaces/default/services/kubernetes
    uid: f7749243-1a91-4c64-953e-9ca7d11ab2ef
  spec:
    clusterIP: 10.152.183.1
    ports:
    - name: https
      port: 443
      protocol: TCP
      targetPort: 16443
    sessionAffinity: None
    type: ClusterIP
  status:
    loadBalancer: {}
kind: List
metadata:
  resourceVersion: ""
  selfLink: ""
```
</p>
</details>


## Examples Using jq and yq


1. Display resource in JSON format, pass unchanged to jq unchanged as JSON pretty print
```bash
kubectl get svc -o json | jq '.'
```
  <details><summary>Output</summary>
  <p>
  
  ```
  {
    "apiVersion": "v1",
    "items": [
      {
        "apiVersion": "v1",
        "kind": "Service",
        "metadata": {
          "creationTimestamp": "2020-10-04T03:38:58Z",
          "labels": {
            "component": "apiserver",
            "provider": "kubernetes"
          },
          "managedFields": [
            {
              "apiVersion": "v1",
              "fieldsType": "FieldsV1",
              "fieldsV1": {
                "f:metadata": {
                  "f:labels": {
                    ".": {},
                    "f:component": {},
                    "f:provider": {}
                  }
                },
                "f:spec": {
                  "f:clusterIP": {},
                  "f:ports": {
                    ".": {},
                    "k:{\"port\":443,\"protocol\":\"TCP\"}": {
                      ".": {},
                      "f:name": {},
                      "f:port": {},
                      "f:protocol": {},
                      "f:targetPort": {}
                    }
                  },
                  "f:sessionAffinity": {},
                  "f:type": {}
                }
              },
              "manager": "kube-apiserver",
              "operation": "Update",
              "time": "2020-10-04T03:38:58Z"
            }
          ],
          "name": "kubernetes",
          "namespace": "default",
          "resourceVersion": "58",
          "selfLink": "/api/v1/namespaces/default/services/kubernetes",
          "uid": "f7749243-1a91-4c64-953e-9ca7d11ab2ef"
        },
        "spec": {
          "clusterIP": "10.152.183.1",
          "ports": [
            {
              "name": "https",
              "port": 443,
              "protocol": "TCP",
              "targetPort": 16443
            }
          ],
          "sessionAffinity": "None",
          "type": "ClusterIP"
        },
        "status": {
          "loadBalancer": {}
        }
      }
    ],
    "kind": "List",
    "metadata": {
      "resourceVersion": "",
      "selfLink": ""
    }
  }
  ```
  </p>
  </details>
&nbsp  
&nbsp  
2. Display resource in JSON format, select field 'apiVersion: .apiVersion' in jq, output as JSON
```bash
kubectl get svc -o json | jq '. | {apiVersion: .apiVersion}'
```
  <details><summary>Output</summary>
  <p>
  
  ```
  {
    "apiVersion": "v1"
  }
  ```
  </p>
  </details>





3. Display resource in JSON format, filter out nested field 'managedFields' in jq, output as JSON
```bash
kubectl get svc -o json | jq 'del(.items[].metadata.managedFields)'
```
  <details><summary>Output</summary>
  <p>
  
  ```
  {
    "apiVersion": "v1",
    "items": [
      {
        "apiVersion": "v1",
        "kind": "Service",
        "metadata": {
          "creationTimestamp": "2020-10-04T03:38:58Z",
          "labels": {
            "component": "apiserver",
            "provider": "kubernetes"
          },
          "name": "kubernetes",
          "namespace": "default",
          "resourceVersion": "58",
          "selfLink": "/api/v1/namespaces/default/services/kubernetes",
          "uid": "f7749243-1a91-4c64-953e-9ca7d11ab2ef"
        },
        "spec": {
          "clusterIP": "10.152.183.1",
          "ports": [
            {
              "name": "https",
              "port": 443,
              "protocol": "TCP",
              "targetPort": 16443
            }
          ],
          "sessionAffinity": "None",
          "type": "ClusterIP"
        },
        "status": {
          "loadBalancer": {}
        }
      }
    ],
    "kind": "List",
    "metadata": {
      "resourceVersion": "",
      "selfLink": ""
    }
  }
  ```
  </p>
  </details>


4. Display resource in JSON format, filter out multiple nested fields in jq, output as JSON
```bash
kubectl get svc -o json | jq 'del(.items[].metadata.managedFields, .items[].metadata.selfLink, .items[].metadata.resourceVersion)'
```
  <details><summary>Output</summary>
  <p>
  
  ```
  {
    "apiVersion": "v1",
    "items": [
      {
        "apiVersion": "v1",
        "kind": "Service",
        "metadata": {
          "creationTimestamp": "2020-10-04T03:38:58Z",
          "labels": {
            "component": "apiserver",
            "provider": "kubernetes"
          },
          "name": "kubernetes",
          "namespace": "default",
          "uid": "f7749243-1a91-4c64-953e-9ca7d11ab2ef"
        },
        "spec": {
          "clusterIP": "10.152.183.1",
          "ports": [
            {
              "name": "https",
              "port": 443,
              "protocol": "TCP",
              "targetPort": 16443
            }
          ],
          "sessionAffinity": "None",
          "type": "ClusterIP"
        },
        "status": {
          "loadBalancer": {}
        }
      }
    ],
    "kind": "List",
    "metadata": {
      "resourceVersion": "",
      "selfLink": ""
    }
  }
  ```
  </p>
  </details>


5. Display resource in JSON format, filter out multiple nested fields in jq, output as YAML
```bash
kubectl get svc -o json | jq 'del(.items[].metadata.managedFields, .items[].metadata.selfLink, .items[].metadata.resourceVersion)' | yq r -P -
```

  <details><summary>Output</summary>
  <p>
  
  ```
  apiVersion: v1
  items:
    - apiVersion: v1
      kind: Service
      metadata:
        creationTimestamp: "2020-10-04T03:38:58Z"
        labels:
          component: apiserver
          provider: kubernetes
        name: kubernetes
        namespace: default
        uid: f7749243-1a91-4c64-953e-9ca7d11ab2ef
      spec:
        clusterIP: 10.152.183.1
        ports:
          - name: https
            port: 443
            protocol: TCP
            targetPort: 16443
        sessionAffinity: None
        type: ClusterIP
      status:
        loadBalancer: {}
  kind: List
  metadata:
    resourceVersion: ""
    selfLink: ""
  ```
  </p>
  </details>


6. Display resource in JSON format, filter out multiple nested fields in jq, output as YAML with optional tab space of 4
```bash
kubectl get svc -o json | jq 'del(.items[].metadata.managedFields, .items[].metadata.selfLink, .items[].metadata.resourceVersion)' | yq r -P - -I4
```
  <details><summary>Output</summary>
  <p>
  
  ```
  apiVersion: v1
  items:
      - apiVersion: v1
        kind: Service
        metadata:
          creationTimestamp: "2020-10-04T03:38:58Z"
          labels:
              component: apiserver
              provider: kubernetes
          name: kubernetes
          namespace: default
          uid: f7749243-1a91-4c64-953e-9ca7d11ab2ef
        spec:
          clusterIP: 10.152.183.1
          ports:
              - name: https
                port: 443
                protocol: TCP
                targetPort: 16443
          sessionAffinity: None
          type: ClusterIP
        status:
          loadBalancer: {}
  kind: List
  metadata:
      resourceVersion: ""
      selfLink: ""
  ```
  </p>
  </details>


##  Flags for yq

| flag | explanation        |
|------|--------------------|
| r    | read               |
| -P   | prettyPrint        |
| -    | from STDIN         |
| -I4  | indent tab space 4 |

