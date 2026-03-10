#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FLAVOR_FILE="${SCRIPT_DIR}/custom-flavor.toml"
VYOS_1X_PACKAGE_FILE="${SCRIPT_DIR}/vyos-1x-package.toml"

OUT_DIR="${OUT_DIR:-$PWD/out}"

mkdir -p "${OUT_DIR}"

docker run --rm -i --privileged \
  --platform linux/amd64 \
  --tmpfs "/work:rw,exec,dev,suid,size=10g" \
  -v "${OUT_DIR}:/out" \
  -v "${FLAVOR_FILE}:/custom-flavor.toml:ro" \
  -v "${VYOS_1X_PACKAGE_FILE}:/vyos-1x-package.toml:ro" \
  "vyos/vyos-build:current" \
  bash -s <<'CONTAINER_SCRIPT'
set -euo pipefail

cd /work

git clone https://github.com/vyos/vyos-build .

cp /vyos-1x-package.toml scripts/package-build/vyos-1x/package.toml

mkdir -p data/build-flavors
cp /custom-flavor.toml "data/build-flavors/custom-flavor.toml"

export LB_SQUASHFS_OPTIONS="-no-xattrs -processors $(nproc)"
export MKSQUASHFS_OPTIONS="-no-xattrs -processors $(nproc)"

./build-vyos-image --architecture amd64 --build-by "quentin-roche" custom-flavor

find build -type f \( -name "*.qcow2" -o -name "*.iso" -o -name "*.log" \) -exec cp --parents {} /out/ \;
find /out -type f \( -name "*.qcow2" -o -name "*.iso" -o -name "*.log" \) -print0 | sort -z | xargs -0 sha256sum > /out/SHA256SUMS
CONTAINER_SCRIPT

echo "Artifacts available in: ${OUT_DIR}"
