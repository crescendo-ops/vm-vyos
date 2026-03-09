# Agent Working Conventions

## Branch Naming
- Use semantic branch names with one of these prefixes: `fix/`, `feat/`, `chore/`, `docs/`, `refactor/`, `test/`, `ci/`, `build/`, `perf/`.
- Keep names descriptive and concise.

## Pull Request Naming
- PR titles must follow semantic commit style: `<type>(<scope>): <description>`.
- Allowed types include: `fix`, `feat`, `chore`, `docs`, `refactor`, `test`, `ci`, `build`, `perf`.

## Commit Subject Naming
- Commit subjects must follow semantic commit style with mandatory scope: `<type>(<scope>): <description>`.
- Optional breaking marker is allowed: `<type>(<scope>)!: <description>`.
- Allowed types include: `fix`, `feat`, `chore`, `docs`, `refactor`, `test`, `ci`, `build`, `perf`.

## Release Assets Context
- This repository publishes VyOS build outputs (`.iso`, `.qcow2`, `.log`, `SHA256SUMS`) as release assets.
- Do not assume NixOS-specific release artifacts or workflows in this repo.
