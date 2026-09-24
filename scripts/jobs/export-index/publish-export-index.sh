#!/bin/bash
# publish-export-index.sh — the leader-only `garden-export-index` tick. No LLM.
# design: designs/export-index-build-vs-buy.md § 2.
#
# For each roadmap branch in the journal file config/export-index-roadmaps
# (`<owner/repo>@<branch>` per line; default `endojs/endo-but-for-bots@llm` when
# the file is absent), build the export-name index at the branch tip from the
# repo's bare clone (worktrees/<owner>-<repo>.git) through the per-commit cache,
# and land it as library/exports/<owner>-<repo>.tsv through land-journal-edit.sh,
# only when the rows changed (the header's commit= alone never triggers a land).
# Also keeps library/exports/README.md in step with the tracked template
# skills/build-vs-buy/exports-README.md.
#
# The published snapshot is for grep at authoring time. No check reads it: the
# pre-push probe and the procurer seat index the exact base commit they review.
#
# Exit: 0 done (per-repo failures are logged and skipped); 75 a transient journal
# outage (the next tick retries).

set -uo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
: "${GARDEN_ROOT:=$(cd "$HERE/../../.." && pwd)}"
: "${GARDEN_JOURNAL_DIR:=$GARDEN_ROOT/journal}"
ENSURE="${GARDEN_EXPORT_INDEX_ENSURE:-$HERE/ensure-export-index.sh}"
LAND="${GARDEN_LAND_JOURNAL_EDIT:-$HERE/../land-journal-edit.sh}"
README_TEMPLATE="$HERE/../../../skills/build-vs-buy/exports-README.md"
ROADMAPS="$GARDEN_JOURNAL_DIR/config/export-index-roadmaps"

log() { printf 'publish-export-index: %s\n' "$*" >&2; }
rows_of() { grep -v '^# repo=' "$1" 2>/dev/null; }

land() {  # land <journal-path> <body-file>
  "$LAND" "$1" "$2"; local rc=$?
  [ "$rc" -eq 75 ] && exit 75
  [ "$rc" -eq 0 ] || log "could not land $1 (rc=$rc)"
}

if [ -r "$ROADMAPS" ]; then
  roadmaps="$(grep -vE '^[[:space:]]*(#|$)' "$ROADMAPS")"
else
  roadmaps="endojs/endo-but-for-bots@llm"
fi

while IFS= read -r spec; do
  [ -n "$spec" ] || continue
  repo="${spec%@*}"; branch="${spec#*@}"; slug="${repo//\//-}"
  bare="$GARDEN_ROOT/worktrees/$slug.git"
  [ -d "$bare" ] || { log "no bare clone for $repo; skipped"; continue; }
  index="$("$ENSURE" "$bare" "$branch" "$repo")" || { log "cannot index $repo@$branch; skipped"; continue; }
  published="$GARDEN_JOURNAL_DIR/library/exports/$slug.tsv"
  if [ -r "$published" ] && [ "$(rows_of "$published")" = "$(rows_of "$index")" ]; then
    log "$repo@$branch rows unchanged"; continue
  fi
  land "library/exports/$slug.tsv" "$index"
done <<<"$roadmaps"

if [ -r "$README_TEMPLATE" ] && ! cmp -s "$README_TEMPLATE" "$GARDEN_JOURNAL_DIR/library/exports/README.md"; then
  land library/exports/README.md "$README_TEMPLATE"
fi
exit 0
