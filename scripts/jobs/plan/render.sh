#!/bin/bash
# plan/render.sh — aggregate the per-design plan records into the generated
# roadmap view (journal/plan/README.md).
#
# Usage: plan/render.sh [<plan-dir>]
#   Prints the generated README to stdout. The bulletin loop captures it and
#   commits it change-gated; the weekly job and a manual run can redirect it.
#
# This is the reconciler's *view-generation* step (per designs/plan-in-journal.md):
# the README is an AGGREGATION of the records — never a second source of truth and
# never hand-edited. The output is deterministic (no clock, no network) so the
# bulletin's idempotent change-compare can tell real plan motion from noise. The
# only volatile line is a clearly-marked freshness stamp the change-compare drops.
#
# Sections: a per-design summary table, a per-milestone rollup (size totals +
# completion %), and a Mermaid dependency graph over depends_on. Computation is
# over the UNION of all records across all repositories, so a milestone or project
# spanning repositories rolls up as one.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib.sh
source "$HERE/lib.sh"

PLAN_DIR="${1:-${GARDEN_ROOT:-$(cd "$HERE/../../.." && pwd)}/journal/plan}"
[ -d "$PLAN_DIR" ] || { echo "plan-render: no plan dir at $PLAN_DIR" >&2; exit 0; }

# Pull every record into a single TSV stream: slug, repo, status, size, milestone,
# pr, target, deps(comma). One awk-free pass using the lib helpers.
records_tsv() {
  local f slug repo status size ms pr target deps
  while IFS= read -r f; do
    [ -n "$f" ] || continue
    slug="$(fm_field "$f" slug)"; [ -n "$slug" ] || slug="$(basename "$f" .md)"
    repo="$(fm_field "$f" repository)"
    status="$(fm_field "$f" status)"
    size="$(fm_field "$f" size)"
    ms="$(fm_field "$f" milestone)"
    pr="$(fm_field "$f" pr)"
    target="$(fm_field "$f" target)"
    deps="$(fm_list "$f" depends_on | paste -sd, - 2>/dev/null)"
    printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
      "$slug" "$repo" "${status:-?}" "$size" "$ms" "$pr" "$target" "$deps"
  done < <(list_records "$PLAN_DIR")
}

TSV="$(records_tsv | LC_ALL=C sort -t$'\t' -k5,5 -k2,2 -k1,1)"
total="$(printf '%s' "$TSV" | grep -c . || true)"

# Header.
cat <<EOF
# Garden plan (roadmap)

_Generated from journal/plan/designs/ by scripts/jobs/plan/render.sh — do NOT
hand-edit. Edit a design by editing its record; this view recomputes. The
per-design files are the single source of truth (design: garden#4,
designs/plan-in-journal.md)._

This roadmap aggregates **${total}** design record(s) across all plan repositories.
Milestone totals, completion, and the dependency graph are computed over the union
of records, so a milestone spanning repositories rolls up as one.

## Repositories

EOF
if [ -f "$PLAN_DIR/repositories.md" ]; then
  sed -nE 's|^[[:space:]]*([a-z0-9-]+)[[:space:]]*:[[:space:]]*(\S+).*$|- `\1` → \2|p' "$PLAN_DIR/repositories.md"
else
  echo "(repositories.md missing)"
fi

# Per-milestone rollup.
printf '\n## Summary by milestone\n\n'
printf '| Milestone | Designs | Complete | %% | Est. days (remaining) |\n'
printf '|---|---|---|---|---|\n'
# Milestones in natural M-order, plus an "(unfiled)" bucket.
ms_list="$( { printf '%s\n' "$TSV" | cut -f5; ls "$PLAN_DIR/milestones" 2>/dev/null | sed 's/\.md$//'; } \
  | grep -v '^$' | LC_ALL=C sort -u | sort -t M -k2,2n 2>/dev/null || true)"
{
  printf '%s\n' "$ms_list"
  printf '%s\n' "$TSV" | cut -f5 | grep -q '^$' && echo "__unfiled__"
} | grep -v '^$' | while IFS= read -r ms; do
  key="$ms"; [ "$ms" = "__unfiled__" ] && key=""
  rows="$(printf '%s\n' "$TSV" | awk -F'\t' -v m="$key" '$5==m')"
  n="$(printf '%s' "$rows" | grep -c . || true)"
  [ "$n" -gt 0 ] || continue
  done_n=0; rem_days=0
  while IFS=$'\t' read -r slug repo status size mss pr target deps; do
    [ -n "$slug" ] || continue
    if is_complete_status "$status"; then done_n=$((done_n+1)); else
      d="$(size_days "$PLAN_DIR" "$size")"; rem_days="$(awk -v a="$rem_days" -v b="$d" 'BEGIN{print a+b}')"
    fi
  done < <(printf '%s\n' "$rows")
  pct=0; [ "$n" -gt 0 ] && pct=$(( done_n * 100 / n ))
  label="$ms"; [ "$ms" = "__unfiled__" ] && label="(unfiled)"
  printf '| %s | %s | %s | %s%% | %s |\n' "$label" "$n" "$done_n" "$pct" "$rem_days"
done

# Per-design table.
printf '\n## Designs\n\n'
printf '| Design | Repository | Milestone | Status | Size | PR |\n'
printf '|---|---|---|---|---|---|\n'
printf '%s\n' "$TSV" | while IFS=$'\t' read -r slug repo status size ms pr target deps; do
  [ -n "$slug" ] || continue
  printf '| %s | %s | %s | %s | %s | %s |\n' \
    "$slug" "${repo:-?}" "${ms:-—}" "$status" "${size:-—}" "${pr:-—}"
done

# Dependency graph (Mermaid). Edges resolve slugs across all repositories; an edge
# to an unknown slug is dropped (validate.sh surfaces it as a warning separately).
printf '\n## Dependency graph\n\n'
have_edges="$(printf '%s\n' "$TSV" | awk -F'\t' '$8!=""{print}' | grep -c . || true)"
if [ "$have_edges" -gt 0 ]; then
  printf '```mermaid\nflowchart LR\n'
  # known-slug set for edge filtering
  known="$(printf '%s\n' "$TSV" | cut -f1)"
  printf '%s\n' "$TSV" | while IFS=$'\t' read -r slug repo status size ms pr target deps; do
    [ -n "$slug" ] || continue
    [ -n "$deps" ] || continue
    printf '%s\n' "$deps" | tr ',' '\n' | while IFS= read -r dep; do
      dep="${dep// /}"; [ -n "$dep" ] || continue
      if printf '%s\n' "$known" | grep -qxF "$dep"; then
        printf '  %s --> %s\n' "$(printf '%s' "$dep" | tr -c 'A-Za-z0-9_' '_')" "$(printf '%s' "$slug" | tr -c 'A-Za-z0-9_' '_')"
      fi
    done
  done
  printf '```\n'
else
  printf '_No dependency edges recorded yet._\n'
fi

# NOTE: this output is intentionally deterministic — no clock, no network — so the
# bulletin loop and every host render byte-identical content and only commit when a
# record actually changed (git-diff is the idempotent change gate; multi-host safe).
