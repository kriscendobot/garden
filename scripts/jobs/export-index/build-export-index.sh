#!/bin/bash
# build-export-index.sh — deterministic, no-LLM generator of the export-name index
# for one (repo, commit). design: designs/export-index-build-vs-buy.md § 1.
#
#   build-export-index.sh <repo-root> <commit> [<owner/repo>]   > index.tsv
#
# Reads the tree at <commit> with `git archive` (never a checkout, so the caller's
# worktree is untouched), extracts it to a private temp dir, and runs the vendored
# Babel generator skills/build-vs-buy/export-index.cjs over it. <repo-root> may be a
# worktree or a bare clone. <owner/repo> defaults to the slug parsed from the
# `origin` remote. Output is sorted, so two runs are byte-identical.
#
# Exit: 0 index written to stdout; 2 usage; 3 git/node unavailable or the
# commit does not resolve (a reason on stderr).

set -uo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
: "${GARDEN_ROOT:=$(cd "$HERE/../../.." && pwd)}"
GENERATOR="${GARDEN_EXPORT_INDEX_GENERATOR:-$HERE/../../../skills/build-vs-buy/export-index.cjs}"
NODE_BIN="${GARDEN_NODE_BIN:-node}"

root="${1:-}"; commit="${2:-}"; slug="${3:-}"
if [ -z "$root" ] || [ -z "$commit" ]; then
  echo "build-export-index: usage: build-export-index.sh <repo-root> <commit> [<owner/repo>]" >&2
  exit 2
fi
command -v "$NODE_BIN" >/dev/null 2>&1 || { echo "build-export-index: node unavailable" >&2; exit 3; }

sha="$(git -C "$root" rev-parse --verify --quiet "$commit^{commit}")" \
  || { echo "build-export-index: cannot resolve $commit in $root" >&2; exit 3; }

if [ -z "$slug" ]; then
  url="$(git -C "$root" remote get-url origin 2>/dev/null || true)"
  slug="$(printf '%s\n' "$url" | sed -E 's#^.*github\.com[:/]##; s#\.git$##')"
  [ -n "$slug" ] || slug="local/$(basename "$(cd "$root" && pwd)" .git)"
fi

tree="$(mktemp -d "${TMPDIR:-/tmp}/export-index.XXXXXX")"
trap 'rm -rf "$tree"' EXIT
# Only the package manifests and JS/TS sources matter; extracting that subset
# keeps a large monorepo's archive cheap. `git archive` rejects a pathspec that
# matches nothing, so pass only the globs this tree actually has.
specs=()
listing="$(git -C "$root" ls-tree -r --name-only "$sha" 2>/dev/null)" \
  || { echo "build-export-index: cannot list $sha" >&2; exit 3; }
for glob in package.json '*.js' '*.mjs' '*.cjs' '*.jsx' '*.ts' '*.mts' '*.cts' '*.tsx'; do
  regex="$(printf '%s' "$glob" | sed 's/[.]/[.]/g; s/^[*]//')"
  grep -qE "(^|/)[^/]*$regex\$" <<<"$listing" && specs+=(":(glob)**/$glob")
done
if [ "${#specs[@]}" -gt 0 ]; then
  git -C "$root" archive --format=tar "$sha" -- "${specs[@]}" | tar -x -C "$tree" \
    || { echo "build-export-index: git archive failed for $sha" >&2; exit 3; }
fi
# node_modules / vendored bundles are never workspace packages.
find "$tree" -type d -name node_modules -prune -exec rm -rf {} + 2>/dev/null

"$NODE_BIN" "$GENERATOR" "$tree" "$slug" "$sha" \
  || { echo "build-export-index: generator failed" >&2; exit 3; }
