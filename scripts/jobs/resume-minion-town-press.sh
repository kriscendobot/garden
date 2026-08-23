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
GARDEN_TAG="resume-minion-town-press"

STATE_DIR="$GARDEN_STATE/minion-town-press-preflight"
mkdir -p "$STATE_DIR"
now_iso="$(date -u +%FT%TZ)"
printf '%s\n' "$now_iso" > "$STATE_DIR/resume-watermark"
rm -f "$STATE_DIR/parked-episode" 2>/dev/null || true
log "resume watermark set to $now_iso; the next scheduler tick will dispatch a fresh minion.town press engagement"
echo "minion.town press resumed (resume watermark $now_iso)."
echo "The next scheduler tick dispatches a fresh engagement; the press re-parks if"
echo "the next two ticks again report no next step (kriscendobot/garden#58)."
