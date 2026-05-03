#!/usr/bin/env bash
# Copyright (c) StagePlane contributors.
#
# Architectural intent:
#   Installs the correct architecture-specific stagectl binary from the public
#   stageplane/stagectl-releases GitHub Release assets. The script is designed
#   for curl-pipe usage, CI usage, and repo-local installation from public AWS
#   infrastructure baselines.
#
# Ownership boundary:
#   This script owns download URL construction, OS/architecture detection,
#   checksum verification, install directory creation, and final binary naming.
#
# Non-responsibilities:
#   It does not build stagectl from source, issue licenses, configure cloud
#   credentials, mutate infrastructure, or contact the StagePlane license server.

set -euo pipefail

REPO="${STAGECTL_RELEASE_REPO:-stageplane/stagectl-releases}"
VERSION="${STAGECTL_VERSION:-latest}"
INSTALL_DIR="${STAGECTL_INSTALL_DIR:-${HOME}/.stageplane/bin}"
BINARY_NAME="${STAGECTL_BINARY_NAME:-stagectl}"
VERIFY_CHECKSUM="${STAGECTL_VERIFY_CHECKSUM:-true}"

log() {
  printf 'stagectl installer: %s\n' "$*" >&2
}

fail() {
  printf 'stagectl installer error: %s\n' "$*" >&2
  exit 1
}

require_cmd() {
  command -v "$1" >/dev/null 2>&1 || fail "required command not found: $1"
}

normalize_os() {
  case "$(uname -s | tr '[:upper:]' '[:lower:]')" in
    darwin) printf 'darwin' ;;
    linux) printf 'linux' ;;
    msys*|mingw*|cygwin*) printf 'windows' ;;
    *) fail "unsupported operating system: $(uname -s)" ;;
  esac
}

normalize_arch() {
  case "$(uname -m)" in
    arm64|aarch64) printf 'arm64' ;;
    x86_64|amd64) printf 'amd64' ;;
    *) fail "unsupported CPU architecture: $(uname -m)" ;;
  esac
}

resolve_tag() {
  local version="$1"
  if [[ "${version}" == "latest" ]]; then
    printf 'latest'
    return
  fi
  if [[ "${version}" == v* ]]; then
    printf '%s' "${version}"
  else
    printf 'v%s' "${version}"
  fi
}

sha_cmd() {
  if command -v sha256sum >/dev/null 2>&1; then
    printf 'sha256sum'
  elif command -v shasum >/dev/null 2>&1; then
    printf 'shasum -a 256'
  else
    fail "sha256sum or shasum is required for checksum verification"
  fi
}

checksum_asset_line() {
  local checksums_file="$1"
  local asset_name="$2"
  awk -v asset="${asset_name}" '$2 == asset {print $1}' "${checksums_file}"
}

main() {
  require_cmd curl
  require_cmd grep
  require_cmd awk

  local os arch ext asset tag base_url tmpdir target checksum_file expected actual sha
  os="$(normalize_os)"
  arch="$(normalize_arch)"
  ext=""
  if [[ "${os}" == "windows" ]]; then
    ext=".exe"
  fi

  asset="stagectl-${os}-${arch}${ext}"
  tag="$(resolve_tag "${VERSION}")"

  if [[ "${tag}" == "latest" ]]; then
    base_url="https://github.com/${REPO}/releases/latest/download"
  else
    base_url="https://github.com/${REPO}/releases/download/${tag}"
  fi

  tmpdir="$(mktemp -d)"
  trap 'rm -rf "${tmpdir}"' EXIT

  log "repository: ${REPO}"
  log "version: ${VERSION}"
  log "platform: ${os}/${arch}"
  log "asset: ${asset}"
  log "install dir: ${INSTALL_DIR}"

  curl -fsSL "${base_url}/${asset}" -o "${tmpdir}/${asset}" || fail "failed to download ${asset} from ${base_url}"

  if [[ "${VERIFY_CHECKSUM}" == "true" ]]; then
    checksum_file="${tmpdir}/checksums.txt"
    curl -fsSL "${base_url}/checksums.txt" -o "${checksum_file}" || fail "failed to download checksums.txt from ${base_url}"
    expected="$(checksum_asset_line "${checksum_file}" "${asset}")"
    [[ -n "${expected}" ]] || fail "checksums.txt does not contain an entry for ${asset}"
    sha="$(sha_cmd)"
    actual="$(${sha} "${tmpdir}/${asset}" | awk '{print $1}')"
    [[ "${actual}" == "${expected}" ]] || fail "checksum mismatch for ${asset}: expected ${expected}, got ${actual}"
    log "checksum verified: ${actual}"
  else
    log "checksum verification disabled by STAGECTL_VERIFY_CHECKSUM=false"
  fi

  mkdir -p "${INSTALL_DIR}"
  target="${INSTALL_DIR}/${BINARY_NAME}${ext}"
  install -m 0755 "${tmpdir}/${asset}" "${target}"

  log "installed: ${target}"
  "${target}" version || true
}

main "$@"
