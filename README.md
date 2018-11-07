# GhGet

GhGet allows easy installation of binaries published on Github using a standardized naming scheme.

## Usage

```bash
curl -sL http://bit.ly/gh-get | PROJECT=NoUseFreak/sawsh bash
```

## Options

These options can be passed as environment variables.

| Property   |          | Default        | Description |
| ---------- | -------- | -------------- | ----------- |
| `PROJECT`  | Required | n/a            | Set the project you want to install (ex: username/project). |
| `VERSION`  | Optional | latest         | When set, the specified version will be installed instead of the latest. |
| `BIN_DIR`  | Optional | /usr/local/bin | Locatoin where the binary will be installed. |
| `BIN_NAME` | Optional | n/a            | When set will use this name to find the binary. |
| `TMP_DIR`  | Optional | /tmp           | Temporary location in which the download will happen. |

## Naming scheme

The naming scheme expects release files in the following form:

```
[BIN_NAME]_[OS]_[ARCH].tar.gz
```

An example of this would be `sawsh_linux_amd64.tar.gz`.
