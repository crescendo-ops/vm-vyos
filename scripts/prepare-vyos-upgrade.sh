#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<USAGE
Usage: $0 [--package-file PATH] [--body-file PATH] [--repo OWNER/REPO] [--dry-run]

Options:
  --package-file PATH  Path to the VyOS package TOML file.
  --body-file PATH     Output path for generated PR body markdown.
  --repo OWNER/REPO    Upstream repository to compare against (default: vyos/vyos-1x).
  --dry-run            Do not modify the package file.
USAGE
}

package_file="os-image/vyos-1x-package.toml"
body_file="/tmp/vyos-upgrade-pr.md"
upstream_repo="vyos/vyos-1x"
dry_run="false"

while [ "$#" -gt 0 ]; do
  case "$1" in
    --package-file)
      package_file="$2"
      shift 2
      ;;
    --body-file)
      body_file="$2"
      shift 2
      ;;
    --repo)
      upstream_repo="$2"
      shift 2
      ;;
    --dry-run)
      dry_run="true"
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      usage >&2
      exit 1
      ;;
  esac
done

if [ ! -f "$package_file" ]; then
  echo "Package file not found: $package_file" >&2
  exit 1
fi

old_sha="$(awk -F'"' '/^commit_id = "/ { print $2; exit }' "$package_file")"
if [ -z "$old_sha" ]; then
  echo "Unable to read commit_id from $package_file" >&2
  exit 1
fi

api_base="https://api.github.com/repos/${upstream_repo}"
api_headers=(
  -H "Accept: application/vnd.github+json"
  -H "X-GitHub-Api-Version: 2022-11-28"
)

repo_json="$(curl -fsSL "${api_headers[@]}" "$api_base")"
default_branch="$(printf '%s' "$repo_json" | jq -r '.default_branch')"
new_sha="$(curl -fsSL "${api_headers[@]}" "$api_base/commits/$default_branch" | jq -r '.sha')"

if [ -z "$default_branch" ] || [ "$default_branch" = "null" ] || [ -z "$new_sha" ] || [ "$new_sha" = "null" ]; then
  echo "Unable to resolve upstream default branch or head commit" >&2
  exit 1
fi

new_sha_short="${new_sha:0:12}"
changed="false"
if [ "$old_sha" != "$new_sha" ]; then
  changed="true"
fi

compare_url="https://github.com/${upstream_repo}/compare/${old_sha}...${new_sha}"
old_commit_url="https://github.com/${upstream_repo}/commit/${old_sha}"
new_commit_url="https://github.com/${upstream_repo}/commit/${new_sha}"

compare_json=""
compare_status="unknown"
ahead_by="0"
if compare_json="$(curl -fsSL "${api_headers[@]}" "$api_base/compare/${old_sha}...${new_sha}" 2>/dev/null)"; then
  compare_status="$(printf '%s' "$compare_json" | jq -r '.status // "unknown"')"
  ahead_by="$(printf '%s' "$compare_json" | jq -r '.ahead_by // 0')"
fi

if [ "$changed" = "true" ] && [ "$dry_run" = "false" ]; then
  sed -Ei "s|^commit_id = \"[0-9a-f]+\"$|commit_id = \"${new_sha}\"|" "$package_file"
fi

mkdir -p "$(dirname "$body_file")"
{
  echo "## VyOS upstream update"
  echo
  echo "This PR updates \`${package_file}\` to the latest commit on \`${upstream_repo}\` branch \`${default_branch}\`."
  echo
  echo "- Previous commit: [\`${old_sha}\`](${old_commit_url})"
  echo "- New commit: [\`${new_sha}\`](${new_commit_url})"
  echo "- Compare: [\`${old_sha:0:12}...${new_sha:0:12}\`](${compare_url})"

  if [ "$changed" != "true" ]; then
    echo
    echo "No upstream changes were detected."
  elif [ -n "$compare_json" ]; then
    echo
    echo "### Included upstream commits (${ahead_by})"

    commit_lines="$(printf '%s' "$compare_json" | jq -r --arg repo "$upstream_repo" '
      .commits
      | .[:50]
      | map("- [`" + (.sha[0:7]) + "`](https://github.com/" + $repo + "/commit/" + .sha + ") " + ((.commit.message | split("\\n")[0]) | gsub("\\r"; "")))
      | .[]
    ')"

    if [ -n "$commit_lines" ]; then
      printf '%s\n' "$commit_lines"
    else
      echo "- Commit details unavailable from compare API response."
    fi

    if [ "$ahead_by" -gt 50 ] 2>/dev/null; then
      echo
      echo "...and $((ahead_by - 50)) more commits."
    fi

    if [ "$compare_status" != "ahead" ] && [ "$compare_status" != "identical" ]; then
      echo
      echo "> Compare status reported by GitHub API: \`${compare_status}\`."
    fi
  else
    echo
    echo "### Included upstream commits"
    echo
    echo "- Unable to load compare details from GitHub API."
  fi
} > "$body_file"

if [ -n "${GITHUB_OUTPUT:-}" ]; then
  {
    echo "changed=${changed}"
    echo "old_sha=${old_sha}"
    echo "new_sha=${new_sha}"
    echo "new_sha_short=${new_sha_short}"
    echo "default_branch=${default_branch}"
    echo "body_file=${body_file}"
  } >> "$GITHUB_OUTPUT"
else
  printf 'changed=%s\nold_sha=%s\nnew_sha=%s\nnew_sha_short=%s\ndefault_branch=%s\nbody_file=%s\n' \
    "$changed" "$old_sha" "$new_sha" "$new_sha_short" "$default_branch" "$body_file"
fi
