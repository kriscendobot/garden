#!/bin/bash
# xs2rust-endor-press-preflight.sh — deterministic preflight gate for the hourly
# `xs2rust-endor-press` schedule (the Fable press-forward driver on PR
# endojs/endo-but-for-bots#600, per kriskowal's 2026-07-03 directive,
# issuecomment-4871559130).
#
# Usage: xs2rust-endor-press-preflight.sh <schedule-name>
#   <schedule-name> is unused here (the gate reads the board, not the stamp); it
#   is passed by the scheduler for symmetry with other preflights.
#
# Wired into schedules/xs2rust-endor-press.md as
# `preflight: gardening/xs2rust-endor-press-preflight.sh`. The scheduler runs this
# when the hourly cadence has elapsed and acts on the exit code:
#   exit 0 = work present → dispatch a fresh press-driver + advance the clock
#   exit 2 = no work      → advance the clock only, dispatch nothing
# (any other exit is treated by the scheduler as work-present — fail open).
#
# The gate exists to satisfy the directive's "ensure progress has been made OR
# redispatch this job" without piling two concurrent press-drivers onto PR #600
# (which would race on the `xs2rust-endor` head branch). The rule is narrow:
#
#   Dispatch a fresh press-driver UNLESS one is ALREADY LIVE on the board
#   (a `xs2rust-endor-press-*` job sitting in jobs/todo/ or jobs/doin/).
#
# It deliberately does NOT gate on the stage-2b build children / orchestration:
# the driver is a supervisor and wakes hourly to CHECK progress (a cheap no-op
# when the chain is advancing), so suppressing its wake while stage-2b runs would
# defeat the "ensure progress has been made" half of the directive. Collision
# avoidance while other xs2rust-endor work is live is handled inside the driver
# body, not here.
#
# Read-only against the board: it reuses common.sh's standing-scan helpers
# (ensure_clone / sync_clone / list_jobs) and never writes or pushes.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../common.sh
source "$HERE/../common.sh"
GARDEN_TAG="xs2rust-endor-press-preflight"

DIR="${GARDEN_XS2RUST_PRESS_PREFLIGHT_CLONE:-$GARDEN_STATE/xs2rust-endor-press-preflight/journal}"
ensure_clone "$DIR"
sync_clone "$DIR"

# A press-driver already live (claimable in todo/ or in-flight in doin/) means
# progress is (or is about to be) in flight — do not dispatch a second one.
for sub in "$JOBS_TODO" "$JOBS_DOIN"; do
  for j in $(list_jobs "$DIR" "$sub"); do
    case "$j" in
      xs2rust-endor-press-*)
        log "no work: press-driver $j already live in $sub; skipping redispatch"
        exit 2
        ;;
    esac
  done
done

log "work present: no live xs2rust-endor-press driver on the board; redispatch"
exit 0
