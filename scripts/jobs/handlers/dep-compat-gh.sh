#!/bin/bash
# dep-compat-gh.sh -- prove declaration-level incompatibility for one npm bump.
#
# Invoked as: dep-compat-gh.sh <owner/repo> <pr-number> <package> <new-version>
# Emits one TSV proof from dep-compat-check.mjs, or exits non-zero with no stdout
# when the declarations are compatible, incomplete, unsupported, or unreadable.
# The caller therefore falls open to a full botanist review on every uncertainty.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../common.sh
source "$HERE/../common.sh"
export GARDEN_TAG=dep-compat

repo="${1:?usage: dep-compat-gh.sh <owner/repo> <pr> <package> <new-version>}"
pr="${2:?usage: dep-compat-gh.sh <owner/repo> <pr> <package> <new-version>}"
pkg="${3:?usage: dep-compat-gh.sh <owner/repo> <pr> <package> <new-version>}"
newv="${4:?usage: dep-compat-gh.sh <owner/repo> <pr> <package> <new-version>}"
: "${GARDEN_NPM_REGISTRY:=https://registry.npmjs.org}"
: "${GARDEN_DEP_COMPAT_HTTP_TIMEOUT:=20}"
: "${GARDEN_DEP_COMPAT_MAX_MANIFESTS:=24}"

require_tools gh jq curl node npm
case "$repo" in
  */*) case "$repo" in *[!A-Za-z0-9._/-]*|*/*/*) exit 1;; esac ;;
  *) exit 1;;
esac
case "$pr" in ''|*[!0-9]*) exit 1;; esac
case "$pkg" in *[!A-Za-z0-9._@/-]*|'') exit 1;; esac
case "$pkg" in @*/*|[A-Za-z0-9._-]*) ;; *) exit 1;; esac
case "$newv" in *[!A-Za-z0-9.+_-]*|'') exit 1;; esac
# owner/repo-looking names are GitHub Actions, not npm packages.
case "$pkg" in @*/*) ;; */*) exit 1;; esac

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

pr_doc="$(gh_api_retry "repos/$repo/pulls/$pr")" || exit 1
head_repo="$(printf '%s' "$pr_doc" | jq -r '.head.repo.full_name // empty')"
head_sha="$(printf '%s' "$pr_doc" | jq -r '.head.sha // empty')"
case "$head_repo" in
  */*) case "$head_repo" in *[!A-Za-z0-9._/-]*|*/*/*) exit 1;; esac ;;
  *) exit 1;;
esac
case "$head_sha" in *[!A-Fa-f0-9]*|'') exit 1;; esac
case "$GARDEN_DEP_COMPAT_MAX_MANIFESTS" in ''|*[!0-9]*) exit 1;; esac
[ "$GARDEN_DEP_COMPAT_MAX_MANIFESTS" -ge 1 ] && [ "$GARDEN_DEP_COMPAT_MAX_MANIFESTS" -le 100 ] || exit 1

enc_pkg="${pkg//\//%2f}"
target="$(curl -fsSL --max-time "$GARDEN_DEP_COMPAT_HTTP_TIMEOUT" \
  "$GARDEN_NPM_REGISTRY/$enc_pkg/$newv" 2>/dev/null)" || exit 1
printf '%s' "$target" | jq -e 'type == "object"' >/dev/null || exit 1

# Root plus package manifests changed by the PR, and manifests alongside changed
# lockfiles. This bounded set covers root projects and Dependabot update directories
# without cloning or installing the repository.
printf '%s\n' package.json > "$tmp/paths"
gh_api_retry --paginate "repos/$repo/pulls/$pr/files?per_page=100" \
  | jq -r '.[].filename // empty' \
  | while IFS= read -r path; do
      case "$path" in
        package.json|*/package.json) printf '%s\n' "$path" ;;
        package-lock.json|yarn.lock|pnpm-lock.yaml) printf '%s\n' package.json ;;
        */package-lock.json|*/yarn.lock|*/pnpm-lock.yaml)
          printf '%s/package.json\n' "${path%/*}" ;;
      esac
    done >> "$tmp/paths" || exit 1
sort -u "$tmp/paths" | head -n "$GARDEN_DEP_COMPAT_MAX_MANIFESTS" > "$tmp/bounded-paths"

: > "$tmp/manifests"
while IFS= read -r path; do
  case "$path" in *[!A-Za-z0-9._/-]*|'') continue;; esac
  enc_path="$(jq -rn --arg p "$path" '$p|@uri')"
  doc="$(gh_api_retry "repos/$head_repo/contents/$enc_path?ref=$head_sha")" || continue
  manifest="$(printf '%s' "$doc" | jq -r '.content // empty | gsub("\\n"; "") | @base64d' 2>/dev/null)" || continue
  printf '%s' "$manifest" | jq -e 'type == "object"' >/dev/null 2>&1 || continue
  jq -cn --arg path "$path" --argjson manifest "$manifest" '{path:$path, manifest:$manifest}' >> "$tmp/manifests"
done < "$tmp/bounded-paths"
[ -s "$tmp/manifests" ] || exit 1

jq -sc --arg packageName "$pkg" --argjson target "$target" \
  '{packageName:$packageName, target:$target, manifests:.}' "$tmp/manifests" \
  | GARDEN_NPM_ROOT="$(npm root -g)" node "$HERE/dep-compat-check.mjs" \
  | head -1 > "$tmp/result"
[ -s "$tmp/result" ] || exit 1
cat "$tmp/result"
