# Agent Working Conventions

## Branch Naming
- Use semantic branch names with one of these prefixes: `fix/`, `feat/`, `deps/`, `chore/`, `docs/`, `refactor/`, `test/`, `ci/`, `build/`, `perf/`.
- Keep names descriptive and concise.

## Pull Request Naming
- PR titles must follow semantic commit style: `<type>(<scope>): <description>`.
- Scope must reference a concrete subsystem (for example: `os-image`, `release-assets`, `ci`, `terraform`), not the repository name.
- Allowed types include: `fix`, `feat`, `deps`, `chore`, `docs`, `refactor`, `test`, `ci`, `build`, `perf`.
- Scope and description must be explicit and narrowly targeted.
- Avoid broad scopes when a more specific subsystem exists (for example: `os-image`, `release-assets`, `ci`, `terraform`).
- Prefer descriptions that name the concrete change.
- This repository builds VyOS images, so changes that add or expand OS capabilities should use `feat`.
- Use `chore` only for maintenance that does not change build outputs or runtime behavior (for example: formatting, internal tooling, CI-only maintenance, non-functional cleanup).

## Commit Subject Naming
- Commit subjects must be plain language and describe exactly what was done.
- Do not use semantic tags in commit subjects (no `feat(...)`, `fix(...)`, `chore(...)`, etc.).
- Only PR titles use semantic tagging.
- Prefer short imperative descriptions.

## Release Assets Context
- This repository publishes VyOS build outputs (`.iso`, `.qcow2`, `.log`, `SHA256SUMS`) as release assets.
- Do not assume NixOS-specific release artifacts or workflows in this repo.
