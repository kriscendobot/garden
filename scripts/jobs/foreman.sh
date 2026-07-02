#!/bin/bash
# foreman.sh — the work-in-progress pump: keep the gardener fleet supplied with
# up to GARDEN_FOREMAN_WIP concurrent jobs of milestone work.
#
# Usage: foreman.sh
#
# A timer-driven oneshot. It monitors the job board and, whenever the board is
# BELOW its work-in-progress target (fewer than GARDEN_FOREMAN_WIP jobs in flight)
# and has stayed below it past a settle window, wears the FOREMAN role (via
# `claude -p`) to determine the current in-progress milestone and post ONE job for
# its next most important unblocked step — topping the board up one job per settle
# window until the WIP target is reached. This is the v2, capacity-triggered,
# milestone-aware evolution of the retired general-contractor's slot-refill and
# the v1 design-poller. Part of the garden's autonomous posture: SILENT until an
# error; only the foreman's own failures surface.
#
# Each tick:
#   1. draining check; sync a dedicated journal clone.
#   2. CAPACITY DETECTION. In-flight work is jobs/todo/ + jobs/doin/ (queued plus
#      being worked). The board has CAPACITY whenever that count is below
#      GARDEN_FOREMAN_WIP (default 1 — the historical fully-idle-pump behavior). At
#      or above the target the board is AT CAPACITY: nothing is pumped. The proxy
#      posts follow-on jobs from completions, so the board's in-flight count
#      reflects the milestone's live work chain.
#   3. DEBOUNCE. Act only on SUSTAINED capacity. The first below-target tick
#      records a since marker; a pump fires only once the board has stayed below
#      target for at least GARDEN_FOREMAN_IDLE_SETTLE seconds (so a brief dip
#      between a completion and a follow-on post does not trigger a premature
#      pump). Reaching the WIP target clears the marker.
#   4. On sustained capacity, FIRST prefer promoting the top deferred plan job
#      (jobs/plan/, gate=deferred) by priority/urgency — pre-approved, queued work
#      that costs no `claude -p` call. Only if none exists, hand a small digest
#      (project, board state, last step posted) to the handler (the foreman role)
#      and post the one job it returns. go-ahead plan jobs are never auto-promoted.
#   5. COST GATE: the handler (and its `claude -p`) runs ONLY on sustained
#      below-target capacity, never while the board is at the WIP target or still
#      within the settle window.
#   6. ANTI-FLAP: the last step posted is recorded; if the handler proposes the
#      identical step again (the board redrained without milestone progress) the
#      foreman does NOT blindly re-post it. It surfaces the repeat as a one-line
#      maintainer note so a stuck step is seen rather than silently looped.
#
# State (host-local, outside any reset-prone worktree) lives in
# GARDEN_STATE/foreman/: `idle-since` (the below-target settle clock), `last-step`
# (anti-flap), `noted` (maintainer-note dedupe).
#
# Pluggable for tests: GARDEN_FOREMAN_HANDLER <digest-file> emits one block
# (JOB <base> … ENDJOB, or MAINTAINER … ENDMAINTAINER, or nothing).
# GARDEN_FOREMAN_NOW overrides the clock for deterministic settle-window tests.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
GARDEN_TAG="foreman"

: "${GARDEN_FOREMAN_HANDLER:=$HERE/handlers/foreman-claude.sh}"
# Seconds of sustained below-target capacity before a pump. ~a few minutes; tune
# via env.
: "${GARDEN_FOREMAN_IDLE_SETTLE:=240}"
# Work-in-progress target: how many concurrent jobs (jobs/todo/ + jobs/doin/) the
# foreman keeps the board topped up to. The pump fires only while in-flight work
# is BELOW this number, and posts ONE job per settle window, so the board climbs
# toward the target one step at a time. Default 1 preserves the historical
# fully-idle-pump behavior (pump only when the board is empty); the fleet default
# is raised to 3 in the garden-foreman systemd unit per the maintainer's
# authorization (kriskowal/garden#23).
: "${GARDEN_FOREMAN_WIP:=1}"
: "${GARDEN_FOREMAN_PROJECT:=endo-but-for-bots}"

# Token-quota back-off knobs (defaults declared in usage-meter.sh; restated here so
# the foreman's tunables read together). The foreman pumps spend autonomously, so
# it is the right place to gate on the garden's weekly token budget. The meter is
# sourced from Claude Code's OWN session logs (~/.claude/projects/**/*.jsonl) — the
# whole fleet runs `claude -p` on a single Max x20 SUBSCRIPTION, so the Admin Usage
# & Cost API (API-key/Console only) does NOT apply and is deliberately not wired.
#   GARDEN_TOKEN_WEEKLY_QUOTA     weekly token ceiling; 0/unset = meter OFF (no gating).
#   GARDEN_TOKEN_BACKOFF_FRACTION high-water mark as a fraction of quota (default 0.85).
#   GARDEN_TOKEN_WINDOW_SECS      rolling window in seconds (default 604800 = 7 days).
#   GARDEN_CCUSAGE_LOGDIR         Claude Code session-log dir (primary source).
#   GARDEN_USAGE_LEDGER           legacy ledger path (fallback only).
# At/over the high-water mark the foreman pumps NOTHING this tick and emits at most
# one throttled maintainer note; a broken/unreadable meter fails OPEN (pumps, warns).

fleet_draining && exit 0

DIR="${GARDEN_FOREMAN_CLONE:-$GARDEN_STATE/foreman/journal}"
ensure_clone "$DIR"
sync_clone "$DIR"

STATE="$GARDEN_STATE/foreman"
mkdir -p "$STATE"
IDLE_SINCE="$STATE/idle-since"
LAST_STEP="$STATE/last-step"
NOTED="$STATE/noted"

# Wall clock in epoch seconds, overridable for tests.
now() { printf '%s\n' "${GARDEN_FOREMAN_NOW:-$(date -u +%s)}"; }

# Deliver a one-line maintainer note, deduplicated by <key> so the same concern
# is not re-sent every settle window.
note_once() {
  local key="$1" text="$2" last
  last="$(cat "$NOTED" 2>/dev/null || true)"
  [ "$key" = "$last" ] && return 0
  printf '%s\n' "$text" | GARDEN_SENDER=foreman "$HERE/inbox-send.sh" maintainer
  printf '%s\n' "$key" > "$NOTED"
}

# --- capacity detection ------------------------------------------------------
# In-flight work is the queued (todo) plus being-worked (doin) count. The board
# has capacity to pump while that total is below the WIP target; at or above it
# the board is at capacity and nothing is pumped this tick.
todo_n="$(list_jobs "$DIR" jobs/todo | grep -c . || true)"
doin_n="$(list_jobs "$DIR" jobs/doin | grep -c . || true)"
inflight=$(( todo_n + doin_n ))

if [ "$inflight" -ge "$GARDEN_FOREMAN_WIP" ]; then
  # Board at (or over) the WIP target: clear the settle clock, run no handler,
  # stay silent.
  rm -f "$IDLE_SINCE"
  exit 0
fi

# --- debounce: only act on sustained below-target capacity -------------------
NOW="$(now)"
if [ ! -f "$IDLE_SINCE" ]; then
  printf '%s\n' "$NOW" > "$IDLE_SINCE"   # first below-target observation; start the clock
  exit 0
fi
since="$(cat "$IDLE_SINCE" 2>/dev/null || echo "$NOW")"
elapsed=$(( NOW - since ))
if [ "$elapsed" -lt "$GARDEN_FOREMAN_IDLE_SETTLE" ]; then
  exit 0   # below target but within the settle window; do nothing
fi

# --- token-quota back-off (deterministic; gates BOTH pump paths) --------------
# The board is below the WIP target and past the settle window, so this tick WOULD pump — either
# by promoting a deferred plan job or by generating a new step via `claude -p`.
# Both ignite spend, so check the weekly token meter (plain code, no LLM) FIRST.
# At/over the high-water mark, pump nothing this tick; surface a single throttled
# note so the pause is visible but not spammy. A broken/unset meter fails open.
case "$(meter_quota_status)" in
  backoff)
    note_once "token-backoff" "foreman: garden weekly token usage is at/over the ${GARDEN_TOKEN_BACKOFF_FRACTION} high-water mark of the ${GARDEN_TOKEN_WEEKLY_QUOTA}-token quota (rolling ${GARDEN_TOKEN_WINDOW_SECS}s window). Pausing the autonomous pump until usage falls back under the mark."
    log "token quota high-water reached; backing off (no pump this tick)"
    exit 0
    ;;
  unknown)
    # Quota configured but the meter could not be read. Never wedge the pump on a
    # broken meter — proceed, but warn so the meter gap is visible.
    log "WARN: token-quota meter unreadable though a quota is set; pumping unmetered (fail-open)"
    ;;
  off|ok) : ;;   # no quota configured, or under the mark — pump as normal
esac

# --- sustained below-target: prefer promoting a deferred plan job ------------
# Before generating a NEW step (a `claude -p` call), prefer promoting the top
# already-parked deferred plan job: it is pre-approved work picked by priority, so
# it both honors the maintainer's queue and SAVES the handler's cost. go-ahead
# plan jobs are excluded by plan_deferred_ranked (those need maintainer
# authorization, never auto-selection). Promotion raises the in-flight count, so
# the settle clock clears once the board reaches the WIP target — exactly like a
# normal post.
top_deferred="$(plan_deferred_ranked "$DIR" | head -1)"
if [ -n "$top_deferred" ]; then
  if "$HERE/promote-plan.sh" "$top_deferred" >/dev/null 2>&1; then
    printf '%s\n' "$top_deferred" > "$LAST_STEP"
    : > "$NOTED"   # forward progress clears the maintainer-note dedupe
    log "promoted top deferred plan job '$top_deferred' (preferred over generating a new step)"
    printf '%s\n' "$NOW" > "$IDLE_SINCE"
    exit 0
  fi
  log "failed to promote deferred plan job '$top_deferred'; falling through to handler"
fi

# --- sustained below-target: pump the next milestone step --------------------
last_step="$(cat "$LAST_STEP" 2>/dev/null || true)"

digest="$(mktemp "${TMPDIR:-/tmp}/garden-foreman.XXXXXX")"
{
  printf 'project: %s\n'           "$GARDEN_FOREMAN_PROJECT"
  printf 'board: below WIP target %s (todo=%s doin=%s, in-flight=%s); sustained for %ss\n' "$GARDEN_FOREMAN_WIP" "$todo_n" "$doin_n" "$inflight" "$elapsed"
  printf 'last_step_posted: %s\n'  "${last_step:-(none)}"
} > "$digest"

out="$("$GARDEN_FOREMAN_HANDLER" "$digest" 2>/dev/null || true)"
rm -f "$digest"

# Parse at most one block from the handler output. An optional `ROLE <role>` line
# immediately inside a JOB block names the role the gardener wears (designer,
# builder, …); it is threaded to post-job.sh as --role so the job carries a
# `role:` field and inherits that role's default model (Fable for designer, Opus
# for builder). It is consumed here, not folded into the body.
btype=""; base=""; body=""; role=""
while IFS= read -r line; do
  if   [[ "$line" =~ ^JOB[[:space:]]+(.+)$ ]]; then btype="JOB"; base="${BASH_REMATCH[1]}"; body=""; role=""
  elif [ "$line" = "MAINTAINER" ];             then btype="MAINTAINER"; base=""; body=""; role=""
  elif [ "$line" = "ENDJOB" ] || [ "$line" = "ENDMAINTAINER" ]; then break
  elif [ "$btype" = "JOB" ] && [[ "$line" =~ ^ROLE[[:space:]]+(.+)$ ]]; then role="$(printf '%s' "${BASH_REMATCH[1]}" | tr -d '[:space:]')"
  elif [ -n "$btype" ];                        then body+="$line"$'\n'
  fi
done <<< "$out"

case "$btype" in
  JOB)
    base="$(printf '%s' "$base" | tr -d '[:space:]')"
    if [ -z "$base" ]; then
      log "handler returned an empty JOB base; staying idle"
    elif [ "$base" = "$last_step" ]; then
      # Anti-flap: the same step recurred after the previous post drained without
      # milestone progress. Do not blindly re-post; surface it for review.
      note_once "repeat:$base" "foreman: next step '$base' recurred after the previous post drained without milestone progress. Holding the re-post pending review; it may be stuck."
      log "anti-flap: '$base' repeats last posted step; surfaced to maintainer, not re-posted"
    else
      if [ -n "$role" ]; then
        printf '%s' "$body" | "$HERE/post-job.sh" --role "$role" "$base"
      else
        printf '%s' "$body" | "$HERE/post-job.sh" "$base"
      fi
      printf '%s\n' "$base" > "$LAST_STEP"
      : > "$NOTED"   # forward progress clears the maintainer-note dedupe
      log "pumped next milestone step '$base'"
    fi
    ;;
  MAINTAINER)
    note_once "block:$(printf '%s' "$body" | cksum | awk '{print $1}')" "$body"
    log "next step blocked on a maintainer decision; noted to maintainer inbox"
    ;;
  *)
    log "handler proposed no next step; staying idle"
    ;;
esac

# Reset the settle clock so the next pump is a fresh sustained-below-target window
# away. After a real JOB post the in-flight count rises by one; if that reached the
# WIP target the marker is cleared on the next at-capacity tick, otherwise this
# fresh clock paces the next top-up step. Also matters for the maintainer-note and
# no-op paths, where the board is still below target.
printf '%s\n' "$NOW" > "$IDLE_SINCE"
