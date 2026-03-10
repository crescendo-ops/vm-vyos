# vm-vyos

Build automation and Terraform for the VyOS router image and VM.

## Repository Layout

- `os-image/build.sh`: builds VyOS artifacts (`.iso`, `.qcow2`, `.log`, `SHA256SUMS`)
- `os-image/custom-flavor.toml`: VyOS flavor definition used by the build script
- `config/vyos-1x-package.toml`: pinned `vyos-1x` package source/version used by builds
- `config/config.boot`: VyOS config baked into image builds
- `terraform/vyos-router`: VM provisioning files
- `scripts/validate-commit-history.sh`: validates scoped conventional commit subjects

## Build VyOS Artifacts Locally

From repository root:

```bash
OUT_DIR="$PWD/os-image/artifacts" ./os-image/build.sh
```

The build script appends `config/config.boot` as `default_config` in the flavor before running `build-vyos-image`.
Set `DEFAULT_CONFIG_FILE=/absolute/path/to/config.boot` to override the config source file.

Version pinning is tracked in-repo via:

```bash
config/vyos-1x-package.toml
```

Example:

```toml
[[packages]]
name = "vyos-1x"
commit_id = "124304285eef883069303773093ed76f6d593c16"
scm_url = "https://github.com/vyos/vyos-1x.git"
```

Generated outputs include:

- `os-image/artifacts/**/*.iso`
- `os-image/artifacts/**/*.qcow2`
- `os-image/artifacts/**/*.log`
- `os-image/artifacts/SHA256SUMS`

## Deploy VyOS on libvirt with ZFS ZVOL

Use the Ansible playbook:

```bash
ansible-playbook -i "192.168.1.124," -u root ansible/redeploy-vyos-vm.yml
```

Default hardcoded paths in the playbook:

- ZVOL dataset: `zroot/vm-disks/vyos-router/disk`
- ZVOL device: `/dev/zvol/zroot/vm-disks/vyos-router/disk`
- Local XML on your Mac: `config/vm-domain.xml`
- Remote XML on libvirt host: `/tmp/vm-domain.xml`
- Local qcow2 on your Mac: `vyos-beta-v0.0.1-5-custom-flavor-amd64.qcow2`
- Remote qcow2 on libvirt host: `/var/lib/libvirt/images/vyos-router.qcow2`

Behavior:

- Always replaces existing VM + ZVOL with a brand new instance.
- Copies the XML from your Mac to the libvirt host.
- Copies the qcow2 from your Mac to the libvirt host.
- Imports the `qcow2` image into the newly created ZVOL.
- Defines the VM from the copied XML.
- Enables autostart and starts the VM.

## Commit and PR Title Convention

- Use semantic format with mandatory scope: `<type>(<scope>): <description>`.
- Optional breaking marker is supported: `<type>(<scope>)!: <description>`.
- Allowed types: `fix`, `feat`, `deps`, `chore`, `docs`, `refactor`, `test`, `ci`, `build`, `perf`.
- Examples: `fix(ci): preserve multiline release notes`, `deps(vyos): bump vyos-1x pin`.

## CI and Release

- PR checks (Terraform fmt/validate + Bash syntax): `.github/workflows/vyos-ci.yml`
- PR title semantic validation for release automation: `.github/workflows/release-pr-title-lint.yml`
- Weekly automated VyOS pin updates with compare-based PR body: `.github/workflows/bump-vyos-commit-pin.yml`
- Stable release automation on `main`: `.github/workflows/release-please.yml`
- Beta prerelease publish (manual): `.github/workflows/release-publish-beta.yml`
- Build and upload VyOS release assets (manual, stable + beta, includes artifact build): `.github/workflows/release-publish-assets.yml`
