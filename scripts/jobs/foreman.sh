#!/bin/bash
# foreman.sh — the idle-pump service: keep the gardener fleet supplied with work.
#
# Usage: foreman.sh
#
# A timer-driven oneshot. It monitors the job board and, when the board goes
# IDLE and stays idle past a settle window, wears the FOREMAN role (via `claude
# -p`) to determine the current in-progress milestone and post ONE job for its
# next most important unblocked step. This is the v2, idle-triggered,
# milestone-aware evolution of the retired general-contractor's slot-refill and
# the v1 design-poller. Part of the garden's autonomous posture: SILENT until an
# error; only the foreman's own failures surface.
#
# Each tick:
#   1. killswitch check; sync a dedicated journal clone.
#   2. IDLE DETECTION. The board is idle when jobs/todo/ AND jobs/doin/ are both
#      empty (nothing queued, nothing in flight). The proxy posts follow-on jobs
#      from completions, so the board stays busy until the milestone's work chain
#      truly drains; only then is this an idle event worth pumping.
#   3. DEBOUNCE. Act only on SUSTAINED idle. The first idle tick records an
#      idle-since marker; a pump fires only once the board has been idle for at
#      least GARDEN_FOREMAN_IDLE_SETTLE seconds (so a brief gap between a
#      completion and a follow-on post does not trigger a premature pump). A busy
#      board clears the marker.
#   4. On sustained idle, hand a small digest (project, board state, last step
#      posted) to the handler (the foreman role) and post the one job it returns.
#   5. COST GATE: the handler (and its `claude -p`) runs ONLY on sustained idle,
#      never while the board is busy or still within the settle window.
#   6. ANTI-FLAP: the last step posted is recorded; if the handler proposes the
#      identical step again (the board redrained without milestone progress) the
#      foreman does NOT blindly re-post it. It surfaces the repeat as a one-line
#      maintainer note so a stuck step is seen rather than silently looped.
#
# State (host-local, outside any reset-prone worktree) lives in
# GARDEN_STATE/foreman/: `idle-since` (the settle clock), `last-step` (anti-flap),
# `noted` (maintainer-note dedupe).
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
# Seconds of sustained idle before a pump. ~a few minutes; tune via env.
: "${GARDEN_FOREMAN_IDLE_SETTLE:=240}"
: "${GARDEN_FOREMAN_PROJECT:=endo-but-for-bots}"

killswitch_engaged && exit 0

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

# --- idle detection ----------------------------------------------------------
todo_n="$(list_jobs "$DIR" jobs/todo | grep -c . || true)"
doin_n="$(list_jobs "$DIR" jobs/doin | grep -c . || true)"

if [ "$todo_n" -ne 0 ] || [ "$doin_n" -ne 0 ]; then
  # Board busy: clear the settle clock, run no handler, stay silent.
  rm -f "$IDLE_SINCE"
  exit 0
fi

# --- debounce: only act on sustained idle ------------------------------------
NOW="$(now)"
if [ ! -f "$IDLE_SINCE" ]; then
  printf '%s\n' "$NOW" > "$IDLE_SINCE"   # first idle observation; start the clock
  exit 0
fi
since="$(cat "$IDLE_SINCE" 2>/dev/null || echo "$NOW")"
elapsed=$(( NOW - since ))
if [ "$elapsed" -lt "$GARDEN_FOREMAN_IDLE_SETTLE" ]; then
  exit 0   # idle but within the settle window; do nothing
fi

# --- sustained idle: pump the next milestone step ----------------------------
last_step="$(cat "$LAST_STEP" 2>/dev/null || true)"

digest="$(mktemp "${TMPDIR:-/tmp}/garden-foreman.XXXXXX")"
{
  printf 'project: %s\n'           "$GARDEN_FOREMAN_PROJECT"
  printf 'board: idle (todo=0 doin=0); sustained for %ss\n' "$elapsed"
  printf 'last_step_posted: %s\n'  "${last_step:-(none)}"
} > "$digest"

out="$("$GARDEN_FOREMAN_HANDLER" "$digest" 2>/dev/null || true)"
rm -f "$digest"

# Parse at most one block from the handler output.
btype=""; base=""; body=""
while IFS= read -r line; do
  if   [[ "$line" =~ ^JOB[[:space:]]+(.+)$ ]]; then btype="JOB"; base="${BASH_REMATCH[1]}"; body=""
  elif [ "$line" = "MAINTAINER" ];             then btype="MAINTAINER"; base=""; body=""
  elif [ "$line" = "ENDJOB" ] || [ "$line" = "ENDMAINTAINER" ]; then break
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
      printf '%s' "$body" | "$HERE/post-job.sh" "$base"
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

# Reset the settle clock so the next pump is a fresh sustained-idle window away.
# (After a real JOB post the board is non-idle anyway and the marker is cleared
# on the next busy tick; this matters for the maintainer-note and no-op paths.)
printf '%s\n' "$NOW" > "$IDLE_SINCE"
