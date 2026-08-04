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
#       NOT a stall, AND
#   (d) the FINISH LINE is UNMET — PR #600 is still an OPEN DRAFT. The charter
#       presses the port forward while the PR is DRAFT and STOPS when the finish
#       line (endor-integrated + `test:rust` green + test262 parity) is met, at
#       which point the PR leaves DRAFT for the judge chain (or is merged/closed).
#       A driver woken after that can only observe-and-no-op, so a PR that is
#       MERGED, CLOSED, or has LEFT DRAFT (ready-for-review) is a positive
#       finish-line signal → defer, never dispatch a Fable tick to observe a
#       done/handed-off PR.
# Any of these being FALSE means the chain is advancing, owned, or already
# done/handed-off → exit 2 (defer, dispatch nothing). The predicate in (b)/(c)
# intentionally covers the whole
# `stage2*`/`stage3*` build family (a superset of the stall bar's named stage3):
# a live stage2 worker owns the branch just as much as a stage3 one, so the
# driver must never take the wheel while EITHER is active.
#
# Circuit breaker on a WEDGED campaign: the stall bar alone cannot see that the
# driver it dispatches keeps OVERRUNNING (rc=124, `<!-- garden-deadline-overrun -->`,
# reaper-doomed) at its 2400s wall without ever moving HEAD — so each tick it
# would re-arm the same doomed 2400s Fable driver forever (the "xs2rust-endor-press
# wedge", gardener.sh:586 / reaper.sh:529). To break that loop we persist a per-host
# `consecutive-stall-dispatches` counter beside `last-head`: it INCREMENTS on every
# stall dispatch and RESETS to 0 the moment the chain advances (HEAD moves) or the
# PR reaches a terminal state. When it reaches GARDEN_XS2RUST_PRESS_MAX_STALL_DISPATCHES
# (default 3) — the branch is stalled AND repeated drivers have failed to advance it —
# the gate DEFERS (exit 2) instead of dispatching and raises ONE throttled
# alert_maintainer: the campaign needs a human (split into claim-sized build-stage
# children or run detached, gardener.sh:391) rather than another budget-burning tick.
# The breaker fires only on this positively-observed repeated-stall signature (a
# cleanly-read, unchanged HEAD plus a persisted stall streak); an unreadable HEAD
# still fails open (below) and never trips it.
#
# Fail open on ambiguity: if the branch HEAD cannot be read (a gh/network blip),
# we cannot prove the chain is advancing OR stalled, so we DISPATCH (exit 0) —
# never starve a possibly-stalled chain on a transient. At worst the woken driver
# observes-and-defers, the pre-gate status quo. The very first tick (no prior HEAD
# recorded) also DEFERS: the "unchanged across two consecutive ticks" bar needs a
# baseline observation before it can ever be met. The finish-line guard (d) reads
# in the OPPOSITE, safe direction: it defers ONLY on a positively-read terminal
# PR state (merged/closed/ready), and an unreadable state falls through to the
# stall logic — so a blip there loosens the gate toward dispatch, never toward
# silently skipping a live campaign.
#
# State: the last-seen branch HEAD and the consecutive-stall-dispatch counter are
# persisted per-host under $GARDEN_STATE (outside any reset-prone worktree,
# uncommitted). Read-only against the board:
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

# Circuit-breaker threshold: how many CONSECUTIVE stall-dispatches (each a fresh
# Fable press-driver that woke on a stalled HEAD) we tolerate before concluding
# the campaign is wedged — the branch is not moving AND every dispatched driver
# overruns its handler budget without advancing it — and escalating to a human
# rather than burning another doomed budget. Sanitize a non-numeric override.
: "${GARDEN_XS2RUST_PRESS_MAX_STALL_DISPATCHES:=3}"
case "$GARDEN_XS2RUST_PRESS_MAX_STALL_DISPATCHES" in
  ''|*[!0-9]*) GARDEN_XS2RUST_PRESS_MAX_STALL_DISPATCHES=3 ;;
esac

DIR="${GARDEN_XS2RUST_PRESS_PREFLIGHT_CLONE:-$GARDEN_STATE/xs2rust-endor-press-preflight/journal}"
STATE_DIR="$GARDEN_STATE/xs2rust-endor-press-preflight"
HEAD_FILE="$STATE_DIR/last-head"
# Per-host counter of consecutive stall-dispatches (uncommitted, alongside
# last-head). Incremented on every stall dispatch; reset to 0 the moment the
# chain advances (HEAD moves) or reaches a terminal PR state.
STALL_FILE="$STATE_DIR/consecutive-stall-dispatches"

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

# --- read PR #600's lifecycle state (the finish-line signal) -----------------
# Echoes ONE token — `merged`, `closed`, `ready` (open, left DRAFT), or `draft`
# (open, still DRAFT = actively being pressed) — or NOTHING (non-zero) on any
# failure so the caller falls through to the stall logic rather than skipping.
# Overridable via GARDEN_PRESS_STATE_CMD (the test substitutes a fixture),
# parallel to GARDEN_PRESS_HEAD_CMD; the default reads the PR object once through
# the fleet's retrying gh wrapper. A merged PR reports `merged` even though the
# GitHub `state` is `closed`, so the merged branch is distinguished from an
# abandoned (closed-unmerged) one.
read_pr_state() {
  if [ -n "${GARDEN_PRESS_STATE_CMD:-}" ]; then
    bash -c "$GARDEN_PRESS_STATE_CMD" 2>/dev/null | head -1 | tr -d '[:space:]'
    return
  fi
  if ! { command -v gh >/dev/null 2>&1 && command -v jq >/dev/null 2>&1; }; then
    log "WARN: gh/jq unavailable; cannot read PR #$GARDEN_PRESS_PR state"; return 1
  fi
  local st
  st="$(gh_api_retry "repos/$GARDEN_PRESS_REPO/pulls/$GARDEN_PRESS_PR" \
        --jq 'if (.merged_at // false) then "merged" elif .state=="closed" then "closed" elif (.draft|not) then "ready" else "draft" end' \
        2>/dev/null || true)"
  [ -n "$st" ] && [ "$st" != null ] || return 1
  printf '%s\n' "$st"
}

# Persist <sha> as the last-seen HEAD (per-host $GARDEN_STATE, uncommitted).
record_head() {
  [ -n "${1:-}" ] || return 0
  mkdir -p "$STATE_DIR"
  printf '%s\n' "$1" > "$HEAD_FILE"
}

# Read the consecutive-stall-dispatch counter; an absent or non-numeric file
# reads as 0 (fail toward NOT tripping the breaker).
read_stall_count() {
  local n
  n="$(head -1 "$STALL_FILE" 2>/dev/null | tr -d '[:space:]' || true)"
  case "$n" in ''|*[!0-9]*) printf '0' ;; *) printf '%s' "$n" ;; esac
}
# Persist the counter (per-host $GARDEN_STATE, uncommitted).
record_stall_count() {
  mkdir -p "$STATE_DIR"
  printf '%s\n' "${1:-0}" > "$STALL_FILE"
}

cur="$(read_head || true)"
prev="$(head -1 "$HEAD_FILE" 2>/dev/null | tr -d '[:space:]' || true)"

# --- (b) a live build child OWNS the branch → advancing/owned, defer ---------
# A xs2rust-endor-build-stage2*/-stage3* job in jobs/doin/ (a builder actively
# mutating the branch), or a xs2rust-endor-press-* driver already live in
# todo/doin/ (do not stack a second driver). Record HEAD first so the two-tick
# staleness window is always measured against the immediately previous tick.
record_head "$cur"

# (d) finish-line guard — a MERGED, CLOSED, or LEFT-DRAFT PR means the campaign is
# done or handed to the judge chain; a driver woken now can only observe-and-no-op.
# Read POSITIVELY: only a confirmed terminal state defers here; `draft` (still
# being pressed) and an unreadable state both fall through to the stall logic,
# which fails open. Placed before the board scans so a done PR skips cheapest.
# A terminal state ends the campaign, so the stall streak is meaningless now →
# reset the circuit-breaker counter alongside deferring.
case "$(read_pr_state || true)" in
  merged)
    record_stall_count 0
    log "no work: PR #$GARDEN_PRESS_PR is MERGED; press campaign complete; defer press-driver"
    exit 2 ;;
  closed)
    record_stall_count 0
    log "no work: PR #$GARDEN_PRESS_PR is CLOSED (unmerged); no branch to press; defer press-driver"
    exit 2 ;;
  ready)
    record_stall_count 0
    log "no work: PR #$GARDEN_PRESS_PR left DRAFT (ready for review → judge chain); finish line met; defer press-driver"
    exit 2 ;;
esac

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

# HEAD moved since the previous tick → the chain is advancing under a push; the
# stall streak is broken → reset the circuit-breaker counter and defer.
if [ "$cur" != "$prev" ]; then
  record_stall_count 0
  log "no work: $GARDEN_PRESS_BRANCH HEAD advanced ($prev → $cur); chain is advancing; defer press-driver"
  exit 2
fi

# (a) HEAD unchanged across two consecutive ticks, (b) no live build child owns
# the branch, (c) no successor queued → the chain has STALLED.
#
# CIRCUIT BREAKER — before taking the wheel, check whether the last N dispatches
# ALREADY stalled here without ever advancing HEAD. If the consecutive-stall
# counter has reached the threshold, the driver is proven to overrun its handler
# budget every cadence and advance nothing (the xs2rust-endor-press wedge): stop
# throwing a full Fable budget at it and escalate to a human instead of arming
# another doomed tick. This is the positively-observed repeated-stall signature —
# HEAD read cleanly (we are past the fail-open guard), unchanged across ticks, and
# a persisted streak of prior stall-dispatches — so the breaker never fires on
# ambiguity.
stall_count="$(read_stall_count)"
if [ "$stall_count" -ge "$GARDEN_XS2RUST_PRESS_MAX_STALL_DISPATCHES" ]; then
  log "no work (CIRCUIT BREAKER): $GARDEN_PRESS_BRANCH stalled and $stall_count consecutive press-drivers overran without advancing HEAD ($cur); defer and escalate — needs a human, not another doomed Fable tick"
  alert_maintainer "xs2rust-endor-press-wedged-${GARDEN}" \
    "xs2rust-endor press campaign is WEDGED: PR #$GARDEN_PRESS_PR branch $GARDEN_PRESS_BRANCH HEAD is stuck at $cur and the last $stall_count dispatched press-drivers each overran their handler budget (rc=124, reaper-doomed) without advancing it. The stall-bar preflight has tripped its circuit breaker (GARDEN_XS2RUST_PRESS_MAX_STALL_DISPATCHES=$GARDEN_XS2RUST_PRESS_MAX_STALL_DISPATCHES) and STOPPED dispatching, so it is no longer burning a Fable budget every cadence. This needs a human: split the press into claim-sized build-stage children or run it detached (gardener.sh:391 doctrine) rather than as a repeatedly-doomed cadence tick. The breaker resets automatically once $GARDEN_PRESS_BRANCH HEAD advances or PR #$GARDEN_PRESS_PR reaches a terminal state."
  exit 2
fi

# Under the threshold → take the wheel and count this stall dispatch.
record_stall_count "$(( stall_count + 1 ))"
log "work present: $GARDEN_PRESS_BRANCH HEAD unchanged across two ticks ($cur), no live build child, no successor queued — chain stalled; dispatch press-driver (consecutive stall dispatch $(( stall_count + 1 )) of $GARDEN_XS2RUST_PRESS_MAX_STALL_DISPATCHES)"
exit 0
