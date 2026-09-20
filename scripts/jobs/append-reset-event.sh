#!/bin/bash
# append-reset-event.sh — the durable ingestion point for a quota RESET event,
# appended to the reset-events log (journal budget/reset-events/<subscription>.jsonl; see
# that dir's README for the row schema and designs/reset-time-detection.md for the
# detector that feeds it). Sibling of append-quota-checkpoint.sh: that one records a
# usage LEVEL at a point in time, this one records a reset EVENT (the window rolling
# over to zero).
#
# WHY this exists: before this, a maintainer or a session hand-wrote a JSONL row into
# the reset-events log every time an event was pinned. detect-quota-resets.sh now
# proposes events deterministically; this helper is the append/CAS path it (or a
# human) uses so a detection becomes one command, not a hand-edit — the same relation
# append-quota-checkpoint.sh has to the checkpoint log.
#
# It RECORDS an event; it does NOT actuate. Nothing here touches config/budget-pools,
# a worker count, or a quota-backoff hold. Acting on a detected reset (surfacing a
# notice, clearing a stale hold) is a separate deliberate step — see
# designs/reset-time-detection.md § how a detected reset feeds config/budget-pools.
#
#   append-reset-event.sh <subscription> --type TYPE --precision PREC [options]
#
# Required:
#   <subscription>            canonical subscription id
#   --type TYPE               scheduled-weekly | anomalous-midweek |
#                             expected-next-scheduled | unknown
#   --precision PREC          exact | bracketed | extrapolated | scheduled
#
# One of --at / (--bracket-lower AND --bracket-upper) is required unless
# --precision scheduled (which needs --at, the forward-looking expected time):
#   --at ISO8601             best estimate of the reset instant
#   --bracket-lower ISO      latest evidence BEFORE the reset
#   --bracket-upper ISO      earliest evidence AFTER the reset
#
# Options:
#   --evidence TEXT          free text citing the concrete artifact(s) grounding this
#   --note TEXT              free text
#   --grade GRADE            confirmed | likely | suspected | refuted (detector verdict;
#                            omitted for a hand-entered row)
#   --recorded-at ISO        override the recorded_at stamp (default: now)
#   --dedup-key KEY          skip the append if a row with this exact detector_key
#                            already exists for the host (idempotent re-detection)
#   --dry-run                print the row that WOULD be appended; do not write/push
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
export GARDEN_TAG=append-reset-event

usage() { echo "usage: append-reset-event.sh <subscription> --type T --precision P [--at ISO | --bracket-lower ISO --bracket-upper ISO] [options]" >&2; exit 2; }

subscription="${1:-}"; [ -n "$subscription" ] || usage
case "$subscription" in -*|*/*|'') usage;; esac
shift

type=""; precision=""; at=""; blo=""; bup=""; evidence=""; note=""; grade=""
cadence="observed"; schedule_weekday=""; schedule_time=""; timezone="UTC"
recorded_at=""; dedup_key=""; dry_run=false
while [ "$#" -gt 0 ]; do
  case "$1" in
    --type) type="${2:?}"; shift 2;;
    --precision) precision="${2:?}"; shift 2;;
    --at) at="${2:?}"; shift 2;;
    --bracket-lower) blo="${2:?}"; shift 2;;
    --bracket-upper) bup="${2:?}"; shift 2;;
    --evidence) evidence="${2:?}"; shift 2;;
    --note) note="${2:?}"; shift 2;;
    --grade) grade="${2:?}"; shift 2;;
    --recorded-at) recorded_at="${2:?}"; shift 2;;
    --dedup-key) dedup_key="${2:?}"; shift 2;;
    --cadence) cadence="${2:?}"; shift 2;;
    --schedule-weekday) schedule_weekday="${2:?}"; shift 2;;
    --schedule-time) schedule_time="${2:?}"; shift 2;;
    --timezone) timezone="${2:?}"; shift 2;;
    --dry-run) dry_run=true; shift;;
    *) echo "unknown option: $1" >&2; usage;;
  esac
done

case "$type" in scheduled-weekly|anomalous-midweek|expected-next-scheduled|unknown|declared-schedule|manual-reset) ;; *) echo "invalid --type" >&2; exit 2;; esac
case "$cadence" in calendar|manual|observed) ;; *) echo "--cadence must be calendar|manual|observed" >&2; exit 2;; esac
[ -z "$schedule_weekday" ] || [[ "$schedule_weekday" =~ ^[1-7]$ ]] || { echo "--schedule-weekday must be 1..7" >&2; exit 2; }
[ -z "$schedule_time" ] || [[ "$schedule_time" =~ ^[0-2][0-9]:[0-5][0-9](:[0-5][0-9])?$ ]] || { echo "invalid --schedule-time" >&2; exit 2; }
case "$precision" in
  exact|bracketed|extrapolated|scheduled|day) ;;
  *) echo "--precision must be exact|bracketed|extrapolated|scheduled|day" >&2; exit 2;;
esac
if [ -n "$grade" ]; then
  case "$grade" in confirmed|likely|suspected|refuted) ;; *) echo "--grade must be confirmed|likely|suspected|refuted" >&2; exit 2;; esac
fi
# Sanity: need either a point estimate or a bracket. A scheduled row is a point.
if [ "$type" != declared-schedule ] && [ -z "$at" ] && { [ -z "$blo" ] || [ -z "$bup" ]; }; then
  echo "need --at, or both --bracket-lower and --bracket-upper" >&2; exit 2
fi
command -v jq >/dev/null 2>&1 || { echo "jq unavailable" >&2; exit 1; }

[ -n "$recorded_at" ] || recorded_at="$(date -u +%FT%TZ)"

DIR="${GARDEN_PRODUCER_CLONE:-$GARDEN_STATE/producer/journal}"
ensure_clone "$DIR"

build_row() {
  jq -cn \
    --arg subscription "$subscription" --arg type "$type" --arg at "$at" --arg precision "$precision" \
    --arg blo "$blo" --arg bup "$bup" --arg evidence "$evidence" \
    --arg recorded_at "$recorded_at" --arg note "$note" --arg grade "$grade" \
    --arg dedup_key "$dedup_key" --arg cadence "$cadence" \
    --arg weekday "$schedule_weekday" --arg schedule_time "$schedule_time" --arg timezone "$timezone" '
    {subscription_id:$subscription, event_type:$type, cadence:$cadence,
     reset_at:(if $at != "" then $at else null end),
     reset_at_precision:$precision,
     bracket_lower:(if $blo != "" then $blo else null end),
     bracket_upper:(if $bup != "" then $bup else null end),
     evidence:$evidence,
     recorded_at:$recorded_at,
     notes:$note}
    + (if $weekday != "" then {schedule_weekday:($weekday|tonumber)} else {} end)
    + (if $schedule_time != "" then {schedule_time:$schedule_time} else {} end)
    + (if $timezone != "" then {timezone:$timezone} else {} end)
    + (if $grade != "" then {grade:$grade} else {} end)
    + (if $dedup_key != "" then {detector_key:$dedup_key} else {} end)'
}

row="$(build_row)" || { echo "failed to build row" >&2; exit 1; }
[ -n "$row" ] || { echo "empty row" >&2; exit 1; }

if [ "$dry_run" = true ]; then printf '%s\n' "$row"; exit 0; fi

_append_once() {
  local dir="$1"
  local ev_dir="$dir/budget/reset-events" ev_file
  ev_file="$ev_dir/$subscription.jsonl"
  mkdir -p "$ev_dir" || return 1
  # Idempotence: if a detector_key was given and a row already carries it, no-op.
  if [ -n "$dedup_key" ] && [ -f "$ev_file" ]; then
    if jq -e --arg k "$dedup_key" 'select(.detector_key == $k)' "$ev_file" >/dev/null 2>&1; then
      log "reset-event $subscription detector_key=$dedup_key already recorded; skipping"
      return 0
    fi
  fi
  printf '%s\n' "$row" >> "$ev_file" || return 1
  git -C "$dir" add "budget/reset-events/$subscription.jsonl" || return 1
  log "reset-event $subscription type=$type precision=$precision at=${at:-bracket:$blo..$bup} grade=${grade:-none}"
  local rc=0
  commit_and_push "$dir" "reset-event($subscription) $type/$precision${grade:+ $grade}" || rc=$?
  [ "$rc" -eq 0 ] || [ "$rc" -eq 2 ]
}

sync_clone "$DIR"
if _append_once "$DIR"; then exit 0; fi
for attempt in 2 3 4 5 6 7 8; do
  backoff "$((attempt - 1))"
  if ( sync_clone "$DIR"; _append_once "$DIR" ); then exit 0; fi
done
echo "append-reset-event: exhausted journal-push attempts" >&2
exit 1
