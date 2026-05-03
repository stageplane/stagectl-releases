# StagePlane `stagectl` Releases

Copyright (c) StagePlane contributors.

## Architectural intent

This repository is the public distribution surface for the `stagectl` controller binary. It stores the public installer, release documentation, validation workflows, and release-manifest examples. Compiled binaries are published as GitHub Release assets, not committed to this repository tree.

## Ownership boundary

This repository owns public binary distribution mechanics for `stagectl`: install script behavior, release asset naming conventions, checksum verification, and operator-facing download instructions.

## Non-responsibilities

This repository does not own the private controller source code, license-server implementation, AWS infrastructure modules, customer licenses, secrets, Cloudflare runtime configuration, Terraform/OpenTofu modules, or production infrastructure deployment.

---

## Quick install

Install the latest published `stagectl` release for your operating system and CPU architecture:

```bash
curl -fsSL "https://raw.githubusercontent.com/stageplane/stagectl-releases/main/install.sh" | bash
```

Install a pinned version:

```bash
STAGECTL_VERSION=20260502060000 \
  curl -fsSL "https://raw.githubusercontent.com/stageplane/stagectl-releases/main/install.sh" | bash
```

Install into a repository-local `bin/` directory:

```bash
STAGECTL_VERSION=20260502060000 \
STAGECTL_INSTALL_DIR=./bin \
  curl -fsSL "https://raw.githubusercontent.com/stageplane/stagectl-releases/main/install.sh" | bash
```

Verify:

```bash
~/.stageplane/bin/stagectl version
```

## Supported release assets

Every production release should publish these assets:

```text
stagectl-darwin-arm64
stagectl-darwin-amd64
stagectl-linux-amd64
stagectl-linux-arm64
stagectl-windows-amd64.exe
checksums.txt
stagectl-release-manifest.yaml
```

The installer detects the local platform and downloads the matching asset from the GitHub Release.

## AWS baseline consumption model

The public `stageplane-aws-infrastructure` repository should not depend on a single committed Linux binary for all users. Instead it should either:

1. keep no binary in Git and use this installer during CI/local setup; or
2. keep a small wrapper at `bin/stagectl` that downloads and dispatches to the correct architecture-specific binary.

A wrapper template is provided in:

```text
shims/stagectl
```

## Release provenance

Release manifests should use the schema example in:

```text
packages/stagectl-release-manifest.example.yaml
```

The manifest records the release tag, asset names, checksums, and source controller version used to build the binary artifacts.
