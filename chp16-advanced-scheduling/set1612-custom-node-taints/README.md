# 16.1.2 Adding custom taints to a node

### Objective

- Work through syntax of adding / removing taints

### Notes

- Adding
  
  1. Simple syntax:
     
     ```
     kubectl taint node actionbook-vm node-type=production:NoSchedule
     ```
  
  2. Based on label selector:
     
     ```
     kubectl taint node -l name=node1-vm node-type=production:NoSchedule
     ```

- Deleting

  1. Simple syntax, simply add `-` to end

    ```
    kubectl taint node actionbook-vm node-type=production:NoSchedule-

    # shorter version
    kubectl taint node actionbook-vm node-type:NoSchedule-
    ```

  2. Based on label selector:

    ```
    kubectl taint node -l name=node1-vm node-type=production:NoSchedule-
    ```




