#!/bin/bash
# plan/render-endo-redirect.sh — generate the NON-AUTHORITATIVE redirect copy of
# the endo design index for the `endojs/endo-but-for-bots:llm` `designs/README.md`.
#
# Usage: plan/render-endo-redirect.sh [<plan-dir>]
#   Prints the redirect markdown to stdout. A caller (the weekly recalibration job)
#   writes it to the fork's designs/README.md and pushes HEAD:llm.
#
# Per designs/plan-in-journal.md (garden#4), Phase 1 + Phase 4: the single source of
# truth for the roadmap is the garden journal plan (journal2 under plan/). The endo
# fork's designs/README.md is kept INDEFINITELY only as a COURTESY POINTER for human
# readers still browsing the fork — it is generated output, never hand-edited, and
# never a second source of truth. This is distinct from render.sh, which generates
# the authoritative aggregate view (journal/plan/README.md): this script generates a
# redirect for a *different repository* and is therefore filtered to the records that
# target endo-but-for-bots, and styled to match what an endo reader expects (the
# Design / Created / Updated / Status table, Complete bolded).
#
# Output is deterministic (no clock, no network) so the weekly regeneration is a
# clean change-gate: it only pushes when a record actually changed.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib.sh
source "$HERE/lib.sh"

PLAN_DIR="${1:-${GARDEN_ROOT:-$(cd "$HERE/../../.." && pwd)}/journal/plan}"
[ -d "$PLAN_DIR" ] || { echo "render-endo-redirect: no plan dir at $PLAN_DIR" >&2; exit 0; }

# This redirect covers exactly the designs that target the endo fork.
REPO_SLUG="endo-but-for-bots"

# Pull the endo-but-for-bots records into a TSV stream sorted by slug for a stable,
# multi-host-identical order: slug, status, created, updated, pr.
records_tsv() {
  local f slug repo status created updated pr
  while IFS= read -r f; do
    [ -n "$f" ] || continue
    repo="$(fm_field "$f" repository)"
    [ "$repo" = "$REPO_SLUG" ] || continue
    slug="$(fm_field "$f" slug)"; [ -n "$slug" ] || slug="$(basename "$f" .md)"
    status="$(fm_field "$f" status)"
    created="$(fm_field "$f" created)"
    updated="$(fm_field "$f" updated)"
    pr="$(fm_field "$f" pr)"
    printf '%s\t%s\t%s\t%s\t%s\n' \
      "$slug" "${status:-?}" "$created" "$updated" "$pr"
  done < <(list_records "$PLAN_DIR")
}

TSV="$(records_tsv | LC_ALL=C sort -t$'\t' -k1,1)"
total="$(printf '%s' "$TSV" | grep -c . || true)"

# Render a status cell the way the endo README does: bold the done-ish statuses, and
# append the implementing PR (as `#N`) when the record carries one.
status_cell() {
  local status="$1" pr="$2"
  local cell="$status"
  if is_complete_status "$status"; then cell="**${status}**"; fi
  if [ -n "$pr" ]; then
    # normalise <repo-slug>#N / owner/name#N / URL to a bare #N where possible
    local num="${pr##*#}"
    case "$pr" in
      *\#*) cell="${cell} (PR #${num})" ;;
      *)    cell="${cell} (PR ${pr})" ;;
    esac
  fi
  printf '%s' "$cell"
}

cat <<EOF
# Endo Design Documents

> **Generated file — do not edit.** The single source of truth for the roadmap is
> the **garden journal plan** (the \`journal2\` branch, under \`plan/\`), where each
> design is one record and this table is an aggregation of those records. This file
> is a **non-authoritative courtesy redirect** for human readers browsing the fork;
> it is regenerated from the journal records and any hand-edit here will be
> overwritten. To change a design's status, dates, or narrative, edit its journal
> record — not this file.
>
> - Source of truth: garden journal \`plan/designs/${REPO_SLUG}/<slug>.md\`
> - Generated aggregate roadmap: garden journal \`plan/README.md\`
> - Generator: \`scripts/jobs/plan/render-endo-redirect.sh\` (kriskowal/garden)
> - Architecture: \`designs/plan-in-journal.md\` (garden#4)

This index lists the **${total}** design(s) targeting this repository. The
per-design \`<slug>.md\` files in this directory are mirrored from the journal record
bodies; follow a link to read a design's narrative.

| Design | Created | Updated | Status |
|---|---|---|---|
EOF

printf '%s\n' "$TSV" | while IFS=$'\t' read -r slug status created updated pr; do
  [ -n "$slug" ] || continue
  printf '| [%s](%s.md) | %s | %s | %s |\n' \
    "$slug" "$slug" "${created:-—}" "${updated:-—}" "$(status_cell "$status" "$pr")"
done

# NOTE: deterministic output — no clock, no network — so the weekly regeneration only
# pushes to the fork when a record actually changed.
