# StagePlane `stagectl` Release Model

Copyright (c) StagePlane contributors.

## Architectural intent

This document defines the binary publication model for `stagectl` so public infrastructure baselines can consume the correct binary for each operator platform.

## Ownership boundary

This document owns artifact naming, release publishing, and public consumption flow.

## Non-responsibilities

It does not own controller source code, customer licensing policy, Cloudflare Worker deployment, or Terraform/OpenTofu module content.

## Flow

```text
private controller source repo
  -> build multi-arch stagectl binaries
  -> publish assets to stageplane/stagectl-releases
  -> update public AWS baseline release manifest
  -> AWS repo CI downloads linux/amd64 or linux/arm64 as needed
```

## Required release assets

```text
stagectl-darwin-arm64
stagectl-darwin-amd64
stagectl-linux-amd64
stagectl-linux-arm64
stagectl-windows-amd64.exe
checksums.txt
stagectl-release-manifest.yaml
```

## Public AWS baseline recommendation

The AWS baseline should avoid committing a single binary. It may keep `bin/.gitkeep` and use the installer, or it may use the wrapper script from `shims/stagectl` for ergonomic local execution.
