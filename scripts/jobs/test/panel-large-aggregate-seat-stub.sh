#!/bin/bash
# panel-large-aggregate-seat-stub.sh — a GARDEN_PANEL_SEAT hook for
# panel-large-aggregate-decider-test.sh. It emits an approve block padded to
# LARGE_AGG_SEAT_BYTES so the aggregate the decider sees passes 128 KiB.
# Called by panel.sh as: <seat> <pr> <worktree> <base>.
set -uo pipefail
printf 'Verdict: approve\nFindings: none from %s\n\nNotes:\n' "$1"
head -c "${LARGE_AGG_SEAT_BYTES:-100000}" /dev/zero | tr '\0' 'x' | fold -w 100
echo
