# Release Manifest

Copyright (c) StagePlane contributors.

## Architectural intent

This manifest records the initial creation of the public `stagectl` release-distribution repository package.

## Ownership boundary

This file owns package provenance for this repository snapshot.

## Non-responsibilities

It does not define a production controller release or customer license entitlement.

## Package

```text
stageplane-stagectl-releases-20260502063000.zip
```

## Contents

```text
install.sh
shims/stagectl
packages/stagectl-release-manifest.example.yaml
docs/INSTALL.md
docs/RELEASE_MODEL.md
.github/workflows/validate-installer.yaml
README.md
LICENSE
NOTICE
SECURITY.md
```

## Validation

```text
bash -n install.sh: pass
bash -n shims/stagectl: pass
required files: pass
ZIP integrity: pass
```

## 20260503002000 — GitHub Actions Node 24 compatibility

- Updated the installer validation workflow to use Node 24-compatible GitHub Actions references.
- Preserved the public installer, shim, release manifest example, documentation, and binary-free repository model.
- Added packaging validation to reject deprecated Node runtime workflow references before handoff.
