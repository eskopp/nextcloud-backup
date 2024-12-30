# Nextcloud Uploader Action

This GitHub Action uploads files or zip archives to a Nextcloud server using WebDAV.

## Features

- Uploads files or directories to Nextcloud.
- Optionally zips the files before uploading.
- Supports Base64-encoded inputs for enhanced security.

## Inputs

| Name            | Description                         | Required | Default |
| --------------- | ----------------------------------- | -------- | ------- |
| `nextcloud_url` | The Nextcloud WebDAV URL.           | true     | -       |
| `password` >    | Nextcloud password.                 | true     | -       |
| `base64`        | If true, inputs are Base64-encoded. | false    | `false` |

## Outputs

| Name            | Description                  |
| --------------- | ---------------------------- |
| `upload-status` | Status of the upload process |

## Example Workflow

```yaml
name: Upload to Nextcloud

on:
  push:
    branches:
      - main

jobs:
  upload:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout repository
        uses: actions/checkout@v3

      - name: Upload to Nextcloud
        uses: eskopp/nextcloud-uploader@v1
        with:
          nextcloud-url: "aHR0cHM6Ly9leGFtcGxlLmNvbS9yZW1vdGUucGhwL2Rhdi9maWxlcy91c2Vy"
          password: "YmFzZTY0X3Bhc3N3b3Jk"
          base64: "true"
```
