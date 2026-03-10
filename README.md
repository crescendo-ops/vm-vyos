# vm-vyos

Build automation and Terraform for the VyOS router image and VM.

## Repository Layout

- `images/vyos-router/build.sh`: builds VyOS artifacts (`.iso`, `.qcow2`, `.log`, `SHA256SUMS`)
- `images/vyos-router/custom-flavor.toml`: VyOS flavor definition used by the build script
- `terraform/vyos-router`: VM provisioning files
- `scripts/validate-commit-history.sh`: validates scoped conventional commit subjects

## Build VyOS Artifacts Locally

From repository root:

```bash
OUT_DIR="$PWD/images/vyos-router/artifacts" ./images/vyos-router/build.sh
```

Generated outputs include:

- `images/vyos-router/artifacts/**/*.iso`
- `images/vyos-router/artifacts/**/*.qcow2`
- `images/vyos-router/artifacts/**/*.log`
- `images/vyos-router/artifacts/SHA256SUMS`

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
