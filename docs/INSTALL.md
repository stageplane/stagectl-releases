# Installing `stagectl`

Copyright (c) StagePlane contributors.

## Architectural intent

This document explains how operators install the architecture-correct `stagectl` binary from public release assets.

## Ownership boundary

This document owns operator installation guidance only.

## Non-responsibilities

It does not describe license issuance, cloud credential setup, or infrastructure deployment.

## Latest release

```bash
curl -fsSL "https://raw.githubusercontent.com/stageplane/stagectl-releases/main/install.sh" | bash
```

## Pinned release

```bash
STAGECTL_VERSION=20260502060000 \
  curl -fsSL "https://raw.githubusercontent.com/stageplane/stagectl-releases/main/install.sh" | bash
```

## Repo-local install

```bash
STAGECTL_VERSION=20260502060000 \
STAGECTL_INSTALL_DIR=./bin \
  curl -fsSL "https://raw.githubusercontent.com/stageplane/stagectl-releases/main/install.sh" | bash
```

## Supported platforms

```text
darwin/arm64
darwin/amd64
linux/amd64
linux/arm64
windows/amd64
```

## Checksum verification

The installer downloads `checksums.txt` from the same GitHub Release and verifies the selected asset before installation.

Checksum verification can be disabled only for emergency diagnostics:

```bash
STAGECTL_VERIFY_CHECKSUM=false ./install.sh
```
