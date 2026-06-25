#!/bin/bash
# plan/import-endo.sh — one-time import of the endo v1 plan into journal/plan/.
#
# Usage: plan/import-endo.sh <plan-dir> [<endo-bare-clone>] [<ref>]
#   <plan-dir>         target journal/plan tree (records are written under it)
#   <endo-bare-clone>  default worktrees/endojs-endo-but-for-bots.git under GARDEN_ROOT
#   <ref>              default origin/llm
#
# Reads the hand-maintained roadmap at designs/README.md on the endo fork's `llm`
# branch plus each per-design designs/<slug>.md narrative, and writes one
# per-design record under <plan-dir>/designs/endo-but-for-bots/<slug>.md with the
# metadata in frontmatter and the narrative in the body (per designs/plan-in-journal.md).
#
# Faithful and mechanical: it carries slug, created, updated, status (+ any
# embedded PR), size, and milestone from the two structured tables, and the full
# narrative from the design file. depends_on is left empty (the prose graph is not
# mechanically extractable; the dep graph is enriched later). Re-runnable: it
# overwrites the endo-but-for-bots record set from the current `llm` state.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$HERE/lib.sh"

PLAN_DIR="${1:?usage: import-endo.sh <plan-dir> [<endo-bare-clone>] [<ref>]}"
ROOT="${GARDEN_ROOT:-$(cd "$HERE/../../.." && pwd)}"
SRC="${2:-$ROOT/worktrees/endojs-endo-but-for-bots.git}"
REF="${3:-origin/llm}"
REPO_SLUG="endo-but-for-bots"
OUT="$PLAN_DIR/designs/$REPO_SLUG"
mkdir -p "$OUT"

command -v git >/dev/null || { echo "git required" >&2; exit 1; }
README="$(git -C "$SRC" show "$REF:designs/README.md")" || { echo "cannot read $REF:designs/README.md from $SRC" >&2; exit 1; }

tmp="$(mktemp -d)"; trap 'rm -rf "$tmp"' EXIT

# --- table 1: per-design (slug, created, updated, status_raw) ----------------
printf '%s\n' "$README" | awk -F'|' '
  /^\| Design \| Created \| Updated \| Status \|/ { intab=1; next }
  intab && /^\|[[:space:]]*---/ { next }
  intab && !/^\|/ { intab=0 }
  intab {
    d=$2; c=$3; u=$4; s=$5
    # slug from [slug](slug.md) in column 2
    if (match(d, /\[[^]]+\]/)) { slug=substr(d, RSTART+1, RLENGTH-2) } else { slug=d }
    gsub(/^[[:space:]]+|[[:space:]]+$/, "", slug)
    gsub(/^[[:space:]]+|[[:space:]]+$/, "", c)
    gsub(/^[[:space:]]+|[[:space:]]+$/, "", u)
    gsub(/^[[:space:]]+|[[:space:]]+$/, "", s)
    gsub(/`/, "", slug)
    if (slug=="" || slug ~ /[[:space:]]/) next
    print slug "\t" c "\t" u "\t" s
  }
' > "$tmp/designs.tsv"

# --- table 2: per-design estimates (slug, size, milestone) -------------------
printf '%s\n' "$README" | awk -F'|' '
  /^\| Design \| Size \| Estimate \| Milestone \| Notes \|/ { intab=1; next }
  intab && /^\|[[:space:]]*---/ { next }
  intab && !/^\|/ { intab=0 }
  intab {
    d=$2; size=$3; ms=$5
    gsub(/~~/, "", d); gsub(/\(design\)/, "", d)
    gsub(/^[[:space:]]+|[[:space:]]+$/, "", d)
    gsub(/`/, "", d)
    gsub(/^[[:space:]]+|[[:space:]]+$/, "", size)
    gsub(/^[[:space:]]+|[[:space:]]+$/, "", ms)
    if (d=="" || d ~ /[[:space:]]/) next
    print d "\t" size "\t" ms
  }
' > "$tmp/estimates.tsv"

# normalize a size token: ranges -> larger bin; em-dash/empty/other -> empty.
norm_size() {
  case "$1" in
    S)  echo S;;
    M)  echo M;;
    L)  echo L;;
    XL) echo XL;;
    S-M) echo M;;
    M-L) echo L;;
    L-XL) echo XL;;
    *) echo "";;
  esac
}

# normalize a status: strip bold, extract any (PR #N), drop trailing qualifiers
# (parentheticals, "Superseded by ...", "(Phase N)"), and map to the canonical
# enum by leading-token match. "Implemented" -> "Complete". echoes "STATUS\tPR".
norm_status() {
  local raw="$1" pr="" st
  raw="${raw//\*/}"
  if [[ "$raw" =~ \(PR\ *#([0-9]+)\) ]]; then pr="$REPO_SLUG#${BASH_REMATCH[1]}"; fi
  # drop parentheticals and markdown links, collapse whitespace
  st="$(printf '%s' "$raw" | sed -E 's/\([^)]*\)//g; s/\[[^]]*\]\([^)]*\)//g; s/[[:space:]]+/ /g; s/^ +| +$//g')"
  st="${st/Implemented/Complete}"
  # match the canonical enum by leading token (longest first)
  local t
  for t in "Not Started" "In Progress" Superseded Deprecated Reference Complete Proposed Active Draft; do
    case "$st" in "$t"*) st="$t"; break;; esac
  done
  printf '%s\t%s\n' "$st" "$pr"
}

count=0
while IFS=$'\t' read -r slug created updated status_raw; do
  [ -n "$slug" ] || continue
  # join size+milestone from estimates table
  est="$(awk -F'\t' -v s="$slug" '$1==s{print $2"\t"$3; exit}' "$tmp/estimates.tsv")"
  size_raw="${est%%$'\t'*}"; ms_raw="${est#*$'\t'}"; [ "$est" = "$size_raw" ] && ms_raw=""
  size="$(norm_size "$size_raw")"
  ms=""; case "$ms_raw" in ''|*[!0-9]*) ms="";; *) ms="M$ms_raw";; esac
  IFS=$'\t' read -r status pr < <(norm_status "$status_raw")
  [ -n "$status" ] || status="Proposed"

  # narrative body from the design file (best-effort; placeholder if absent)
  body="$(git -C "$SRC" show "$REF:designs/$slug.md" 2>/dev/null || true)"
  [ -n "$body" ] || body="_(narrative not found in $REF:designs/$slug.md at import time)_"

  {
    printf -- '---\n'
    printf 'slug: %s\n' "$slug"
    printf 'repository: %s\n' "$REPO_SLUG"
    printf 'status: %s\n' "$status"
    [ -n "$size" ] && printf 'size: %s\n' "$size"
    [ -n "$ms" ]   && printf 'milestone: %s\n' "$ms"
    printf 'depends_on: []\n'
    [ -n "$pr" ] && printf 'pr: %s\n' "$pr"
    printf 'created: %s\n' "${created:-unknown}"
    printf 'updated: %s\n' "${updated:-unknown}"
    printf 'source: imported from %s designs/README.md\n' "$REF"
    printf -- '---\n\n'
    printf '%s\n' "$body"
  } > "$OUT/$slug.md"
  count=$((count+1))
done < "$tmp/designs.tsv"

echo "imported $count endo-but-for-bots design record(s) into $OUT" >&2
