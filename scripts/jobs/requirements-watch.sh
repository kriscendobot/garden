#!/bin/bash
# requirements-watch.sh — surface requirement-gated jobs that dwell in todo.
#
# This watcher does not publish host capability inventory: the journal is public.
# It observes the public consequence instead — a requirements-bearing job that no
# live worker has claimed for the dwell window — and sends one maintainer notice.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
export GARDEN_TAG="requirements-watch"
: "${GARDEN_REQUIREMENTS_DWELL_SECS:=900}"
DIR="${GARDEN_REQUIREMENTS_WATCH_CLONE:-$GARDEN_STATE/requirements-watch/journal}"
STATE="$GARDEN_STATE/requirements-watch"
mkdir -p "$STATE"
ensure_clone "$DIR"
sync_clone "$DIR"
now="$(date -u +%s)"
for f in "$DIR/$JOBS_TODO"/*.md; do
  [ -e "$f" ] || continue
  base="${f##*/}"; base="${base%.md}"
  req="$(plan_field "$f" requires)"
  [ -n "$req" ] || continue
  key="$(printf '%s\n' "$base:$req" | sha1sum | cut -c1-16)"
  marker="$STATE/$key.first"
  first="$(cat "$marker" 2>/dev/null || true)"
  [[ "$first" =~ ^[0-9]+$ ]] || { first="$now"; printf '%s\n' "$first" > "$marker"; }
  [ $(( now - first )) -lt "$GARDEN_REQUIREMENTS_DWELL_SECS" ] && continue
  notice="$STATE/$key.noticed"
  [ -e "$notice" ] && continue
  log "job '$base' has unclaimed host requirements '$req' for $(( now - first ))s; alerting maintainer"
  alert_maintainer "unclaimable-host-requirements-$base" \
    "Host-requirements gate: job '$base' has remained unclaimed for $(( now - first ))s with requires: $req. No live host has met these requirements in the dwell window (or no eligible workers are live), so this work is not silently progressing. Provision the capability/worker or revise the job requirement."
  : > "$notice"
done
