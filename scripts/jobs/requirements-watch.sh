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

# backed_off_pools_for_requirements <req-csv> — the budget pools at their
# high-water mark on any host a `host=` requirement names. A pinned host whose
# pools are all backed off declines claims before it looks at candidates, so its
# jobs dwell here even though the host is alive and capable. Fail-soft: an
# unreadable mapping or sensor just leaves the notice without the extra sentence.
backed_off_pools_for_requirements() {
  local req="$1" item host pool status mapping="$DIR/$GARDEN_SUBSCRIPTION_MAPPING_PATH"
  [ -r "$mapping" ] || return 0
  for item in ${req//,/ }; do
    case "$item" in host=*) host="${item#host=}" ;; *) continue ;; esac
    while read -r pool; do
      status="$(meter_quota_status "$pool" "$DIR" 2>/dev/null || true)"
      [ "$status" = backoff ] && printf '%s\n' "$pool"
    done < <(awk -v h="$host" '$0 !~ /^[[:space:]]*#/ && NF && $2==h { print $1 }' "$mapping" | sort -u)
  done | paste -sd, -
}

for f in "$DIR/$JOBS_TODO"/*.md; do
  [ -e "$f" ] || continue
  base="${f##*/}"; base="${base%.md}"
  req="$(job_requirements "$f" | paste -sd, -)"
  [ -n "$req" ] || continue
  key="$(printf '%s\n' "$base:$req" | sha1sum | cut -c1-16)"
  marker="$STATE/$key.first"
  first="$(cat "$marker" 2>/dev/null || true)"
  [[ "$first" =~ ^[0-9]+$ ]] || { first="$now"; printf '%s\n' "$first" > "$marker"; }
  [ $(( now - first )) -lt "$GARDEN_REQUIREMENTS_DWELL_SECS" ] && continue
  notice="$STATE/$key.noticed"
  [ -e "$notice" ] && continue
  log "job '$base' has unclaimed host requirements '$req' for $(( now - first ))s; alerting maintainer"
  backed_off="$(backed_off_pools_for_requirements "$req" || true)"
  budget_note=""
  [ -z "$backed_off" ] || budget_note=" Budget pacing is the likely cause, not a missing capability: pinned-host pool(s) $backed_off are at their high-water mark, so that host declines claims until the ramp or a reset clears them."
  alert_maintainer "unclaimable-host-requirements-$base" \
    "Host-requirements gate: job '$base' has remained unclaimed for $(( now - first ))s with requires: $req. No live host has met these requirements in the dwell window (or no eligible workers are live), so this work is not silently progressing. Provision the capability/worker or revise the job requirement.$budget_note"
  : > "$notice"
done
