#!/bin/bash
# bulletin.sh — regenerate the journal bulletin, reliably.
#
# Usage: bulletin.sh
#
# The garden's maintainer dashboard, recomputed from current state on a cadence
# (garden-bulletin.timer, every 5m). Like the v1 bulletin board, it leads with
# "what needs a human" — the pending messages aggregated from the maintainer
# inbox (inbox/maintainer/unread/, the same source maintainer-watch.sh reads) —
# then summarizes ongoing autonomous work: board counts, the watch set, per-host
# worker counts, and the most recent progress entries.
#
# The summary is computed DETERMINISTICALLY (no LLM dependency) so the bulletin
# is produced reliably on every tick; an optional GARDEN_BULLETIN_HANDLER may
# enrich it (e.g. a "Pending kriskowal reviews" section that needs GitHub state),
# but the inbox aggregation and the rest of the board work without it.
#
# Idempotent: if the recomputed bulletin is unchanged (ignoring its timestamp)
# it does not commit, so a scheduled cadence AND redundant on-demand triggers
# (e.g. a subagent that just noticed progress in the entries log) are both cheap.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
GARDEN_TAG="bulletin"

DIR="${GARDEN_BULLETIN_CLONE:-$GARDEN_STATE/bulletin/journal}"
ensure_clone "$DIR"

for attempt in $(seq 1 50); do
  sync_clone "$DIR"
  todo=$(list_jobs "$DIR" jobs/todo | grep -c . || true)
  doin=$(list_jobs "$DIR" jobs/doin | grep -c . || true)
  tada=$(list_jobs "$DIR" jobs/tada | grep -c . || true)
  watch=$(list_jobs "$DIR" repos | paste -sd' ' - 2>/dev/null); [ -n "$watch" ] || watch="(none)"

  hosts_block=""
  for h in $(list_jobs "$DIR" hosts); do
    g=$(sed -n 's/^gardeners:[[:space:]]*//p' "$DIR/hosts/$h" | head -1)
    hosts_block+="- $h: ${g:-?} gardeners"$'\n'
  done
  [ -n "$hosts_block" ] || hosts_block="(no hosts configured)"$'\n'

  # Aggregate the maintainer inbox: every unread message addressed to the user,
  # shown with enough to act on it (id, originating doer via reply_to, sender,
  # and a one-line summary = first non-empty body line after the frontmatter).
  maint=""
  for m in $(list_jobs "$DIR" inbox/maintainer/unread); do
    mf="$DIR/inbox/maintainer/unread/$m"
    [ -f "$mf" ] || continue
    rt=$(sed -n 's/^reply_to:[[:space:]]*//p' "$mf" | head -1)
    frm=$(sed -n 's/^from:[[:space:]]*//p' "$mf" | head -1)
    sum=$(awk 'b && NF{print; exit} /^---$/{b=1}' "$mf")
    maint+="- \`${m%.md}\` — from ${frm:-?}, reply_to \`${rt:-?}\`: ${sum:-(no summary)}"$'\n'
  done
  [ -n "$maint" ] || maint="(no pending maintainer messages)"$'\n'

  recent=""
  while IFS= read -r f; do
    [ -n "$f" ] || continue
    first=$(awk 'c>=2 && NF{print; exit} /^---$/{c++}' "$f")
    recent+="- ${f##*/}: ${first}"$'\n'
  done < <(find "$DIR/entries" -type f -name '*.md' 2>/dev/null | sort | tail -15)
  [ -n "$recent" ] || recent="(no progress entries yet)"$'\n'

  content="$(cat <<EOF
# Garden bulletin

The maintainer dashboard: what needs a human first, then the state of ongoing
autonomous work. Regenerated deterministically every tick by
scripts/jobs/bulletin.sh.

## Messages to the maintainer

${maint}
## Board
- todo: $todo
- doin: $doin
- tada: $tada

## Watch set
$watch

## Hosts
${hosts_block}
## Recent progress
${recent}
EOF
)"

  old="$(grep -v '^generated:' "$DIR/bulletin.md" 2>/dev/null || true)"
  if [ "$content" = "$old" ]; then
    log "bulletin unchanged; no commit"; exit 0
  fi
  { printf '%s\n' "$content"; printf 'generated: %s\n' "$(date -u +%FT%TZ)"; } > "$DIR/bulletin.md"
  git -C "$DIR" add bulletin.md
  if commit_and_push "$DIR" "bulletin regenerated"; then log "bulletin regenerated"; exit 0; fi
  rc=$?; [ "$rc" -eq 2 ] && exit 0
  backoff
done
die "could not regenerate bulletin after retries"
