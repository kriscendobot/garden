#!/bin/bash
# set-schedule.sh — race a schedule change onto the journal (CAS).
#
# Usage: set-schedule.sh <name> <cadence> [<basename-prefix>] [<body-file>]
#   <cadence>  weekly | daily | hourly | <N>s   (most schedules are weekly)
#   body from <body-file> else stdin: the task to duplicate each period.
#
# Optional deterministic preflight gate (env GARDEN_SCHEDULE_PREFLIGHT=<script>):
# writes a `preflight: <script>` frontmatter line so the scheduler runs that gate
# (resolved relative to scripts/jobs/, passed the schedule name) when the cadence
# elapses — exit 2 from the gate means "no work" and the scheduler advances the
# clock without posting. An existing preflight line is PRESERVED when the env var
# is unset, exactly like last_dispatched, so re-running set-schedule.sh to change
# cadence does not drop the gate. See scheduler.sh and skills/schedule/SKILL.md.
#
# Writes schedules/<name>; the scheduler service dispatches it on its cadence
# and stamps last_dispatched. Add-only-ish (overwrites one file), so a rejected
# push just re-syncs and retries.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
GARDEN_TAG="set-schedule"

name="${1:?usage: set-schedule.sh <name> <cadence> [prefix] [body-file]}"
cadence="${2:?cadence}"
prefix="${3:-$name}"
body_src="${4:-}"
case "$name" in -*|*/*|.*|'') die "illegal schedule name '$name'";; esac

if   [ -n "$body_src" ] && [ -f "$body_src" ]; then BODY="$(cat "$body_src")"
elif [ ! -t 0 ];                                then BODY="$(cat)"
else BODY="# scheduled job: $name"; fi

# Preflight existence check: when a gate is supplied via the env var, resolve it
# exactly as scheduler.sh does (relative to this script's dir unless absolute)
# and refuse to register the schedule if it is not found/executable. A missing
# gate fails OPEN in scheduler.sh (line ~165: "not found/executable … treating
# as work-present") and re-dispatches every tick with the gate silently
# defeated — so fail loudly here, at set time, instead. The preserve-existing
# path below is untouched: it only reuses an already-validated preflight line.
if [ -n "${GARDEN_SCHEDULE_PREFLIGHT:-}" ]; then
  pf="$GARDEN_SCHEDULE_PREFLIGHT"; case "$pf" in /*) :;; *) pf="$HERE/$pf";; esac
  [ -x "$pf" ] || die "preflight gate '$GARDEN_SCHEDULE_PREFLIGHT' not found or not executable at $pf; refusing to register schedule $name (a missing gate fails open and re-dispatches every tick)"
fi

DIR="${GARDEN_PRODUCER_CLONE:-$GARDEN_STATE/producer/journal}"
ensure_clone "$DIR"

for attempt in $(seq 1 50); do
  sync_clone "$DIR"
  mkdir -p "$DIR/schedules"
  # preserve an existing last_dispatched if the schedule already exists
  last=""
  preflight="${GARDEN_SCHEDULE_PREFLIGHT:-}"
  if [ -f "$DIR/schedules/$name.md" ]; then
    last="$(sed -n 's/^last_dispatched:[[:space:]]*//p' "$DIR/schedules/$name.md" | head -1)"
    # preserve an existing preflight when no new one is supplied via the env var
    [ -n "$preflight" ] || preflight="$(sed -n 's/^preflight:[[:space:]]*//p' "$DIR/schedules/$name.md" | head -1)"
  fi
  {
    printf 'cadence: %s\nlast_dispatched: %s\njob_basename_prefix: %s\n' "$cadence" "$last" "$prefix"
    [ -n "$preflight" ] && printf 'preflight: %s\n' "$preflight"
    printf -- '---\n'
    printf '%s\n' "$BODY"
  } > "$DIR/schedules/$name.md"
  git -C "$DIR" add "schedules/$name.md"
  if commit_and_push "$DIR" "schedule($name) cadence=$cadence"; then log "set schedule $name ($cadence)"; exit 0; fi
  rc=$?; [ "$rc" -eq 2 ] && { log "schedule $name unchanged"; exit 0; }
  backoff "$attempt"
done
die "could not set schedule $name after retries"
