# Automation with KCL

## Prerequisite

+ Firstly, download and install [KCL](https://kcl-lang.io/docs/user_docs/getting-started/install), [kpm](https://kcl-lang.io/docs/user_docs/guides/package-management/installation) and [kcl-openapi](https://kcl-lang.io/docs/tools/cli/openapi/quick-start) according to the instructions, and then prepare a Kubernetes environment.

### 1. Show Config

We can run the following command to show the config.

```bash
cat main.k
```

The output is

```python
schema App:
    """The application model."""
    name: str
    replicas: int
    labels?: {str:str} = {app = name}

app: App {
    name = "app"
    replicas = 1
    labels.key = "value"
}
```

We can run the command to get the config

```bash
kcl main.k
```

The output is

```yaml
app:
  name: app
  replicas: 1
  labels:
    app: app
    key: value
```

### 2. Use KCL CLI for Automation

KCL allows us to directly modify the values in the configuration model through the KCL CLI `-O|--overrides` parameter. The parameter contains three parts e.g., `pkg`, `identifier`, `attribute` and `override_value`.

```bash
kcl main.k -O override_spec
```

- `override_spec` represents a unified representation of the configuration model fields and values that need to be modified

```bash
override_spec: [[pkgpath] ":"] identifier ("=" value | "-")
```

- `pkgpath`: indicates the package path where the identifier needs to be modified, usually in the form of `a.b.c`. For the main package,`pkgpath` is represented as `__ main__`. When omitted or not written, it indicates the main package
- `identifier` indicates the identifier that needs to modify the configuration, usually in the form of `a.b.c`.
- `value` indicates the value of the configuration that needs to be modified, which can be any legal KCL expression, such as number/string literal value, list/dict/schema expression, etc.
- `=` denotes modifying of the value of the identifier.
- `-` denotes deleting of the identifier.

#### Override Configuration

Run the command to update the application name.

```bash
kcl main.k -O app.name='new_app'
```

The output is

```yaml
app:
  name: new_app
  replicas: 1
  labels:
    app: new_app
    key: value
```

We can see the `name` attribute of the `app` config is updated to `new_app`.

Besides, when we use KCL CLI `-d` argument, the KCL file will be modified to the following content at the same time.

```bash
kcl main.k -O app.name='new_app' -d
```

```python
schema App:
    """The application model."""
    name: str
    replicas: int
    labels?: {str:str} = {app = name}

app: App {
    name = "new_app"
    replicas = 1
    labels: {key = "value"}
}
```

#### Delete Configuration

Run the command to delete the `key` attribute of `labels`.

```bash
kcl main.k -O app.labels.key-
```

The output is

```yaml
app:
  name: app
  replicas: 1
  labels:
    app: app
```
