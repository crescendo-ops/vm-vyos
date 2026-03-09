#!/usr/bin/env bash
set -euo pipefail

pattern='^(feat|fix|chore|docs|refactor|test|ci|build|perf)\([[:alnum:]_.\/-]+\)(!)?: .+'
range="${1:-HEAD}"

echo "Checking commit subjects in range: ${range}"
invalid=0

while IFS= read -r subject; do
  if ! [[ "${subject}" =~ ${pattern} ]]; then
    echo "Invalid commit subject: ${subject}" >&2
    echo "Expected format: <type>(<scope>): <description> (optional ! before colon)" >&2
    invalid=1
  fi
done < <(git log --format=%s "${range}")

if [ "${invalid}" -ne 0 ]; then
  echo "Commit message format check failed." >&2
  exit 1
fi
