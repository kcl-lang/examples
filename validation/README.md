# Abstraction with KCL

## Prerequisite

+ Firstly, download and install [KCL](https://kcl-lang.io/docs/user_docs/getting-started/install) according to the instructions, and then prepare a Kubernetes environment.

## Quick Start

### 1. Show Config

We can run the following command to show the config.

```bash
cat schema.k
```

```python
schema User:
    name: str
    age: int
    message?: str
    data: Data
    labels: {str:}
    hc: [int]
        
    check:
        age > 10, "age must > 10"

schema Data:
    id: int
    value: str
```

In the schema, we can use the `check` keyword to write the validation rules of every schema attribute. Each line in the check block corresponds to a conditional expression. When the condition is satisfied, the validation is successful. The conditional expression can be followed by `, "check error message"` to indicate the message to be displayed when the check fails.

To sum up, the validation kinds supported in KCL schema are:

| Kind              | Method                                                                                    |
| ----------------- | ----------------------------------------------------------------------------------------- |
| Range             | Using comparison operators such as `<`, `>`                                               |
| Regex             | Using methods such as `match` from the `regex` system module                              |
| Length            | Using the `len` built-in function to get the length of a variable of type `list/dict/str` |
| Enum              | Using literal union types                                                                 |
| Optional/Required | Using optional/required attributes of schema                                                |
| Condition         | Using the check if conditional expression                                                 |

### 2. Validate the Data

There is a JSON format file `data.json`:

```json
{
    "name": "Alice",
    "age": 18,
    "message": "This is Alice",
    "data": {
        "id": 1,
        "value": "value1"
    },
    "labels": {
        "key": "value"
    },
    "hc": [1, 2, 3]
}
```

Execute the following command:

```bash
kcl vet data.json schema.k
```
