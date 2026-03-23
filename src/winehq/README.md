
# WineHQ (winehq)

Install wine, run Windows programs on linux devcontainer

## Example Usage

```json
"features": {
    "ghcr.io/dewkul/devcontainer-features/winehq:0": {}
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| branch | Install wine from branch stable / staging / devel | string | stable |
| version | Specify wine version | string | latest |

# Supported images

A list of images that successfully passed the test
- **Ubuntu** 
    - mcr.microsoft.com/devcontainers/base:ubuntu
    - mcr.microsoft.com/devcontainers/base:noble
- **Debian** - 
    - mcr.microsoft.com/devcontainers/base:debian
    - mcr.microsoft.com/devcontainers/base:trixie
- **Alpine** - 
    - mcr.microsoft.com/devcontainers/base:alpine
    - mcr.microsoft.com/devcontainers/base:alpine-3.22

---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/dewkul/devcontainer-features/blob/main/src/winehq/devcontainer-feature.json).  Add additional notes to a `NOTES.md`._
