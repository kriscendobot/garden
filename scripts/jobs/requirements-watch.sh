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

# The dwell measures one unbroken stay in todo. A key this pass does not mark as
# dwelling loses its markers below, so a job that was claimed and later requeued
# starts a fresh dwell: oros-health-checkup-20261103-053509 was reported "unclaimed
# for 1801s" 23 minutes after a worker claimed it at 05:44Z and 4 minutes after the
# reaper returned it for a retry. A job waiting out the reaper's plain-retry back-off
# (claim-job.sh skips it on purpose) is not dwelling either.
declare -A dwelling=()
for f in "$DIR/$JOBS_TODO"/*.md; do
  [ -e "$f" ] || continue
  base="${f##*/}"; base="${base%.md}"
  req="$(job_requirements "$f" | paste -sd, -)"
  [ -n "$req" ] || continue
  retry_not_before="$(plain_retry_not_before "$f" 2>/dev/null || true)"
  if [ -n "$retry_not_before" ]; then
    retry_epoch="$(date -u -d "$retry_not_before" +%s 2>/dev/null || true)"
    [[ "$retry_epoch" =~ ^[0-9]+$ ]] && [ "$now" -lt "$retry_epoch" ] && continue
  fi
  key="$(printf '%s\n' "$base:$req" | sha1sum | cut -c1-16)"
  dwelling[$key]=1
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

if [ -d "$DIR/$JOBS_TODO" ]; then
  for marker in "$STATE"/*.first "$STATE"/*.noticed; do
    [ -e "$marker" ] || continue
    key="${marker##*/}"; key="${key%.*}"
    [ -n "${dwelling[$key]:-}" ] || rm -f -- "$marker"
  done
fi
