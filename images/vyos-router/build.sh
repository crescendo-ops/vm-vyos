#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FLAVOR_FILE="${SCRIPT_DIR}/custom-flavor.toml"

DOCKER_IMAGE="${DOCKER_IMAGE:-vyos/vyos-build:current}"
TMPFS_SIZE="${TMPFS_SIZE:-10g}"
BUILD_BY="${BUILD_BY:-quentin-roche}"
VYOS_GIT_REF="${VYOS_GIT_REF:-}"
OUT_DIR="${OUT_DIR:-$PWD/out}"

mkdir -p "${OUT_DIR}"

docker run --rm -i --privileged \
  --platform linux/amd64 \
  --tmpfs "/work:rw,exec,dev,suid,size=${TMPFS_SIZE}" \
  -v "${OUT_DIR}:/out" \
  -v "${FLAVOR_FILE}:/custom-flavor.toml:ro" \
  "${DOCKER_IMAGE}" \
  bash -s -- "${BUILD_BY}" "${VYOS_GIT_REF}" <<'CONTAINER_SCRIPT'
set -euo pipefail

BUILD_BY="$1"
VYOS_GIT_REF="$2"

cd /work

if [ -n "${VYOS_GIT_REF}" ]; then
  git clone --depth 1 --branch "${VYOS_GIT_REF}" https://github.com/vyos/vyos-build .
else
  git clone https://github.com/vyos/vyos-build .
fi

mkdir -p data/build-flavors
cp /custom-flavor.toml "data/build-flavors/custom-flavor.toml"

export LB_SQUASHFS_OPTIONS="-no-xattrs -processors $(nproc)"
export MKSQUASHFS_OPTIONS="-no-xattrs -processors $(nproc)"

./build-vyos-image --architecture amd64 --build-by "${BUILD_BY}" custom-flavor

find build -type f \( -name "*.qcow2" -o -name "*.iso" -o -name "*.log" \) -exec cp --parents {} /out/ \;
find /out -type f \( -name "*.qcow2" -o -name "*.iso" -o -name "*.log" \) -print0 | sort -z | xargs -0 sha256sum > /out/SHA256SUMS
CONTAINER_SCRIPT

echo "Artifacts available in: ${OUT_DIR}"
