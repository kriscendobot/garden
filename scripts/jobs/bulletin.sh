#!/bin/bash
# bulletin.sh — regenerate the journal bulletin, reliably.
#
# Usage: bulletin.sh
#
# A dedicated service (and an on-demand command) that recomputes journal/
# bulletin.md from current state: board counts, the watch set, per-host worker
# counts, and the most recent progress entries. The summary is computed
# DETERMINISTICALLY (no LLM dependency) so the bulletin is produced reliably on
# every tick; an optional GARDEN_BULLETIN_HANDLER may enrich it.
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

  recent=""
  while IFS= read -r f; do
    [ -n "$f" ] || continue
    first=$(awk 'c>=2 && NF{print; exit} /^---$/{c++}' "$f")
    recent+="- ${f##*/}: ${first}"$'\n'
  done < <(find "$DIR/entries" -type f -name '*.md' 2>/dev/null | sort | tail -15)
  [ -n "$recent" ] || recent="(no progress entries yet)"$'\n'

  content="$(cat <<EOF
# Garden bulletin

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
