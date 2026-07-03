#!/bin/bash
# xs2rust-endor-press-preflight.sh — deterministic STALL-BAR gate for the
# `xs2rust-endor-press` schedule (the Fable press-driver on PR
# endojs/endo-but-for-bots#600, branch `xs2rust-endor`, base `llm`, kept DRAFT;
# maintainer @kriskowal 2026-07-03, issuecomment-4871559130).
#
# Usage: xs2rust-endor-press-preflight.sh <schedule-name>
#   <schedule-name> is unused (the gate reads the board + the branch HEAD, not the
#   stamp); it is passed by the scheduler for symmetry with the other preflights.
#
# Wired into schedules/xs2rust-endor-press.md as
# `preflight: gardening/xs2rust-endor-press-preflight.sh`. The scheduler runs it
# when the cadence has elapsed and acts on the exit code (scheduler.sh:158-177):
#   exit 0 = work present → dispatch a fresh press-driver + advance the clock
#   exit 2 = no work      → advance the clock only, dispatch nothing
#   (any other exit is treated as work-present — fail open, never starve.)
#
# Why gate: the press-driver is a SUPERVISOR woken on cadence to check progress.
# When the `xs2rust-endor` chain is HEALTHILY ADVANCING — its branch HEAD is
# moving, or a live build child owns the branch — that driver can only
# observe-and-defer to a no-op: it must not push to a branch another agent is
# actively building (the collision rule in its own charter). The 08:08Z gardener
# entry showed a full Fable tick consumed just to record exactly that no-op ("the
# chain owns the branch and is advancing"). Dispatching a Fable agent to record a
# no-op is pure waste. This gate moves that observe-and-defer judgment into plain
# code so a Fable dispatch is spent ONLY when the chain has genuinely STALLED.
#
# The stall bar — take the wheel (exit 0) only when ALL of these hold:
#   (a) the branch HEAD is UNCHANGED across two consecutive ticks (no push has
#       advanced it since the previous tick — the chain is not moving), AND
#   (b) NO live build child (`xs2rust-endor-build-stage2*`/`-stage3*`) owns the
#       branch — none is in jobs/doin/ and none is alive on the message bus, AND
#   (c) the active stage child (currently `…-stage3-arrays`) is no longer in
#       jobs/doin/ WITHOUT a SUCCESSOR promoted — i.e. no build child sits in
#       jobs/todo/ waiting to be claimed. A successor freshly promoted into
#       todo/ (but not yet claimed into doin/, so it has no inbox yet) means the
#       orchestration is mid-handoff and the chain is about to advance; that is
#       NOT a stall.
# Any of these being FALSE means the chain is advancing or owned → exit 2 (defer,
# dispatch nothing). The predicate in (b)/(c) intentionally covers the whole
# `stage2*`/`stage3*` build family (a superset of the stall bar's named stage3):
# a live stage2 worker owns the branch just as much as a stage3 one, so the
# driver must never take the wheel while EITHER is active.
#
# Fail open on ambiguity: if the branch HEAD cannot be read (a gh/network blip),
# we cannot prove the chain is advancing OR stalled, so we DISPATCH (exit 0) —
# never starve a possibly-stalled chain on a transient. At worst the woken driver
# observes-and-defers, the pre-gate status quo. The very first tick (no prior HEAD
# recorded) also DEFERS: the "unchanged across two consecutive ticks" bar needs a
# baseline observation before it can ever be met.
#
# State: the last-seen branch HEAD is persisted per-host under $GARDEN_STATE
# (outside any reset-prone worktree, uncommitted). Read-only against the board:
# reuses common.sh's clone helpers (ensure_clone / sync_clone / list_jobs) and
# that same clone's inbox/ tree; never writes or pushes to the journal.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../common.sh
source "$HERE/../common.sh"
GARDEN_TAG="xs2rust-endor-press-preflight"

# The PR/branch this gate supervises. Overridable for the test; defaults are the
# live target (endojs/endo-but-for-bots#600, branch xs2rust-endor).
: "${GARDEN_PRESS_REPO:=endojs/endo-but-for-bots}"
: "${GARDEN_PRESS_PR:=600}"
: "${GARDEN_PRESS_BRANCH:=xs2rust-endor}"

DIR="${GARDEN_XS2RUST_PRESS_PREFLIGHT_CLONE:-$GARDEN_STATE/xs2rust-endor-press-preflight/journal}"
STATE_DIR="$GARDEN_STATE/xs2rust-endor-press-preflight"
HEAD_FILE="$STATE_DIR/last-head"

ensure_clone "$DIR"
sync_clone "$DIR"

# --- read the current branch HEAD -------------------------------------------
# Echoes the xs2rust-endor branch HEAD sha, or NOTHING (non-zero) on any failure
# so the caller can fail open. Overridable via GARDEN_PRESS_HEAD_CMD (the test
# substitutes a deterministic fixture); the default reads the PR head sha through
# the fleet's retrying gh wrapper.
read_head() {
  if [ -n "${GARDEN_PRESS_HEAD_CMD:-}" ]; then
    bash -c "$GARDEN_PRESS_HEAD_CMD" 2>/dev/null | head -1 | tr -d '[:space:]'
    return
  fi
  if ! { command -v gh >/dev/null 2>&1 && command -v jq >/dev/null 2>&1; }; then
    log "WARN: gh/jq unavailable; cannot read $GARDEN_PRESS_BRANCH HEAD"; return 1
  fi
  local sha
  sha="$(gh_api_retry "repos/$GARDEN_PRESS_REPO/pulls/$GARDEN_PRESS_PR" --jq '.head.sha' 2>/dev/null || true)"
  [ -n "$sha" ] && [ "$sha" != null ] || return 1
  printf '%s\n' "$sha"
}

# Persist <sha> as the last-seen HEAD (per-host $GARDEN_STATE, uncommitted).
record_head() {
  [ -n "${1:-}" ] || return 0
  mkdir -p "$STATE_DIR"
  printf '%s\n' "$1" > "$HEAD_FILE"
}

cur="$(read_head || true)"
prev="$(head -1 "$HEAD_FILE" 2>/dev/null | tr -d '[:space:]' || true)"

# --- (b) a live build child OWNS the branch → advancing/owned, defer ---------
# A xs2rust-endor-build-stage2*/-stage3* job in jobs/doin/ (a builder actively
# mutating the branch), or a xs2rust-endor-press-* driver already live in
# todo/doin/ (do not stack a second driver). Record HEAD first so the two-tick
# staleness window is always measured against the immediately previous tick.
record_head "$cur"
for j in $(list_jobs "$DIR" "$JOBS_DOIN"); do
  case "$j" in
    xs2rust-endor-build-stage2*|xs2rust-endor-build-stage3*)
      log "no work: build child $j in-flight in doin/ owns $GARDEN_PRESS_BRANCH; defer press-driver"
      exit 2 ;;
    xs2rust-endor-press-*)
      log "no work: press-driver $j already in-flight in doin/; do not stack"
      exit 2 ;;
  esac
done

# (c) a SUCCESSOR build child promoted into jobs/todo/ (not yet claimed into
# doin/, so it carries no inbox) — the orchestration is mid-handoff, the chain is
# about to advance. Also guard against a second press-driver queued in todo/.
for j in $(list_jobs "$DIR" "$JOBS_TODO"); do
  case "$j" in
    xs2rust-endor-build-stage2*|xs2rust-endor-build-stage3*)
      log "no work: successor build child $j queued in todo/ (orchestration mid-handoff); defer press-driver"
      exit 2 ;;
    xs2rust-endor-press-*)
      log "no work: press-driver $j already queued in todo/; do not stack"
      exit 2 ;;
  esac
done

# (b, message bus): the same clone's inbox/ tree (see inbox-list.sh). A live
# inbox for a build child means a peer is alive on the branch right now, even in
# the sliver before/after its doin/ entry settles.
if [ -d "$DIR/inbox" ]; then
  for d in "$DIR"/inbox/*/; do
    [ -d "$d" ] || continue
    base="$(basename "$d")"
    case "$base" in
      xs2rust-endor-build-stage2*|xs2rust-endor-build-stage3*)
        log "no work: build child $base live on the bus owns $GARDEN_PRESS_BRANCH; defer press-driver"
        exit 2 ;;
    esac
  done
fi

# No build child owns the branch and no successor is queued. The remaining
# question is (a): is the branch HEAD moving, or has the chain stalled?

# Ambiguity → fail open (dispatch): a HEAD we could not read cannot prove the
# chain is advancing OR stalled; wake the driver rather than starve a stall.
if [ -z "$cur" ]; then
  log "work present: could not read $GARDEN_PRESS_BRANCH HEAD; dispatching (fail-open, never starve a stall)"
  exit 0
fi

# First observation → establish the baseline and defer; the two-tick bar needs a
# prior tick to compare against.
if [ -z "$prev" ]; then
  log "no work: first HEAD observation ($cur) recorded as baseline; defer until a second tick can prove stall"
  exit 2
fi

# HEAD moved since the previous tick → the chain is advancing under a push; defer.
if [ "$cur" != "$prev" ]; then
  log "no work: $GARDEN_PRESS_BRANCH HEAD advanced ($prev → $cur); chain is advancing; defer press-driver"
  exit 2
fi

# (a) HEAD unchanged across two consecutive ticks, (b) no live build child owns
# the branch, (c) no successor queued → the chain has STALLED. Take the wheel.
log "work present: $GARDEN_PRESS_BRANCH HEAD unchanged across two ticks ($cur), no live build child, no successor queued — chain stalled; dispatch press-driver"
exit 0
