# Chapter 12: Securing the Kubernetes API server

## This chapter covers

* Understanding authentication
* What ServiceAccounts are and why they're used for
* Understanding the role-based access control (RBAC)
* Using Roles and RoleBindings
* Understanding the default roles and bindings

---

**12.1 Understanding authentication**

**12.2 Securing the cluster with role-based access control**

**12.3 Summary**

---

# 12.1 Understanding authentication
* Authentication plugins obtain the identity of the client via:
  * Client certificate
  * Authentication token passed in an HTTP header
  * Basic HTTP authentication
  * Other methods



### 12.1.1 Users and groups
* Understanding users
* Understanding groups

### 12.1.2 Introducing ServiceAccounts
* Understanding the ServiceAccount resource
* Understanding how ServiceAccounts tie into authorization

### 12.1.13 Creating ServiceAccounts
* Creating a ServiceAccount
* Understanding a ServiceAccount's mountable secrets
* Understanding a ServiceAccount's image pull secrets

### 12.1.4 Assigning a ServiceAccount to a pod
* Creating a pod which uses a custom ServiceAccount

---

# 12.2 Securing the cluster with role-based access control
* RBAC plugins enables authorization-control

### 12.2.1 Introducing the RBAC authorization plugin
* Understanding actions
* Understanding the RBAC plugin

### 12.2.2 Introducing RBAC resources
* RBAC authorization rule are configured through 4 resources
  * Roles and ClusterRoles
  * RoleBindings and ClusterRoleBindings
* Setting up your cluster
* Creating the namespaces and running the pods
* Listing Services from your pods

### 12.2.3 Using Roles and RoleBindings
* Creating a Role
* Binding a Role to a ServiceAccount
* Including ServiceAccounts from other Namespaces in a RoleBinding

### 12.2.4 Using ClusterRoles and ClusterRoleBindings
* Allowing access to cluster-level resources
* Allowing access to non-resource URLs
* Using ClusterRoles to grant access to resources in specific namespaces
* Summarizing Role, ClusterRole, RoleBinding, and ClusterRoleBinding combinations

### 12.2.5 Understanding default ClusterRoles and ClusterRoleBindings
* Allowing read-only access to resources with the `view` ClusterRole
* Allowing modifying resources with the `edit` ClusterRole
* Granting full control of a namespace with the `admin` ClusterRole
* Allowing complete control with the `cluster-admin` ClusterRole
* Understanding the other default ClusterRoles

### 12.2.6 Granting authorization permissions wisely
* Creating specific ServiceAccounts for each pod
* Expecting your apps to be compromised

---

# 12.3 Summary
