# Releasing

## Commit and PR naming

This repository expects Conventional Commit style PR titles because squash-merge commit messages are used for release automation.

Examples:

- `feat(vyos): add cloud-init variable for dns`
- `fix(build): pin vyos build container image`
- `chore: update terraform module`

## Automated flows

- `build-vyos-cloudinit.yml`: builds artifacts for pull requests and manual runs.
- `prerelease-beta.yml`: on every push to `main`, publishes a prerelease with a `vX.Y.Z-beta.N` tag and attaches build artifacts.
- `release-please.yml`: manages release PRs and stable GitHub releases from Conventional Commit history.
- `publish-release-assets.yml`: when a stable release is published, rebuilds and uploads release assets.

## Required GitHub repository settings

Set these in GitHub to enforce the workflow contract:

- Allow merge method: squash only.
- Require pull request before merge on `main`.
- Require status checks (at least `PR Title Lint` and PR build workflow).
- Require linear history.
- Optionally require signed commits.
