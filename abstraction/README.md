# Abstraction with KCL

## Prerequisite

+ Firstly, download and install [KCL](https://kcl-lang.io/docs/user_docs/getting-started/install), [kpm](https://kcl-lang.io/docs/user_docs/guides/package-management/installation) and [kcl-openapi](https://kcl-lang.io/docs/tools/cli/openapi/quick-start) according to the instructions, and then prepare a Kubernetes environment.

## Quick Start

### 1. Show Config

We can run the following command to show the config.

```bash
cat main.k
```

The output is

```python
import .app

app.App {
    name = "app"
    containers.nginx = {
        image = "nginx"
        ports = [{containerPort = 80}]
    }
    service.ports = [{ port = 80 }]
}
```

In the above code, we defined a configuration using the `App` schema, where we configured an `nginx` container and configured it with an `80` service port.

Besides, KCL allows developers to define the resources required for their applications in a declarative manner and is tied to a platform such as Docker Compose or Kubernetes manifests and allows to generate a platform-specific configuration file such as `docker-compose.yaml` or a Kubernetes `manifests.yaml` file. Next, let's generate the corresponding configuration.

### 2. Transform the Application Config into Docker Compose Config

If we want to transform the application config into the docker compose config, we can run the command simply:

```shell
kcl main.k docker_compose_render.k
```

The output is

```yaml
services:
  app:
    image: nginx
    ports:
      - published: 80
        target: 80
        protocol: TCP
```

### 3. Transform the Application Config into Kubernetes Deployment and Service Manifests

If we want to transform the application config into the Kubernetes manifests, we can run the command simply:

```shell
kcl main.k kubernetes_render.k
```

The output is

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: app
  labels:
    app: app
spec:
  replicas: 1
  selector:
    matchLabels:
      app: app
  template:
    metadata:
      labels:
        app: app
    spec:
      containers:
        - name: nginx
          image: nginx
          ports:
            - protocol: TCP
              containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: app
  labels:
    app: app
spec:
  selector:
    app: app
  ports:
    - port: 80
      protocol: TCP
```
