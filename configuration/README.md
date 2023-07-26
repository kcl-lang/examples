# Configuration with KCL

## Prerequisite

+ Firstly, download and install [KCL](https://kcl-lang.io/docs/user_docs/getting-started/install), [kpm](https://kcl-lang.io/docs/user_docs/guides/package-management/installation) and [kcl-openapi](https://kcl-lang.io/docs/tools/cli/openapi/quick-start) according to the instructions, and then prepare a Kubernetes environment.

## Quick Start

### 1. Show Config

We can run the following command to show the config.

```bash
cat nginx.k
```

The output is

```python
schema Nginx:
    """Schema for Nginx configuration files"""
    http: Http

schema Http:
    server: Server

schema Server:
    listen: int | str    # The attribute `listen` can be int type or a string type.
    location?: Location  # Optional, but must be non-empty when specified

schema Location:
    root: str
    index: str

nginx = Nginx {
    http.server = {
        listen = 80
        location = {
            root = "/var/www/html"
            index = "index.html"
        }
    }
}
```

### 2. Generate YAML using KCL

Run the following command

```bash
kcl nginx.k
```

We can get the output YAML

```yaml
nginx:
  http:
    server:
      listen: 80
      location:
        root: /var/www/html
        index: index.html
```

### 3. Configuration with Dynamic Parameters

Besides, we can dynamically receive external parameters through the KCL builtin function `option`. For example, for the following KCL file (db.k), we can use the KCL command line `-D` flag to receive an external dynamic parameter.

```bash
cat db.k
```

```python
env: str = option("env") or "dev"  # The attribute `env` has a default value "den"
database: str = option("database")
hosts = {
    dev = "postgres.dev"
    stage = "postgres.stage"
    prod = "postgres.prod"
}
dbConfig = {
    host = hosts[env]
    database = database
    port = "2023"
    conn = "postgres://${host}:${port}/${database}"
}
```

```bash
# Use the `-D` flag to input external parameters.
kcl db.k -D database="foo"
```

The output is

```yaml
env: dev
database: foo
hosts:
  dev: postgres.dev
  stage: postgres.stage
  prod: postgres.prod
dbConfig:
  host: postgres.dev
  database: foo
  port: "2023"
  conn: "postgres://postgres.dev:2023/foo"
```
