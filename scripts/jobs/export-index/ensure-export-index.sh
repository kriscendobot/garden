#!/bin/bash
# ensure-export-index.sh — return the cached export-name index for a
# (repo, commit), building it on a miss. design: designs/export-index-build-vs-buy.md § 1.
#
#   ensure-export-index.sh <repo-root> <commit> [<owner/repo>]
#       print the path of $GARDEN_STATE/export-index/<owner>-<repo>/<sha>.tsv
#   ensure-export-index.sh --providers <repo-root> <owner/repo>
#       print one index path per provider repo listed for <owner/repo> in the
#       journal file config/export-index-providers
#       (`<owner/repo> <provider-owner/repo>@<ref>` per line), each built at the
#       ref's resolved sha from the provider's bare clone under worktrees/.
#
# The cache is content-addressed on the FULL commit sha: a check always indexes
# the base commit it reviews against, never a floating tip. The build writes a
# temp file and renames it into place, so a concurrent peer never reads a
# partial index. GC keeps the newest $GARDEN_EXPORT_INDEX_KEEP (20) files per
# repo — mandatory, since unpruned per-id state under $GARDEN_STATE has already
# exhausted a host's inodes twice.
#
# Exit: 0 path(s) printed; 2 usage; 3 the index could not be built.

set -uo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
: "${GARDEN_ROOT:=$(cd "$HERE/../../.." && pwd)}"
: "${GARDEN_STATE:=$GARDEN_ROOT/.garden-state}"
: "${GARDEN_EXPORT_INDEX_KEEP:=20}"
: "${GARDEN_JOURNAL_DIR:=$GARDEN_ROOT/journal}"
BUILD="${GARDEN_EXPORT_INDEX_BUILD:-$HERE/build-export-index.sh}"

slug_of() {  # slug_of <repo-root>
  local url
  url="$(git -C "$1" remote get-url origin 2>/dev/null || true)"
  url="$(printf '%s\n' "$url" | sed -E 's#^.*github\.com[:/]##; s#\.git$##')"
  [ -n "$url" ] && { printf '%s\n' "$url"; return; }
  printf 'local/%s\n' "$(basename "$(cd "$1" && pwd)" .git)"
}

gc_dir() {  # keep the newest $GARDEN_EXPORT_INDEX_KEEP indexes in one repo dir
  local dir="$1"
  # shellcheck disable=SC2012  # sha-named files: no whitespace to mangle
  ls -1t "$dir"/*.tsv 2>/dev/null | tail -n +"$((GARDEN_EXPORT_INDEX_KEEP + 1))" \
    | while IFS= read -r old; do rm -f "$old"; done
  find "$dir" -maxdepth 1 -name '.*.tmp.*' -mmin +60 -delete 2>/dev/null
}

ensure() {  # ensure <repo-root> <commit> [<slug>]
  local root="$1" commit="$2" slug="${3:-}" sha dir out tmp
  sha="$(git -C "$root" rev-parse --verify --quiet "$commit^{commit}")" \
    || { echo "ensure-export-index: cannot resolve $commit in $root" >&2; return 3; }
  [ -n "$slug" ] || slug="$(slug_of "$root")"
  dir="$GARDEN_STATE/export-index/${slug//\//-}"
  out="$dir/$sha.tsv"
  if [ -s "$out" ]; then
    touch "$out"  # recency for the GC
    printf '%s\n' "$out"; return 0
  fi
  mkdir -p "$dir" || return 3
  tmp="$dir/.$sha.tmp.$$"
  if ! "$BUILD" "$root" "$sha" "$slug" >"$tmp"; then
    rm -f "$tmp"; return 3
  fi
  mv -f "$tmp" "$out" || { rm -f "$tmp"; return 3; }
  gc_dir "$dir"
  printf '%s\n' "$out"
}

providers() {  # providers <repo-root> <owner/repo>
  local slug="$2" file="$GARDEN_JOURNAL_DIR/config/export-index-providers"
  [ -r "$file" ] || return 0
  local consumer spec prepo ref bare
  while read -r consumer spec _; do
    case "$consumer" in ''|'#'*) continue ;; esac
    [ "$consumer" = "$slug" ] || continue
    prepo="${spec%@*}"; ref="${spec#*@}"; [ "$ref" = "$spec" ] && ref=HEAD
    bare="$GARDEN_ROOT/worktrees/${prepo//\//-}.git"
    [ -d "$bare" ] || { echo "ensure-export-index: no bare clone for provider $prepo" >&2; continue; }
    ensure "$bare" "$ref" "$prepo" || echo "ensure-export-index: provider $prepo@$ref unavailable" >&2
  done < "$file"
}

case "${1:-}" in
  --providers)
    [ $# -ge 3 ] || { echo "ensure-export-index: usage: --providers <repo-root> <owner/repo>" >&2; exit 2; }
    providers "$2" "$3"; exit 0 ;;
  ''|-h|--help)
    echo "usage: ensure-export-index.sh <repo-root> <commit> [<owner/repo>] | --providers <repo-root> <owner/repo>" >&2
    exit 2 ;;
  *)
    [ $# -ge 2 ] || { echo "ensure-export-index: usage: <repo-root> <commit> [<owner/repo>]" >&2; exit 2; }
    ensure "$1" "$2" "${3:-}"; exit $? ;;
esac
