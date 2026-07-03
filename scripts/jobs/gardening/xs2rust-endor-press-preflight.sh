#!/bin/bash
# xs2rust-endor-press-preflight.sh — deterministic preflight gate for the
# `xs2rust-endor-press` schedule (the Fable press-driver on PR
# endojs/endo-but-for-bots#600, branch `xs2rust-endor`, base `llm`, kept DRAFT;
# maintainer @kriskowal 2026-07-03, issuecomment-4871559130).
#
# Usage: xs2rust-endor-press-preflight.sh <schedule-name>
#   <schedule-name> is unused (the gate reads the board, not the stamp); it is
#   passed by the scheduler for symmetry with the other preflights.
#
# Wired into schedules/xs2rust-endor-press.md as
# `preflight: gardening/xs2rust-endor-press-preflight.sh`. The scheduler runs it
# when the cadence has elapsed and acts on the exit code (scheduler.sh:108-137):
#   exit 0 = work present → dispatch a fresh press-driver + advance the clock
#   exit 2 = no work      → advance the clock only, dispatch nothing
#   (any other exit is treated as work-present — fail open, never starve.)
#
# Why gate: the press-driver is a SUPERVISOR woken on cadence to check progress.
# When the `xs2rust-endor` branch is already OWNED BY A LIVE WORKER, that driver
# can only observe-and-defer to a no-op — it must not push to a branch another
# agent is actively building (the collision rule in its own charter; see the
# 2026-07-03 05:07Z gardener progress entry, where the hourly driver did exactly
# this). Dispatching a full Fable agent just to record that no-op is pure waste.
# This gate makes the "chain is live → defer" decision in plain code, saving a
# Fable dispatch per idle cadence, and (now that the script exists) silences the
# `WARN ... preflight ... not found/executable` the scheduler logged every tick.
#
# "Owned by a live worker" (ANY of these → exit 2):
#   1. a xs2rust-endor-build-stage2* / xs2rust-endor-build-stage3* job in-flight
#      in jobs/doin/ (a builder is actively mutating the branch), OR
#   2. such a build job live on the message bus — an inbox exists for it, so a
#      peer is alive on the branch right now (same predicate as inbox-list.sh), OR
#   3. a xs2rust-endor-press-* driver already live in jobs/todo/ or jobs/doin/
#      (do not stack a second press-driver on the same branch).
#
# Everything else exits 0 — INCLUDING any ambiguity: a stalled or idle chain (the
# builder died / was reaped out of doin/ and off the bus, the finish line not yet
# met) MUST wake the driver so progress is never starved. Fail open on purpose.
#
# Read-only against the board: reuses common.sh's clone helpers (ensure_clone /
# sync_clone / list_jobs) and that same clone's inbox/ tree; never writes or pushes.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../common.sh
source "$HERE/../common.sh"
GARDEN_TAG="xs2rust-endor-press-preflight"

DIR="${GARDEN_XS2RUST_PRESS_PREFLIGHT_CLONE:-$GARDEN_STATE/xs2rust-endor-press-preflight/journal}"
ensure_clone "$DIR"
sync_clone "$DIR"

# (1) + (3): scan the job board. A build worker in-flight in doin/, or a
# press-driver already live in todo/ or doin/, both mean the work is owned.
for j in $(list_jobs "$DIR" "$JOBS_DOIN"); do
  case "$j" in
    xs2rust-endor-build-stage2*|xs2rust-endor-build-stage3*)
      log "no work: build worker $j in-flight in doin/ (owns xs2rust-endor); defer press-driver"
      exit 2 ;;
    xs2rust-endor-press-*)
      log "no work: press-driver $j already in-flight in doin/; do not stack"
      exit 2 ;;
  esac
done
for j in $(list_jobs "$DIR" "$JOBS_TODO"); do
  case "$j" in
    xs2rust-endor-press-*)
      log "no work: press-driver $j already queued in todo/; do not stack"
      exit 2 ;;
  esac
done

# (2): scan the message bus — the same clone's inbox/ tree (see inbox-list.sh).
# A live inbox for a build stage means a peer is alive on the branch right now,
# even in the sliver before/after its doin/ entry settles.
if [ -d "$DIR/inbox" ]; then
  for d in "$DIR"/inbox/*/; do
    [ -d "$d" ] || continue
    base="$(basename "$d")"
    case "$base" in
      xs2rust-endor-build-stage2*|xs2rust-endor-build-stage3*)
        log "no work: build worker $base live on the bus (owns xs2rust-endor); defer press-driver"
        exit 2 ;;
    esac
  done
fi

log "work present: no live xs2rust-endor worker owns the branch; dispatch press-driver"
exit 0
