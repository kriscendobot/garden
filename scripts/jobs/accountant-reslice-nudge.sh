#!/bin/bash
# accountant-reslice-nudge.sh — the edge-latched re-slice nudge
# (designs/accountant-arc-apportionment.md § How the foreman draws).
#
# The foreman calls this when every arc slice, the unallocated reserve included,
# is held. Exhausted slices never borrow and never spill over; instead, when the
# subscription pools still report unspent quota near their reset, the maintainer
# gets ONE message inviting a mid-week re-slice. The maintainer decides.
#
# Edge-latched: one nudge per held episode (the foreman calls `--clear` once any
# slice has headroom again), and at most one per GARDEN_RESLICE_NUDGE_MIN_GAP
# seconds (default a day) across episodes. Deterministic; no LLM.
#
# Usage: accountant-reslice-nudge.sh --dir SYNCED-JOURNAL [--clear]
# Exit: 0 sent or cleared, 2 nothing to do (latched, too soon, or pools not idle).
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$HERE/common.sh"
export GARDEN_TAG="accountant-reslice-nudge"

: "${GARDEN_RESLICE_NUDGE_MIN_GAP:=86400}"
: "${GARDEN_RESLICE_NUDGE_RESET_WINDOW:=259200}"
dir=""; clear=0
while [ $# -gt 0 ]; do
  case "$1" in
    --dir) dir="${2:?--dir needs a journal directory}"; shift 2 ;;
    --clear) clear=1; shift ;;
    -h|--help) sed -n '2,16p' "$0"; exit 0 ;;
    *) die "unknown argument: '$1'" ;;
  esac
done
[ -n "$dir" ] || die "--dir is required"
now="${GARDEN_RESLICE_NOW:-$(date -u +%s)}"
state="$GARDEN_STATE/accountant"
latch="$state/reslice-latched"
last="$state/reslice-last-sent"
mkdir -p "$state"

if [ "$clear" -eq 1 ]; then
  rm -f "$latch"
  exit 0
fi
[ ! -e "$latch" ] || exit 2
last_sent="$(cat "$last" 2>/dev/null || echo 0)"
[[ "$last_sent" =~ ^[0-9]+$ ]] || last_sent=0
[ $(( now - last_sent )) -ge "$GARDEN_RESLICE_NUDGE_MIN_GAP" ] || exit 2

# Unspent quota near reset: the fleet is not at its high-water mark, and the
# next subscription reset is inside the window. Unknown reset => assume near.
if [ "$(budget_fleet_status "$dir" 2>/dev/null || echo unknown)" = backoff ]; then
  log "every slice is held but the pools are at high water too; no nudge"
  exit 2
fi
reset="${GARDEN_RESLICE_RESET_EPOCH:-$(meter_next_reset_epoch "$now" "$dir" 2>/dev/null || true)}"
if [[ "$reset" =~ ^[0-9]+$ ]] && [ $(( reset - now )) -gt "$GARDEN_RESLICE_NUDGE_RESET_WINDOW" ]; then
  log "every slice is held; reset is $(( (reset - now) / 3600 ))h away, outside the nudge window"
  exit 2
fi

table="$(arc_headroom_lines "$dir" "$now" \
  | awk -F'\t' '{ printf "- %s (rank %s): %s of %s tokens spent (%s)\n", $2, $1, $4, $3, $6 }')"
reset_note="unknown"
[[ "$reset" =~ ^[0-9]+$ ]] && reset_note="$(date -u -d "@$reset" +%FT%TZ)"
body="$(cat <<MSG
accountant: every arc slice of this week's apportionment is held, including the
unallocated reserve, while the subscription pools still have quota that resets
at $reset_note. Unspent quota is lost at the reset.

$table

Say **apportion** or **re-slice** to the liaison to move tokens between arcs or
raise the week's total. Nothing spills over automatically; held plans stay parked
until the next window or a re-slice.
MSG
)"
printf '%s\n' "$body" | GARDEN_SKIP_REF_CHECK=1 GARDEN_SENDER=accountant \
  GARDEN_MSG_ID="accountant-reslice-nudge" "$HERE/inbox-send.sh" maintainer >/dev/null
printf '%s\n' "$now" > "$last"
: > "$latch"
log "sent the re-slice nudge (reset $reset_note)"
