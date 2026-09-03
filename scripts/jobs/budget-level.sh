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
# Empty means DERIVE the Anthropic worker spelling per host (monk on a cut-over host,
# else legacy gardener) from the host's own count line. A non-empty value forces one
# kind for every pool (operators/tests). See the per-host resolution in the loop.
: "${GARDEN_BUDGET_LEVEL_KIND:=}"
: "${GARDEN_BUDGET_LEVEL_SET_WORKERS:=$HERE/set-workers.sh}"
: "${GARDEN_BUDGET_LEVEL_SEND_HOST_OP:=$HERE/send-host-op.sh}"
# Restraint (cybernetics-audit.md § 5.1, recommendation 3): a memoryless proportional
# controller that jumps 1<->4 in a single tick on a sensor up to 45 min stale thrashes
# at band boundaries. Give it the confirm-before-move dwell and one-step-per-tick clamp
# the design already claims (live-budget-admission.md:296-298) and the house pattern
# backend_effective_count uses (common.sh confirm-before-move). Move at most STEP per
# tick; raise (more workers, more spend — the § 2.2 hazard direction) only after
# UP_CONFIRM consecutive same-direction ticks; throttle (the safe action) promptly.
: "${GARDEN_BUDGET_LEVEL_STEP:=1}"
: "${GARDEN_BUDGET_LEVEL_UP_CONFIRM:=2}"
: "${GARDEN_BUDGET_LEVEL_DOWN_CONFIRM:=1}"
: "${GARDEN_BUDGET_LEVEL_DWELL_DIR:=$GARDEN_STATE/budget-level/dwell}"

scheduled=false
[ "$#" -gt 0 ] && scheduled=true
finish() { if $scheduled; then exit 2; else exit 0; fi; }

if ! is_main_host; then
  log "follower host; budget leveling is leader-only"
  finish
fi

# Skip leveling entirely while the fleet is draining: a drain stops every worker, so
# re-asserting counts (and raising a per-change maintainer alert) on a drained host is
# noise that also fights the drain (cybernetics-audit.md § 4.1). The sysop still ticks
# under drain to receive `drain off`; leveling has no such reason to run.
if fleet_draining; then
  log "fleet draining; budget leveling suspended this tick"
  finish
fi

# Per-host dwell record (host-local, no journal write — like backend_effective_count's
# runtime record). Tracks the last move direction and its consecutive-tick streak so a
# move only fires once the direction has been confirmed, and a boundary flip resets it.
_dwell_file() { printf '%s\n' "$GARDEN_BUDGET_LEVEL_DWELL_DIR/${1//[^A-Za-z0-9._-]/_}"; }
# budget_level_dwell_bump <host> <dir> — increment the streak if <dir> matches the
# recorded direction, else restart it at 1. Prints the new streak. Best-effort persist.
budget_level_dwell_bump() {
  local host="$1" dir="$2" f prev_dir="" prev_streak=0 streak
  f="$(_dwell_file "$host")"
  if [ -f "$f" ]; then
    prev_dir="$(sed -n 's/^dir=//p' "$f" | head -1)"
    prev_streak="$(sed -n 's/^streak=//p' "$f" | head -1)"
    [[ "$prev_streak" =~ ^[0-9]+$ ]] || prev_streak=0
  fi
  if [ "$dir" = "$prev_dir" ]; then streak=$((prev_streak + 1)); else streak=1; fi
  mkdir -p "$(dirname "$f")" 2>/dev/null || true
  if { printf 'dir=%s\n' "$dir"; printf 'streak=%s\n' "$streak"; } > "$f.tmp" 2>/dev/null; then
    mv "$f.tmp" "$f" 2>/dev/null || true
  fi
  printf '%s\n' "$streak"
}
# budget_level_dwell_reset <host> — clear the streak (host is at target). A subsequent
# move must re-confirm from scratch.
budget_level_dwell_reset() {
  local f; f="$(_dwell_file "$1")"
  mkdir -p "$(dirname "$f")" 2>/dev/null || true
  if { printf 'dir=none\n'; printf 'streak=0\n'; } > "$f.tmp" 2>/dev/null; then
    mv "$f.tmp" "$f" 2>/dev/null || true
  fi
}
[[ "$GARDEN_BUDGET_LEVEL_STEP" =~ ^[1-9][0-9]*$ ]] || GARDEN_BUDGET_LEVEL_STEP=1
[[ "$GARDEN_BUDGET_LEVEL_UP_CONFIRM" =~ ^[1-9][0-9]*$ ]] || GARDEN_BUDGET_LEVEL_UP_CONFIRM=2
[[ "$GARDEN_BUDGET_LEVEL_DOWN_CONFIRM" =~ ^[1-9][0-9]*$ ]] || GARDEN_BUDGET_LEVEL_DOWN_CONFIRM=1

# budget_level_uncalibrated <calibrated-from> — true when a pool's cap carries no
# usable provenance: an empty/absent field, or an explicit self-disclaiming marker
# (the placeholder seed says "PLACEHOLDER CAPS — NOT CALIBRATED", and the 2026-09-01
# config header does this by hand in prose). Do not actuate on a setpoint the config
# disclaims (cybernetics-audit.md § 2.3, recommendation 2): the leader sat in
# permanent backoff for days against the 5M placeholder cap. Case-insensitive.
budget_level_uncalibrated() {
  case "$(printf '%s' "${1:-}" | tr '[:upper:]' '[:lower:]')" in
    ''|-|none|placeholder|uncalibrated|seed|tbd|todo) return 0 ;;
    *) return 1 ;;
  esac
}
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
  while IFS=$'\t ' read -r pool provider account kind cap calibrated_from calibrated_at _rest; do
    case "$pool" in ''|'#'*) continue ;; esac
    # The current leveling actuator is per-host Anthropic worker capacity. Metered
    # API pools still participate in admission, but have no account-bound worker
    # count for this controller to change.
    [ "$provider" = anthropic ] && [ "$kind" = weekly-tokens ] || continue
    # Columns 6-7 are the optional cap provenance (calibrated-from, date). Absent
    # columns become empty strings, which the loop reads as "uncalibrated".
    printf '%s\t%s\t%s\t%s\t%s\t%s\n' "$pool" "$provider" "$account" "$cap" "${calibrated_from:-}" "${calibrated_at:-}"
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
  IFS=$'\t' read -r pool provider host cap calibrated_from calibrated_at <<<"$row"
  [[ "$cap" =~ ^[1-9][0-9]*$ ]] || { log "WARN: $pool has invalid cap '$cap'; leaving workers unchanged (fail-open)"; continue; }

  # Treat an uncalibrated / placeholder-marked cap as config-absent for LEVELING:
  # level nothing, and alert ONCE (a stable key so alert_maintainer deduplicates the
  # repeated tick). A measured cap must precede full-authority actuation against it.
  if budget_level_uncalibrated "$calibrated_from"; then
    log "budget pool $pool cap=$cap is UNCALIBRATED (calibrated-from='${calibrated_from:-none}'); leveling nothing — config disclaims this setpoint"
    alert_maintainer "budget-level-uncalibrated-$pool" \
      "budget-level: pool $pool cap=$cap is UNCALIBRATED (provenance='${calibrated_from:-none}'); NOT leveling workers against a setpoint the config disclaims. Calibrate it (weekly-capacity-calibration.sh or Claude Code /usage) and set the provenance columns on config/budget-pools (calibrated-from date)."
    continue
  fi

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
  # Which Anthropic worker spelling this host arms (monk on a cut-over host, else the
  # legacy gardener) — steer the line the scaler actually reads. A non-empty override
  # forces one kind for every pool (cybernetics-audit.md § 4.1: the hardcoded
  # `gardeners:` awk steered a line nothing reads on a cut-over host).
  if [ -n "$GARDEN_BUDGET_LEVEL_KIND" ]; then
    active_kind="$GARDEN_BUDGET_LEVEL_KIND"
  else
    active_kind="$(anthropic_active_kind "$host_file")"
  fi
  count_key="$(worker_kind_field "$active_kind" count_key 2>/dev/null)" || count_key=gardeners
  if current="$(read_desired_count "$host_file" "$count_key" 2>/dev/null)"; then
    :
  else
    rc=$?
    pool_failure "$pool" "$host" read-host-workers "$rc"
    continue
  fi
  [[ "$current" =~ ^[0-9]+$ ]] || { pool_failure "$pool" "$host" validate-host-workers 1; continue; }
  if [ "$current" -eq "$target" ]; then budget_level_dwell_reset "$host"; continue; fi

  # Confirm-before-move dwell + one-step-per-tick clamp. Raise cautiously (the § 2.2
  # maximize-on-noise direction); throttle promptly. The move only ever narrows the gap.
  if [ "$target" -gt "$current" ]; then dir=up; confirm="$GARDEN_BUDGET_LEVEL_UP_CONFIRM"
  else dir=down; confirm="$GARDEN_BUDGET_LEVEL_DOWN_CONFIRM"; fi
  streak="$(budget_level_dwell_bump "$host" "$dir")"
  if [ "$streak" -lt "$confirm" ]; then
    log "budget-level dwell $host $current->$target ($dir $streak/$confirm); holding this tick"
    continue
  fi
  if [ "$dir" = up ]; then
    next=$((current + GARDEN_BUDGET_LEVEL_STEP)); [ "$next" -gt "$target" ] && next="$target"
  else
    next=$((current - GARDEN_BUDGET_LEVEL_STEP)); [ "$next" -lt "$target" ] && next="$target"
  fi

  reason="budget pool $pool spend=$spend cap=$cap high-water=$GARDEN_TOKEN_BACKOFF_FRACTION target=$target step=$current->$next"
  if [ "$host" = "$GARDEN" ]; then
    if /bin/bash "$GARDEN_BUDGET_LEVEL_SET_WORKERS" "$active_kind" "$next"; then
      :
    else
      rc=$?
      pool_failure "$pool" "$host" set-local-workers "$rc"
      continue
    fi
  else
    if /bin/bash "$GARDEN_BUDGET_LEVEL_SEND_HOST_OP" "$host" op=set-workers kind="$active_kind" count="$next" reason="$reason"; then
      :
    else
      rc=$?
      pool_failure "$pool" "$host" send-host-set-workers "$rc"
      continue
    fi
  fi
  log "leveled $host $active_kind $current->$next (target $target; $reason)"
  alert_maintainer "budget-level-$host-$next" \
    "budget-level changed $host $active_kind workers $current -> $next (target $target): $reason"
done

finish
