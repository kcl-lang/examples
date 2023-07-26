# Data Integration in KCL

## Prerequisite

+ Firstly, download and install [KCL](https://kcl-lang.io/docs/user_docs/getting-started/install), [kpm](https://kcl-lang.io/docs/user_docs/guides/package-management/installation) and [kcl-openapi](https://kcl-lang.io/docs/tools/cli/openapi/quick-start) according to the instructions, and then prepare a Kubernetes environment.

## Quick Start

### 1. YAML Integration

We can run the following command to show the YAML integration config.

```bash
cat yaml.k
```

```python
import yaml

schema Server:
    ports: [int]

server: Server = yaml.decode("""\
ports:
- 80
- 8080
""")
server_yaml = yaml.encode({
    ports = [80, 8080]
})
```

In the above code, we use the built-in `yaml` module of KCL and its `yaml.decode` function directly integrates YAML data, and uses the `Server` schema to directly verify the integrated YAML data. In addition, we can use `yaml.encode` to serialize YAML data. We can obtain the configuration output through the following command:

```shell
kcl yaml.k
```

The output is

```yaml
server:
  ports:
  - 80
  - 8080
server_yaml: |
  ports:
  - 80
  - 8080
```

### 2. JSON Integration

Similarly, for JSON data, we can use `json.encode` and `json.decode` function performs data integration in the same way.

We can run the following command to show the JSON integration config.

```bash
cat json.k
```

```python
import json

schema Server:
    ports: [int]

server: Server = json.decode('{"ports": [80, 8080]}')
server_json = json.encode({
    ports = [80, 8080]
})
```

The output of the execution command is:

```shell
kcl json.k
```

```yaml
server:
  ports:
  - 80
  - 8080
server_json: '{"ports": [80, 8080]}'
```
