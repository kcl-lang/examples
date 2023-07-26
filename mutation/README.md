# Mutation with KCL

## Prerequisite

+ Firstly, download and install [KCL](https://kcl-lang.io/docs/user_docs/getting-started/install), [kpm](https://kcl-lang.io/docs/user_docs/guides/package-management/installation) and [kcl-openapi](https://kcl-lang.io/docs/tools/cli/openapi/quick-start) according to the instructions, and then prepare a Kubernetes environment.

## Quick Start

### 1. Show Config

We can run the following command to show the config.

```bash
cat transformer.k
```

```python
items = lambda {
    # Construct resource and params
    resource = option("resource_list")
    items = resource.items
    params = resource.functionConfig.spec.params
    new_replicas: int = params.replicas
    min_replicas: int = params.min_replicas or 0
    max_replicas: int = params.max_replicas or 99999
    # Define the validation function
    validate_replica_limit = lambda item, min_replicas: int, max_replicas: int, new_replicas: int {
        replicas = item.spec.replicas or 0
        assert min_replicas < replicas < max_replicas, "The provided number of replicas ${replicas} is not allowed for ${item.kind}: ${item.metadata.name}. Allowed range: ${min} - ${max}"
        item | {
            if typeof(new_replicas) == "int":
                spec.replicas = new_replicas
        }
    }
    # Validate All resource
    [validate_replica_limit(i, min_replicas, max_replicas, new_replicas) for i in items]
}()
```

The meaning of this function is to set the replicates of the deployment resource to our expected value `params.replicas`, which is defined in the file `kcl.yaml`.

```bash
cat kcl.yaml
```

The output is

```yaml
kcl_cli_configs:
  files:
    - ./transformer.k
  path_selector:
    - items
kcl_options:
  # Follow KRM KCL Spec
  - key: resource_list
    value:
      # Input KRM list
      items:
        - apiVersion: apps/v1
          kind: Deployment
          metadata:
            name: nginx-deployment
            labels:
              app: nginx
          spec:
            replicas: 3  # Will be mutated with the field `functionConfig.spec.params.replicas`
            selector:
              matchLabels:
                app: nginx
            template:
              metadata:
                labels:
                  app: nginx
              spec:
                containers:
                - name: nginx
                  image: nginx:1.14.2
                  ports:
                  - containerPort: 80
      functionConfig:
        spec:
          params:
            min_replicas: 0
            max_replicas: 5
            replicas: 4
```

We can execute the following command to obtain the results after mutation.

```bash
kcl
```

The output is

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: nginx
  name: nginx-deployment
spec:
  replicas: 4
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - image: nginx:1.14.2
        name: nginx
        ports:
        - containerPort: 80
```

## More Documents

See [here](https://github.com/kcl-lang/krm-kcl) for more.
