#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

CONFIG_FILE="${1:-${REPO_ROOT}/config/config.boot}"
PACKAGE_FILE="${REPO_ROOT}/config/vyos-1x-package.toml"

if [[ ! -f "${CONFIG_FILE}" ]]; then
  echo "Config file not found: ${CONFIG_FILE}" >&2
  exit 1
fi

if [[ ! -f "${PACKAGE_FILE}" ]]; then
  echo "VyOS package pin file not found: ${PACKAGE_FILE}" >&2
  exit 1
fi

if ! command -v docker >/dev/null 2>&1; then
  echo "docker is required to validate VyOS config format" >&2
  exit 1
fi

VYOS_1X_COMMIT_ID="$(awk -F'"' '/^commit_id = / {print $2; exit}' "${PACKAGE_FILE}")"

if [[ -z "${VYOS_1X_COMMIT_ID}" ]]; then
  echo "Unable to read vyos-1x commit_id from ${PACKAGE_FILE}" >&2
  exit 1
fi

docker run --rm --platform linux/amd64 \
  -e "VYOS_1X_COMMIT_ID=${VYOS_1X_COMMIT_ID}" \
  -v "${CONFIG_FILE}:/input-config.boot:ro" \
  vyos/vyos-build:current \
  bash -lc '
    set -euo pipefail

    if [[ ! -f /usr/lib/libvyosconfig.so.0 ]]; then
      apt-get update -qq >/dev/null
      apt-get install -y -qq --no-install-recommends libvyosconfig0 >/dev/null
    fi

    workdir="$(mktemp -d)"
    trap "rm -rf \"${workdir}\"" EXIT

    git -C "${workdir}" init -q
    git -C "${workdir}" remote add origin https://github.com/vyos/vyos-1x.git
    git -C "${workdir}" fetch --depth 1 origin "${VYOS_1X_COMMIT_ID}"
    git -C "${workdir}" checkout -q FETCH_HEAD

    PYTHONPATH="${workdir}/python" \
      python3 "${workdir}/src/utils/vyos-config-to-commands" /input-config.boot >/dev/null
  '

echo "VyOS config format is valid: ${CONFIG_FILE}"
