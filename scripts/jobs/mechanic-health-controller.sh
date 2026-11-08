#!/bin/bash
# mechanic-health-controller.sh — deterministic controller-mode host-health pass.
#
# The recurring controller watch is normally a sensor, not a repair job.  Read
# the small durable surfaces that decide whether the paired local check and the
# host controller are routine.  Write one bounded latest-state disposition.  A
# nonzero health signal returns 10 so scheduler.sh can dispatch the mechanic for
# judgment or an attested repair; ordinary pending/healthy cycles return 0 and
# consume no worker.

set -euo pipefail

repo="${1:?journal clone}"
schedule="${2:?schedule filename}"
cycle_base="${3:?cycle base}"
stamp="${4:?cycle stamp}"
now="${5:?cycle epoch}"
output="${6:?output path relative to journal clone}"

schedule_file="$repo/schedules/$schedule"
[ -f "$schedule_file" ] || { echo "missing schedule: $schedule" >&2; exit 2; }

body="$(sed '1,/^---$/d' "$schedule_file")"
field() { printf '%s\n' "$body" | sed -n "s/^$1:[[:space:]]*//p" | head -1; }
bounded() { LC_ALL=C tr -d '\000\r\n' | cut -c1-160; }
target="$(field target_host)"
mode="$(field mode)"
role="$(printf '%s\n' "$body" | sed -n 's/^role:[[:space:]]*//p' | head -1)"
if [ "$role" != mechanic ] || [ "$mode" != controller ] || [ -z "$target" ]; then
  echo "$schedule is not a mechanic controller schedule" >&2
  exit 2
fi
[[ "$target" =~ ^[A-Za-z0-9._-]+$ ]] \
  || { echo "unsafe controller target: $target" >&2; exit 2; }

# The controller/local pair deliberately shares a basename stem.  Keeping this
# derivation in plain code means the schedule body remains the thin role dispatch
# guarded by check-mechanic-role.sh.
case "$schedule" in
  *-watch.md) paired_schedule="${schedule%-watch.md}-checkup.md" ;;
  *) echo "controller schedule has no -watch/-checkup pair: $schedule" >&2; exit 2 ;;
esac
paired_prefix="$(sed -n 's/^job_basename_prefix:[[:space:]]*//p' "$repo/schedules/$paired_schedule" 2>/dev/null | head -1)"
# Check the pair from the controller's PREVIOUS fire.  On a scheduler tick the
# local schedule sorts first and has already been advanced to the new fire, which
# would otherwise make every controller pass observe only the just-created todo.
# Before scheduler.sh rewrites this file, its own last_dispatched is the stable
# identity shared by the prior paired check.
paired_last="$(sed -n 's/^last_dispatched:[[:space:]]*//p' "$schedule_file" | head -1)"
paired_base=""
if [ -n "$paired_prefix" ] && pair_epoch="$(date -u -d "$paired_last" +%s 2>/dev/null)"; then
  paired_base="$paired_prefix-$(date -u -d "@$pair_epoch" +%Y%m%d-%H%M%S)"
fi

paired_state=missing
paired_report=""
if [ -n "$paired_base" ]; then
  for state in plan todo doin; do
    if [ -f "$repo/jobs/$state/$paired_base.md" ]; then
      paired_state="$state"
      paired_report="$repo/jobs/$state/$paired_base.md"
      break
    fi
  done
  if [ "$paired_state" = missing ]; then
    paired_report="$(find "$repo/jobs/tada" -type f -name "$paired_base.md" -print -quit 2>/dev/null || true)"
    [ -n "$paired_report" ] && paired_state=complete
  fi
fi
# Count every still-live instance of the paired family.  The prior pair alone is
# always at most one cadence old, so a target that has stopped claiming its local
# checks would otherwise read as a routine "pending" forever (2026-11-08: fourteen
# oros checkups queued in todo/, the oldest three days old).
paired_live=0
paired_oldest=none
paired_oldest_age=0
if [ -n "$paired_prefix" ]; then
  for state in plan todo doin; do
    for f in "$repo/jobs/$state/$paired_prefix"-[0-9]*.md; do
      [ -e "$f" ] || continue
      paired_live=$((paired_live + 1))
      ts="$(basename "$f" .md)"; ts="${ts#"$paired_prefix"-}"
      if [[ "$ts" =~ ^([0-9]{8})-([0-9]{2})([0-9]{2})([0-9]{2})$ ]] \
         && e="$(date -u -d "${BASH_REMATCH[1]} ${BASH_REMATCH[2]}:${BASH_REMATCH[3]}:${BASH_REMATCH[4]}" +%s 2>/dev/null)" \
         && [ $((now - e)) -gt "$paired_oldest_age" ]; then
        paired_oldest_age=$((now - e))
        paired_oldest="$(basename "$f" .md)"
      fi
    done
  done
fi

paired_verdict=""
paired_status=""
if [ -n "$paired_report" ]; then
  paired_verdict="$(sed -n 's/^- Verdict:[[:space:]]*//p' "$paired_report" | head -1 | bounded)"
  paired_status="$(sed -n 's/^status:[[:space:]]*//p' "$paired_report" | head -1 | bounded)"
fi
if [ "$paired_status" = superseded ]; then paired_verdict=superseded; fi
[ -n "$paired_verdict" ] || paired_verdict=none

read_record_field() {
  [ -f "$1" ] || return 0
  sed -n "s/^$2:[[:space:]]*//p" "$1" | head -1 | bounded
}
fleet="$repo/fleet/health/$target"
fleet_at="$(read_record_field "$fleet" at)"; [ -n "$fleet_at" ] || fleet_at=missing
fleet_roll="$(read_record_field "$fleet" roll_status)"; [ -n "$fleet_roll" ] || fleet_roll=missing
fleet_failed="$(read_record_field "$fleet" unit_failures)"; [ -n "$fleet_failed" ] || fleet_failed=missing
deployed="$(read_record_field "$fleet" deployed_sha)"; [ -n "$deployed" ] || deployed=missing

roll_target="$(head -1 "$repo/deploy/roll/$target" 2>/dev/null | tr -cd 'A-Fa-f0-9' | cut -c1-40)"
[ -n "$roll_target" ] || roll_target=none
roll_completed=no
[ "$roll_target" = none ] || [ ! -f "$repo/deploy/roll-completed/$roll_target" ] || roll_completed=yes

sysop_file="$(find "$repo/sysop-log/$target" -maxdepth 1 -type f -name '*.md' -printf '%f\n' 2>/dev/null | sort | tail -1)"
sysop_op=none; sysop_outcome=none; sysop_at=missing
if [ -n "$sysop_file" ]; then
  sysop="$repo/sysop-log/$target/$sysop_file"
  sysop_op="$(read_record_field "$sysop" op)"; [ -n "$sysop_op" ] || sysop_op=unknown
  sysop_outcome="$(read_record_field "$sysop" outcome)"; [ -n "$sysop_outcome" ] || sysop_outcome=unknown
  sysop_at="$(read_record_field "$sysop" at)"; [ -n "$sysop_at" ] || sysop_at=missing
fi

host="$repo/hosts/$target"
workers="$(read_record_field "$host" monks)"; [ -n "$workers" ] || workers=unknown

reasons=()
# A queued/running paired check is routine: the local worker owns gathering the
# evidence and the next controller cycle will observe its completion.  A settled
# non-healthy verdict, by contrast, requires mechanic judgment.
paired_pending=0
if [ "$paired_state" = complete ]; then
  case "$paired_verdict" in
    healthy) ;;
    superseded) paired_pending=1 ;;
    none) reasons+=(paired-completion-without-verdict) ;;
    *) reasons+=("paired-$paired_verdict") ;;
  esac
elif [ "$paired_state" = missing ] && [ -n "$paired_base" ]; then
  # The prior pair was dispatched yet is nowhere on the board (reaped,
  # withdrawn, or never posted).  Waiting on it would mask the gap forever.
  reasons+=(paired-missing)
else
  paired_pending=1
fi
backlog_max="${GARDEN_MECHANIC_PAIRED_MAX_AGE:-21600}"
if [ "$paired_pending" -eq 1 ] && [ "$paired_oldest_age" -gt "$backlog_max" ]; then
  # A paired check that has outlived two cycles is not "pending"; the target is
  # not claiming its local checks.  That needs the controller's diagnosis.
  disposition=mechanic-required
  reason=paired-check-backlog
elif [ "$paired_pending" -eq 1 ]; then
  # Do not mint a second diagnostic while the target-owned local check is still
  # queued/running (or was superseded by a newer check).  The bounded controller
  # record makes that wait visible and this cycle closes without an LLM.
  disposition=awaiting-paired-check
  reason="paired-$paired_state"
else
  case "$fleet_failed" in
    0) ;;
    missing|*[!0-9]*) reasons+=(fleet-health-unreadable) ;;
    *) reasons+=(unit-failures) ;;
  esac
  case "$fleet_roll" in
    deployed|deferred) ;;
    *) reasons+=("roll-$fleet_roll") ;;
  esac
  if fleet_epoch="$(date -u -d "$fleet_at" +%s 2>/dev/null)"; then
    max_age="${GARDEN_MECHANIC_HEALTH_MAX_AGE:-21600}"
    [ $(( now - fleet_epoch )) -le "$max_age" ] || reasons+=(fleet-health-stale)
  else
    reasons+=(fleet-health-missing)
  fi
  case "$sysop_outcome" in
    none|accepted-and-applied) ;;
    *) reasons+=("sysop-$sysop_outcome") ;;
  esac

  disposition=routine-closed
  [ "${#reasons[@]}" -eq 0 ] || disposition=mechanic-required
  reason=none
  [ "${#reasons[@]}" -eq 0 ] || reason="$(IFS=,; printf '%s' "${reasons[*]}")"
fi

tmp="$(mktemp "${TMPDIR:-/tmp}/mechanic-health-disposition.XXXXXX")"
trap 'rm -f "$tmp"' EXIT
cat >"$tmp" <<EOF
# Controller health: $target

- At: $stamp
- Schedule / cycle: $schedule / $cycle_base
- Disposition: $disposition
- Reason: $reason
- Prior paired local: ${paired_base:-none} / $paired_state / $paired_verdict
- Live paired checks: count=$paired_live oldest=$paired_oldest age_s=$paired_oldest_age
- Fleet: at=$fleet_at deployed=$deployed roll_status=$fleet_roll unit_failures=$fleet_failed
- Roll: target=$roll_target completed=$roll_completed
- Latest sysop: record=${sysop_file:-none} op=$sysop_op outcome=$sysop_outcome at=$sysop_at
- Declared monks: $workers
EOF
mkdir -p "$(dirname "$repo/$output")"
mv "$tmp" "$repo/$output"
trap - EXIT

[ "$disposition" != mechanic-required ] && exit 0
exit 10
