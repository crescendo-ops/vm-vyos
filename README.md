# vm-vyos

Build automation and Terraform for the VyOS router image and VM.

## Repository Layout

- `os-image/build.sh`: builds VyOS artifacts (`.iso`, `.qcow2`, `.log`, `SHA256SUMS`)
- `os-image/custom-flavor.toml`: VyOS flavor definition used by the build script
- `os-image/vyos-1x-package.toml`: pinned `vyos-1x` package source/version used by builds
- `terraform/vyos-router`: VM provisioning files
- `scripts/validate-commit-history.sh`: validates scoped conventional commit subjects

## Build VyOS Artifacts Locally

From repository root:

```bash
OUT_DIR="$PWD/os-image/artifacts" ./os-image/build.sh
```

Version pinning is tracked in-repo via:

```bash
os-image/vyos-1x-package.toml
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

## Commit and PR Title Convention

- Use semantic format with mandatory scope: `<type>(<scope>): <description>`.
- Optional breaking marker is supported: `<type>(<scope>)!: <description>`.
- Allowed types: `fix`, `feat`, `chore`, `docs`, `refactor`, `test`, `ci`, `build`, `perf`.
- Examples: `fix(ci): preserve multiline release notes`, `build(vyos): publish iso assets`.

## CI and Release

- PR checks (Terraform fmt/validate + Bash syntax): `.github/workflows/vyos-ci.yml`
- PR title semantic validation for release automation: `.github/workflows/release-pr-title-lint.yml`
- Stable release automation on `main`: `.github/workflows/release-please.yml`
- Beta prerelease publish (manual): `.github/workflows/release-publish-beta.yml`
- Build and upload VyOS release assets (manual, stable + beta, includes artifact build): `.github/workflows/release-publish-assets.yml`
