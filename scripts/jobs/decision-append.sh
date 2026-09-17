#!/bin/bash
# decision-append.sh — append one cybernetic decision to the host's weekly ledger.
#
# The ledger week starts at Sunday 00:00 in America/Los_Angeles.  Each new file
# begins with its own rotation decision, then the caller's decision.  The journal
# push is the append serialization point: a rejected push is hard-synced and the
# row is appended again to the new tip.  Recording is observability, so every
# runtime failure is reported but exits successfully; a controller's actuation
# must never fail because its ledger write did.
set -uo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
export GARDEN_TAG=decision-append

usage() {
  cat <<'EOF'
Usage: decision-append.sh --loop NAME --input-json OBJECT --decision NAME
                          --reason TEXT --outcome OUTCOME
                          [--outcome-detail TEXT]
                          [--from-json JSON] [--to-json JSON]

OUTCOME is one of: applied, fail-open-skipped, no-op, superseded.
The JSON values supplied to --from-json and --to-json default to null.
EOF
}

loop=""
input_json=""
decision=""
reason=""
outcome=""
outcome_detail=""
from_json=null
to_json=null
while [ "$#" -gt 0 ]; do
  case "$1" in
    --loop) loop="${2:?--loop needs a value}"; shift 2 ;;
    --input-json) input_json="${2:?--input-json needs a value}"; shift 2 ;;
    --decision) decision="${2:?--decision needs a value}"; shift 2 ;;
    --reason) reason="${2:?--reason needs a value}"; shift 2 ;;
    --outcome) outcome="${2:?--outcome needs a value}"; shift 2 ;;
    --outcome-detail) outcome_detail="${2:?--outcome-detail needs a value}"; shift 2 ;;
    --from-json) from_json="${2:?--from-json needs a value}"; shift 2 ;;
    --to-json) to_json="${2:?--to-json needs a value}"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) usage >&2; exit 2 ;;
  esac
done

if [ -z "$loop" ] || [ -z "$input_json" ] || [ -z "$decision" ] \
   || [ -z "$reason" ] || [ -z "$outcome" ]; then
  usage >&2
  exit 2
fi
case "$outcome" in
  applied|fail-open-skipped|no-op|superseded) ;;
  *) log "invalid decision outcome '$outcome'"; exit 2 ;;
esac
case "$GARDEN" in
  ''|*[!A-Za-z0-9._-]*) log "invalid host identity '$GARDEN'"; exit 2 ;;
esac
command -v jq >/dev/null 2>&1 || { log "WARN: jq unavailable; decision not recorded (fail-open)"; exit 0; }
jq -e 'type == "object"' >/dev/null 2>&1 <<<"$input_json" \
  || { log "invalid --input-json (expected an object)"; exit 2; }
jq -e 'type' >/dev/null 2>&1 <<<"$from_json" \
  || { log "invalid --from-json"; exit 2; }
jq -e 'type' >/dev/null 2>&1 <<<"$to_json" \
  || { log "invalid --to-json"; exit 2; }

decision_week_start() { # epoch -> Pacific-local Sunday date
  local epoch="$1" local_date weekday days_since_sunday
  local_date="$(TZ=America/Los_Angeles date -d "@$epoch" +%F)" || return 1
  weekday="$(TZ=America/Los_Angeles date -d "@$epoch" +%u)" || return 1
  days_since_sunday=$(( weekday % 7 ))
  TZ=America/Los_Angeles date -d "$local_date - $days_since_sunday days" +%F
}

previous_ledger_path() { # journal clone, current relative path
  local directory="$1" current="$2" candidate relative filename best=""
  for candidate in "$directory"/budget/decisions/*.jsonl; do
    [ -f "$candidate" ] || continue
    relative="${candidate#"$directory"/}"
    filename="${candidate##*/}"
    [ "$relative" != "$current" ] || continue
    case "$filename" in ????-??-??-"$GARDEN".jsonl) ;; *) continue ;; esac
    [[ "$relative" < "$current" ]] || continue
    if [ -z "$best" ] || [[ "$best" < "$relative" ]]; then best="$relative"; fi
  done
  printf '%s\n' "$best"
}

append_decision() {
  local directory now_epoch timestamp week_start ledger_path ledger_file
  local prior_path prior_json rotation_row decision_row attempt result
  directory="${GARDEN_DECISION_CLONE:-$GARDEN_STATE/decisions/journal}"
  now_epoch="${GARDEN_DECISION_NOW_EPOCH:-$(date -u +%s)}"
  [[ "$now_epoch" =~ ^[0-9]+$ ]] || return 1
  timestamp="$(date -u -d "@$now_epoch" +%FT%TZ)" || return 1
  week_start="$(decision_week_start "$now_epoch")" || return 1
  ledger_path="budget/decisions/$week_start-$GARDEN.jsonl"
  ledger_file="$directory/$ledger_path"

  decision_row="$(jq -cn \
    --arg timestamp "$timestamp" --arg loop "$loop" \
    --argjson input "$input_json" --arg decision "$decision" \
    --argjson from "$from_json" --argjson to "$to_json" \
    --arg reason "$reason" --arg outcome "$outcome" \
    --arg detail "$outcome_detail" \
    '{ts:$timestamp,loop:$loop,input:$input,decision:$decision,from:$from,to:$to,reason:$reason,outcome:$outcome,outcome_detail:$detail}')" \
    || return 1

  ensure_clone "$directory"
  for attempt in $(seq 1 "${GARDEN_DECISION_ATTEMPTS:-8}"); do
    sync_clone "$directory"
    mkdir -p "$(dirname "$ledger_file")"
    if [ ! -s "$ledger_file" ]; then
      prior_path="$(previous_ledger_path "$directory" "$ledger_path")"
      if [ -n "$prior_path" ]; then
        prior_json="$(jq -cn --arg value "$prior_path" '$value')" || return 1
      else
        prior_json=null
      fi
      rotation_row="$(jq -cn \
        --arg timestamp "$timestamp" --arg week_start "$week_start" \
        --arg timezone America/Los_Angeles --arg current "$ledger_path" \
        --argjson prior "$prior_json" \
        '{ts:$timestamp,loop:"decision-ledger",input:{prior_ledger:$prior,week_start:$week_start,timezone:$timezone},decision:"rotate-ledger",from:$prior,to:$current,reason:"Pacific-local Sunday 00:00 weekly boundary",outcome:"applied",outcome_detail:"created weekly decision ledger"}')" \
        || return 1
      printf '%s\n' "$rotation_row" >> "$ledger_file" || return 1
    fi
    printf '%s\n' "$decision_row" >> "$ledger_file" || return 1
    git -C "$directory" add "$ledger_path" || return 1
    result=0
    commit_and_push "$directory" "decision($GARDEN/$week_start) $loop:$decision" || result=$?
    [ "$result" -eq 0 ] && return 0
    # Nothing staged means there is no append to recover. Observability remains
    # fail-open, matching usage-append.sh's treatment of commit rc=2.
    [ "$result" -eq 2 ] && return 0
    backoff "$attempt"
  done
  return 1
}

# sync_clone deliberately exits on an offline journal.  Isolate the whole writer
# in a subshell so that exit is converted into the promised fail-open result.
if ! ( append_decision ); then
  log "WARN: decision '$loop:$decision' was not recorded after bounded attempts (fail-open)"
fi
exit 0
