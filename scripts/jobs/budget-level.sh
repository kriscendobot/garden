#!/bin/bash
# budget-level.sh — deterministic leader-only worker leveling from live pool headroom.
#
# Run directly for an operator tick, or name it as a scheduler preflight. The
# scheduler passes the schedule name as argv[1]; after doing the plain-code work
# this script returns 2 so the schedule advances without dispatching an LLM job.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
export GARDEN_TAG=budget-level

: "${GARDEN_BUDGET_LEVEL_MIN:=1}"
: "${GARDEN_BUDGET_LEVEL_MAX:=4}"
: "${GARDEN_BUDGET_LEVEL_KIND:=gardener}"
: "${GARDEN_BUDGET_LEVEL_SET_WORKERS:=$HERE/set-workers.sh}"
: "${GARDEN_BUDGET_LEVEL_SEND_HOST_OP:=$HERE/send-host-op.sh}"

scheduled=false
[ "$#" -gt 0 ] && scheduled=true
finish() { if $scheduled; then exit 2; else exit 0; fi; }

if ! is_main_host; then
  log "follower host; budget leveling is leader-only"
  finish
fi
[[ "$GARDEN_BUDGET_LEVEL_MIN" =~ ^[1-9][0-9]*$ ]] || die "GARDEN_BUDGET_LEVEL_MIN must be positive"
[[ "$GARDEN_BUDGET_LEVEL_MAX" =~ ^[1-9][0-9]*$ ]] || die "GARDEN_BUDGET_LEVEL_MAX must be positive"
[ "$GARDEN_BUDGET_LEVEL_MIN" -le "$GARDEN_BUDGET_LEVEL_MAX" ] || die "budget-level min exceeds max"

DIR="${GARDEN_BUDGET_LEVEL_CLONE:-$GARDEN_STATE/budget-level/journal}"

# Preflight: bring the journal clone current and read the budget-pool rows, ALL
# inside one subshell that holds the clone lock. The two preflight controllers can
# each abort hard: ensure_clone `die`s on a clone/lock failure, and sync_clone
# either `exit`s GARDEN_OFFLINE_RC on a transient network/resolver outage or `die`s
# on a hard fetch / unrecoverable-corruption failure. Under this script's `set -e`
# any of those would crash the whole tick with a RAW journal-controller exit code —
# the contextless failure this controller must not produce:
#   * Run as the scheduler's budget-level controller, that raw code pages the
#     maintainer as a budget-ACCOUNTING failure (an exit_status=75 "offline;
#     skipping tick" tells no one it was merely journal weather, not a pool bug).
#   * Run as a scheduler `preflight:` gate, any non-2 exit makes the scheduler fail
#     OPEN and spuriously dispatch the leveling schedule as an LLM job.
# Isolating clone+sync+read in a subshell contains the exit/die, lets us classify
# it, and fails OPEN into finish (skip this leveling tick; retry next cadence) with
# an explicit, isolated diagnostic. The subshell owns the entire locked read, so the
# clone lock is acquired and released within it — nothing leaks to the parent, and
# the read still sees a point-in-time-consistent clone. Exit-code contract of the
# subshell: 0 rows-read (rows on stdout, possibly none), 3 config-absent,
# GARDEN_OFFLINE_RC transient-outage, any other a hard clone/sync failure.
preflight_rc=0
rows_tsv="$(
  ensure_clone "$DIR"
  sync_clone "$DIR"
  file="$(budget_pool_file "$DIR" 2>/dev/null || true)"
  [ -n "$file" ] || exit 3
  while IFS=$'\t ' read -r pool provider account kind cap _rest; do
    case "$pool" in ''|'#'*) continue ;; esac
    # The current leveling actuator is per-host Anthropic worker capacity. Metered
    # API pools still participate in admission, but have no account-bound worker
    # count for this controller to change.
    [ "$provider" = anthropic ] && [ "$kind" = weekly-tokens ] || continue
    printf '%s\t%s\t%s\t%s\n' "$pool" "$provider" "$account" "$cap"
  done < "$file"
  clone_unlock "$DIR"
)" || preflight_rc=$?

if [ "$preflight_rc" -eq 3 ]; then
  log "budget pool config absent; leveling is off"
  finish
elif [ "$preflight_rc" -eq "$GARDEN_OFFLINE_RC" ]; then
  log "WARN: budget-level preflight offline (journal clone/sync, rc=$preflight_rc); skipping this leveling tick, retry next cadence (fail-open)"
  finish
elif [ "$preflight_rc" -ne 0 ]; then
  log "WARN: budget-level preflight failed (journal clone/sync, rc=$preflight_rc); skipping this leveling tick, retry next cadence (fail-open)"
  finish
fi

rows=()
while IFS= read -r row; do
  [ -n "$row" ] && rows+=("$row")
done <<<"$rows_tsv"

if cutoff="$(meter_window_cutoff anchor 2>/dev/null)"; then
  cutoff_rc=0
else
  cutoff_rc=$?
  cutoff=""
fi
[[ "$cutoff" =~ ^[0-9]+$ ]] || [ "$cutoff_rc" -ne 0 ] || cutoff_rc=1
pool_failure() { # pool host operation status
  log "WARN: pool=$1 host=$2 operation=$3 failed exit_status=$4; failure isolated (fail-open)"
}

for row in "${rows[@]}"; do
  IFS=$'\t' read -r pool provider host cap <<<"$row"
  [[ "$cap" =~ ^[1-9][0-9]*$ ]] || { log "WARN: $pool has invalid cap '$cap'; leaving workers unchanged (fail-open)"; continue; }

  if [ "$host" = "$GARDEN" ]; then
    if spend="$(meter_window_total anchor 2>/dev/null)"; then
      :
    else
      rc=$?
      pool_failure "$pool" "$host" read-local-spend "$rc"
      continue
    fi
  elif [[ "$cutoff" =~ ^[0-9]+$ ]]; then
    if spend="$(meter_remote_snapshot_total "$DIR" "$pool" "$cap" "$cutoff" 2>/dev/null)"; then
      :
    else
      rc=$?
      pool_failure "$pool" "$host" read-remote-snapshot "$rc"
      if spend="$(meter_journal_host_tokens "$DIR" "$host" "$cutoff" 2>/dev/null)"; then
        :
      else
        rc=$?
        pool_failure "$pool" "$host" read-journal-spend "$rc"
        continue
      fi
    fi
  else
    pool_failure "$pool" "$host" read-window-cutoff "$cutoff_rc"
    continue
  fi
  [[ "$spend" =~ ^[0-9]+$ ]] || { pool_failure "$pool" "$host" validate-spend 1; continue; }

  if target="$(awk -v t="$spend" -v q="$cap" -v f="$GARDEN_TOKEN_BACKOFF_FRACTION" \
                    -v lo="$GARDEN_BUDGET_LEVEL_MIN" -v hi="$GARDEN_BUDGET_LEVEL_MAX" '
    BEGIN {
      mark=q*f
      if (mark <= 0 || t >= mark) n=lo
      else {
        headroom=1-(t/mark)
        n=lo+int(headroom*(hi-lo)+0.5)
      }
      if (n<lo) n=lo; if (n>hi) n=hi; printf "%d\n", n
    }')"; then
    :
  else
    rc=$?
    pool_failure "$pool" "$host" compute-target "$rc"
    continue
  fi
  host_file="$DIR/hosts/$host"
  if current="$(awk '/^gardeners:[[:space:]]*/ { sub(/^gardeners:[[:space:]]*/, ""); print; exit }' "$host_file" 2>/dev/null)"; then
    :
  else
    rc=$?
    pool_failure "$pool" "$host" read-host-workers "$rc"
    continue
  fi
  [[ "$current" =~ ^[0-9]+$ ]] || { pool_failure "$pool" "$host" validate-host-workers 1; continue; }
  [ "$current" -ne "$target" ] || continue

  reason="budget pool $pool spend=$spend cap=$cap high-water=$GARDEN_TOKEN_BACKOFF_FRACTION target=$target"
  if [ "$host" = "$GARDEN" ]; then
    if /bin/bash "$GARDEN_BUDGET_LEVEL_SET_WORKERS" "$GARDEN_BUDGET_LEVEL_KIND" "$target"; then
      :
    else
      rc=$?
      pool_failure "$pool" "$host" set-local-workers "$rc"
      continue
    fi
  else
    if /bin/bash "$GARDEN_BUDGET_LEVEL_SEND_HOST_OP" "$host" op=set-workers kind="$GARDEN_BUDGET_LEVEL_KIND" count="$target" reason="$reason"; then
      :
    else
      rc=$?
      pool_failure "$pool" "$host" send-host-set-workers "$rc"
      continue
    fi
  fi
  log "leveled $host $current->$target ($reason)"
  alert_maintainer "budget-level-$host-$target" \
    "budget-level changed $host $GARDEN_BUDGET_LEVEL_KIND workers $current -> $target: $reason"
done

finish
