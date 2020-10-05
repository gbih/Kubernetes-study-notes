# Chapter 11, Section 11.6

### Objective

### Notes

- Declare resources via YAML, then let controllers implement them

- Controllers watch, create, update, reconcile resources


p.322-323
- A few pointers on exploring the controllers’ source code
- If you’re interested in seeing exactly how these controllers operate, I strongly encourage you to browse through their source code. 

- To make it easier, here are a few tips:

- The source code for the controllers is available at https://github.com/kubernetes/ kubernetes/blob/master/pkg/controller.

- Each controller usually has a constructor in which it creates an Informer, which is basically a listener that gets called every time an API object gets updated. 

- Usually, an Informer listens for changes to a specific type of resource. 

- Looking at the constructor will show you which resources the controller is watching.

- Next, go look for the worker() method. In it, you’ll find the method that gets invoked each time the controller needs to do something. 

- The actual function is often stored in a field called syncHandler or something similar. 

- This field is also initialized in the constructor, so that’s where you’ll find the name of the function that gets called. 

- That function is the place where all the magic happens.

-----------

https://github.com/kubernetes/kubernetes/blob/master/pkg/controller/namespace/namespace_controller.go

Informer constructor:
https://github.com/kubernetes/kubernetes/blob/master/pkg/controller/namespace/namespace_controller.go#L85

```go
// NewNamespaceController creates a new NamespaceController
func NewNamespaceController(
  // ...
  // configure the namespace informer event handlers
  namespaceInformer.Informer().AddEventHandlerWithResyncPeriod(
    cache.ResourceEventHandlerFuncs{
      AddFunc: func(obj interface{}) {
        namespace := obj.(*v1.Namespace)
        namespaceController.enqueueNamespace(namespace)
      },
      UpdateFunc: func(oldObj, newObj interface{}) {
        namespace := newObj.(*v1.Namespace)
        namespaceController.enqueueNamespace(namespace)
      },
    },
    resyncPeriod,
  )
  namespaceController.lister = namespaceInformer.Lister()
  namespaceController.listerSynced = namespaceInformer.Informer().HasSynced

  return namespaceController
}
```


https://github.com/kubernetes/kubernetes/blob/master/pkg/controller/namespace/namespace_controller.go#L140

```go
// worker processes the queue of namespace objects.
// Each namespace can be in the queue at most once.
// The system ensures that no two workers can process
// the same namespace at the same time.
func (nm *NamespaceController) worker() {
  workFunc := func() bool {
    key, quit := nm.queue.Get()
    if quit {
      return true
    }
    defer nm.queue.Done(key)

    err := nm.syncNamespaceFromKey(key.(string))
    if err == nil {
      // no error, forget this entry and return
      nm.queue.Forget(key)
      return false
    }

    if estimate, ok := err.(*deletion.ResourcesRemainingError); ok {
      t := estimate.Estimate/2 + 1
      klog.V(4).Infof("Content remaining in namespace %s, waiting %d seconds", key, t)
      nm.queue.AddAfter(key, time.Duration(t)*time.Second)
    } else {
      // rather than wait for a full resync, re-add the namespace to the queue to be processed
      nm.queue.AddRateLimited(key)
      utilruntime.HandleError(fmt.Errorf("deletion of namespace %v failed: %v", key, err))
    }
    return false
  }

  for {
    quit := workFunc()

    if quit {
      return
    }
  }
}
```

https://github.com/kubernetes/kubernetes/blob/master/pkg/controller/namespace/namespace_controller.go#L176

```go
// syncNamespaceFromKey looks for a namespace with the specified key in its store and synchronizes it
func (nm *NamespaceController) syncNamespaceFromKey(key string) (err error) {
  startTime := time.Now()
  defer func() {
    klog.V(4).Infof("Finished syncing namespace %q (%v)", key, time.Since(startTime))
  }()

  namespace, err := nm.lister.Get(key)
  if errors.IsNotFound(err) {
    klog.Infof("Namespace has been deleted %v", key)
    return nil
  }
  if err != nil {
    utilruntime.HandleError(fmt.Errorf("Unable to retrieve namespace %v from store: %v", key, err))
    return err
  }
  return nm.namespacedResourcesDeleter.Delete(namespace.Name)
}
```
