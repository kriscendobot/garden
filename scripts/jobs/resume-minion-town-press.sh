#!/bin/bash
# resume-minion-town-press.sh — un-stick a PARKED minion.town press.
#
# The `minion-town-agenda-review` press parks itself (dispatches nothing) once its
# two most-recent ticks both report `press-status: no-next-step` — the "no next
# steps twice" rule from kriscendobot/garden#58 (kriskowal, 2026-08-23). That park
# is STICKY: while parked no new tick runs, so the two frozen idle reports would
# keep it parked forever. This tool is the deliberate maintainer RESUME.
#
# It writes a per-host RESUME WATERMARK (now) that minion-town-press-preflight.sh
# honours: press tada reports at/older than the watermark are ignored for the idle
# streak, so the next scheduler tick dispatches a fresh press engagement instead of
# re-parking on the stale reports. It also clears the park-episode marker so a
# subsequent park pages the maintainer again. If the next two engagements once more
# find no next step, the press re-parks — this only clears the CURRENT stall.
#
# A maintainer may also resume while a time-boxed snooze is still active. A snooze
# is represented by a FUTURE last_dispatched stamp, so the resume CAS-rewinds that
# stamp by one cadence and makes the press due on the next scheduler tick. It only
# rewinds a future stamp: an ordinary, already-running schedule is left alone, so a
# resume racing a real dispatch cannot manufacture a duplicate tick.
#
# The BUDGET park (half the weekly quota spent on the press) is self-recovering as
# spend ages out of the trailing window and needs no resume; this tool does not
# override it (a fresh tick still re-checks budget).
#
# Run on the LEADER host (the scheduler that reads this per-host state is a
# leader-only singleton). Usage: resume-minion-town-press.sh
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
export GARDEN_TAG="resume-minion-town-press"

SCHEDULE="minion-town-agenda-review"

cadence_seconds() {
  case "$1" in
    weekly) echo 604800;; daily) echo 86400;; hourly) echo 3600;;
    *s) echo "${1%s}";;
    *m) echo $(( ${1%m} * 60 ));;
    *h) echo $(( ${1%h} * 3600 ));;
    *d) echo $(( ${1%d} * 86400 ));;
    *) return 1;;
  esac
}

STATE_DIR="$GARDEN_STATE/minion-town-press-preflight"
mkdir -p "$STATE_DIR"
now_iso="$(date -u +%FT%TZ)"
printf '%s\n' "$now_iso" > "$STATE_DIR/resume-watermark"
rm -f "$STATE_DIR/parked-episode" 2>/dev/null || true

# End a still-active interval snooze. Put the watermark in place first so a
# scheduler tick that observes the journal update cannot re-park on stale idle
# reports in the small interval before this process exits.
DIR="${GARDEN_PRODUCER_CLONE:-$GARDEN_STATE/producer/journal}"
ensure_clone "$DIR"
resumed=0
for attempt in $(seq 1 50); do
  sync_clone "$DIR"
  sf="$DIR/schedules/$SCHEDULE.md"
  [ -f "$sf" ] || die "no schedule schedules/$SCHEDULE.md on journal2"

  cadence="$(sed -n 's/^cadence:[[:space:]]*//p' "$sf" | head -1)"
  cad_s="$(cadence_seconds "$cadence")" \
    || die "schedule $SCHEDULE has unsupported cadence '$cadence'; resume watermark was set, but an active snooze could not be ended"
  case "$cad_s" in ''|*[!0-9]*) die "unparseable cadence '$cadence' -> '$cad_s'";; esac

  last="$(sed -n 's/^last_dispatched:[[:space:]]*//p' "$sf" | head -1)"
  last_epoch="$(date -u -d "$last" +%s 2>/dev/null)" \
    || die "schedule $SCHEDULE has unparseable last_dispatched '$last'"
  now_epoch="$(date -u +%s)"

  # Only a future stamp is a live interval snooze. Never rewind a normal stamp:
  # a concurrent scheduler may just have written it after dispatching real work.
  if [ "$last_epoch" -le "$now_epoch" ]; then
    resumed=1
    break
  fi

  new_last_iso="$(date -u -d "@$(( now_epoch - cad_s ))" +%FT%TZ)"
  tmp="$sf.resume.$$"
  sed "0,/^last_dispatched:[[:space:]]*.*/s//last_dispatched: $new_last_iso/" "$sf" > "$tmp"
  grep -q "^last_dispatched: $new_last_iso$" "$tmp" \
    || { rm -f "$tmp"; die "failed to rewrite last_dispatched in $SCHEDULE"; }
  mv "$tmp" "$sf"

  git -C "$DIR" add "schedules/$SCHEDULE.md"
  rc=0
  commit_and_push "$DIR" "resume($SCHEDULE): end active snooze" || rc=$?
  if [ "$rc" -eq 0 ] || [ "$rc" -eq 2 ]; then
    log "ended active snooze for $SCHEDULE; next scheduler tick is due"
    resumed=1
    break
  fi
  backoff "$attempt"
done
[ "$resumed" -eq 1 ] || die "could not end active snooze for $SCHEDULE after retries"

log "resume watermark set to $now_iso; the next scheduler tick will dispatch a fresh minion.town press engagement"
echo "minion.town press resumed (resume watermark $now_iso)."
echo "The next scheduler tick dispatches a fresh engagement; the press re-parks if"
echo "the next two ticks again report no next step (kriscendobot/garden#58)."
