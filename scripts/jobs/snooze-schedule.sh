#!/bin/bash
# snooze-schedule.sh — pause a recurring schedule until a wall-clock instant,
# then let it resume on its normal cadence. A time-boxed, self-expiring "quiet
# until <T>" for the scheduler, expressed purely in journal state the ALREADY
# DEPLOYED scheduler honours (no code deploy needed to take effect).
#
# Usage: snooze-schedule.sh <name> <until>
#   <name>   an existing schedules/<name>.md on journal2
#   <until>  any GNU `date -d` instant, in the FUTURE. Include an explicit zone
#            or offset so it is unambiguous, e.g.
#              snooze-schedule.sh minion-town-agenda-review '2026-08-25 17:00:00Z'
#              snooze-schedule.sh some-daily 'tomorrow 09:00 CET'
#
# HOW. An interval schedule (`2h`, `daily`, `30m`, …) is due when
#   now - last_dispatched >= cadence_seconds.
# Setting last_dispatched to `<until> - cadence` makes the schedule next due at
# EXACTLY `<until>`: it is quiet until then, fires once at <until>, re-stamps to
# `now`, and resumes its ordinary cadence. Nothing else in the schedule changes.
# The scheduler only runs a schedule's preflight gate when it is DUE, so a snoozed
# press also runs NO preflight and posts NOTHING until <until> — the pause is total.
#
# Because the effect is the `last_dispatched` field the running scheduler already
# reads every tick, a snooze takes effect immediately on the next scheduler tick
# with no deploy — unlike a new preflight condition, which only bites once it has
# been deployed to the leader's root. That is why "pause until T" is encoded here
# as a stamp move rather than a new gate.
#
# ANCHORED cadences (daily-at-HH:MM-<TZ> / weekly-at-<Day>-HH:MM-<TZ>) fire at a
# fixed wall-clock and decide due-ness from the anchor, not from last_dispatched,
# so a stamp move cannot snooze them to an arbitrary instant; this tool refuses
# them and tells you to adjust the cadence instead.
#
# CAS-races the one-line change onto journal2 via the shared producer clone,
# first-writer-wins, exactly like set-schedule.sh. Idempotent: re-running with the
# same <until> is a no-op ("nothing to commit"). To un-snooze early, just let the
# scheduler fire it, or set a nearer <until>.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
export GARDEN_TAG="snooze-schedule"

name="${1:?usage: snooze-schedule.sh <name> <until>}"
until_spec="${2:?usage: snooze-schedule.sh <name> <until>}"
case "$name" in -*|*/*|.*|'') die "illegal schedule name '$name'";; esac

# cadence -> seconds (interval cadences only; kept in sync with scheduler.sh).
cadence_seconds() {
  case "$1" in
    weekly) echo 604800;; daily) echo 86400;; hourly) echo 3600;;
    *s) echo "${1%s}";; *m) echo $(( ${1%m} * 60 ));; *h) echo $(( ${1%h} * 3600 ));; *d) echo $(( ${1%d} * 86400 ));;
    *) echo 604800;;
  esac
}

now_epoch="$(date -u +%s)"
target_epoch="$(date -u -d "$until_spec" +%s 2>/dev/null)" \
  || die "could not parse <until> '$until_spec' as a date (pass a GNU 'date -d' instant, ideally with an explicit zone/offset)"
[ "$target_epoch" -gt "$now_epoch" ] \
  || die "<until> '$until_spec' ($(date -u -d "@$target_epoch" +%FT%TZ)) is not in the future (now $(date -u -d "@$now_epoch" +%FT%TZ)); refusing to snooze into the past"

DIR="${GARDEN_PRODUCER_CLONE:-$GARDEN_STATE/producer/journal}"
ensure_clone "$DIR"

for attempt in $(seq 1 50); do
  sync_clone "$DIR"
  sf="$DIR/schedules/$name.md"
  [ -f "$sf" ] || die "no schedule schedules/$name.md on journal2 (list: $(ls "$DIR/schedules" 2>/dev/null | tr '\n' ' '))"

  cadence="$(sed -n 's/^cadence:[[:space:]]*//p' "$sf" | head -1)"
  [ -n "$cadence" ] || die "schedule $name has no cadence: line"
  case "$cadence" in
    daily-at-*|weekly-at-*)
      die "schedule $name has an ANCHORED cadence ('$cadence') that fires at a fixed wall-clock; snooze cannot move it. Change the cadence to reschedule it." ;;
  esac
  cad_s="$(cadence_seconds "$cadence")"
  case "$cad_s" in ''|*[!0-9]*) die "unparseable cadence '$cadence' -> '$cad_s'";; esac

  new_last_epoch=$(( target_epoch - cad_s ))
  new_last_iso="$(date -u -d "@$new_last_epoch" +%FT%TZ)"
  old_last="$(sed -n 's/^last_dispatched:[[:space:]]*//p' "$sf" | head -1)"
  if [ "$old_last" = "$new_last_iso" ]; then
    log "schedule $name already snoozed to fire at $(date -u -d "@$target_epoch" +%FT%TZ) (last_dispatched=$new_last_iso); nothing to do"
    echo "schedule '$name' already snoozed until $(date -u -d "@$target_epoch" +%FT%TZ) (next fire)."
    exit 0
  fi

  # Surgically replace only the FIRST last_dispatched line (the schedule's own
  # frontmatter); the body may legitimately contain further '---'/key lines.
  tmp="$sf.snooze.$$"
  sed "0,/^last_dispatched:[[:space:]]*.*/s//last_dispatched: $new_last_iso/" "$sf" > "$tmp"
  grep -q "^last_dispatched: $new_last_iso$" "$tmp" || { rm -f "$tmp"; die "failed to rewrite last_dispatched in $name (no last_dispatched: line?)"; }
  mv "$tmp" "$sf"

  git -C "$DIR" add "schedules/$name.md"
  rc=0; commit_and_push "$DIR" "snooze($name): quiet until $(date -u -d "@$target_epoch" +%FT%TZ) (last_dispatched=$new_last_iso, cadence=$cadence)" || rc=$?
  if [ "$rc" -eq 0 ]; then
    log "snoozed $name: next fire $(date -u -d "@$target_epoch" +%FT%TZ) (last_dispatched set to $new_last_iso; cadence $cadence resumes after)"
    echo "schedule '$name' snoozed: next fire $(date -u -d "@$target_epoch" +%FT%TZ)"
    echo "  (last_dispatched set to $new_last_iso; it resumes its $cadence cadence after that tick)"
    exit 0
  fi
  [ "$rc" -eq 2 ] && { log "schedule $name unchanged"; exit 0; }
  backoff "$attempt"
done
die "could not snooze schedule $name after retries"
