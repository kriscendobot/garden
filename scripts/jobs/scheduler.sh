#!/bin/bash
# scheduler.sh — dispatch regularly scheduled jobs (the sole scheduler service).
#
# Usage: scheduler.sh
#
# Each tick: sync the journal, and for every schedules/<name> whose cadence has
# elapsed since its last_dispatched, post a fresh copy of its task to the board
# AND stamp last_dispatched — in ONE CAS commit, so the dispatch and the stamp
# are atomic and two hosts cannot double-dispatch the same period. The common
# case is duplicating a task weekly.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
GARDEN_TAG="scheduler"

cadence_seconds() {
  case "$1" in
    weekly) echo 604800;; daily) echo 86400;; hourly) echo 3600;;
    *s) echo "${1%s}";; *m) echo $(( ${1%m} * 60 ));; *h) echo $(( ${1%h} * 3600 ));; *d) echo $(( ${1%d} * 86400 ));;
    *) echo 604800;;  # default weekly
  esac
}

DIR="${GARDEN_SCHEDULER_CLONE:-$GARDEN_STATE/scheduler/journal}"
ensure_clone "$DIR"
sync_clone "$DIR"

now="$(date -u +%s)"
dispatched=0
for name in $(list_jobs "$DIR" schedules); do
  f="$DIR/schedules/$name"

  # One-time future schedule (`once: <ISO>`): dispatch exactly once when due,
  # then DELETE the schedule file in the same CAS commit so it never repeats.
  # The recurring path below is unchanged.
  once_iso="$(sed -n 's/^once:[[:space:]]*//p' "$f" | head -1)"
  if [ -n "$once_iso" ]; then
    due="$(date -u -d "$once_iso" +%s 2>/dev/null || echo '')"
    [ -n "$due" ] || { log "schedule $name has unparseable once: '$once_iso'; skipping"; continue; }
    [ "$now" -ge "$due" ] || continue   # not due yet
    prefix="$(sed -n 's/^job_basename_prefix:[[:space:]]*//p' "$f" | head -1)"
    base="${prefix:-${name%.md}}"       # deterministic — no timestamp, so a retry is idempotent
    for attempt in $(seq 1 50); do
      sync_clone "$DIR"
      [ -f "$DIR/schedules/$name" ] || { log "schedule $name already fired+removed; skip"; break; }
      body="$(sed '1,/^---$/d' "$DIR/schedules/$name")"
      git -C "$DIR" rm -q "schedules/$name"
      if [ -e "$DIR/$JOBS_TODO/$base.md" ] || [ -e "$DIR/$JOBS_DOIN/$base.md" ] || [ -e "$DIR/$JOBS_TADA/$base.md" ]; then
        # job already exists in the lifecycle — just retire the schedule
        if commit_and_push "$DIR" "schedule-once($name) already dispatched; removing"; then
          log "one-time schedule $name retired ($base already present)"; break
        fi
      else
        mkdir -p "$DIR/$JOBS_TODO"
        printf '%s\n' "$body" > "$DIR/$JOBS_TODO/$base.md"
        git -C "$DIR" add "$JOBS_TODO/$base.md"
        if commit_and_push "$DIR" "schedule-once($name) dispatched $base + removed"; then
          log "dispatched $base from one-time schedule $name (removed)"; dispatched=$((dispatched+1)); break
        fi
      fi
      backoff
    done
    continue
  fi

  cad="$(sed -n 's/^cadence:[[:space:]]*//p' "$f" | head -1)"
  last_iso="$(sed -n 's/^last_dispatched:[[:space:]]*//p' "$f" | head -1)"
  prefix="$(sed -n 's/^job_basename_prefix:[[:space:]]*//p' "$f" | head -1)"
  cad_s="$(cadence_seconds "$cad")"
  last=0; [ -n "$last_iso" ] && last="$(date -u -d "$last_iso" +%s 2>/dev/null || echo 0)"
  [ $(( now - last )) -ge "$cad_s" ] || continue

  base="${prefix:-$name}-$(date -u +%Y%m%d-%H%M%S)"
  for attempt in $(seq 1 50); do
    sync_clone "$DIR"
    # re-check due against the freshest state (another host may have dispatched)
    last_iso="$(sed -n 's/^last_dispatched:[[:space:]]*//p' "$DIR/schedules/$name" | head -1)"
    last=0; [ -n "$last_iso" ] && last="$(date -u -d "$last_iso" +%s 2>/dev/null || echo 0)"
    [ $(( now - last )) -ge "$cad_s" ] || { log "$name no longer due; skip"; break; }

    body="$(sed '1,/^---$/d' "$DIR/schedules/$name")"
    mkdir -p "$DIR/$JOBS_TODO"
    printf '%s\n' "$body" > "$DIR/$JOBS_TODO/$base.md"
    # stamp last_dispatched in the same commit
    { printf 'cadence: %s\nlast_dispatched: %s\njob_basename_prefix: %s\n---\n' \
        "$cad" "$(date -u +%FT%TZ)" "$prefix"; printf '%s\n' "$body"; } > "$DIR/schedules/$name"
    git -C "$DIR" add "$JOBS_TODO/$base.md" "schedules/$name"
    if commit_and_push "$DIR" "schedule($name) dispatched $base"; then
      log "dispatched $base from schedule $name"; dispatched=$((dispatched+1)); break
    fi
    backoff
  done
done
log "dispatched $dispatched scheduled job(s)"
