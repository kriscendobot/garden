#!/bin/bash
# foreman.sh — the active-job pump: keep the gardener fleet supplied with a TARGET
# number (GARDEN_FOREMAN_ACTIVE_TARGET, default 3) of concurrently-progressing
# jobs of milestone work.
#
# Usage: foreman.sh
#
# A timer-driven oneshot. It monitors the job board and, whenever the board is
# UNDER-SUBSCRIBED (fewer than GARDEN_FOREMAN_ACTIVE_TARGET jobs in flight) and has
# stayed below it past a settle window, fills the open slots: first by batch-
# promoting cheap pre-approved deferred plan jobs (up to TARGET - in-flight in one
# tick), then, only if no deferred plan is queued, by wearing the FOREMAN role (via
# `claude -p`) to post ONE job for the milestone's next unblocked step. Generated
# steps are paced one per settle window; pre-approved deferred jobs fill in a
# single tick. This is the v2, capacity-triggered, milestone-aware evolution of the
# retired general-contractor's slot-refill and the v1 design-poller. Part of the
# garden's autonomous posture: SILENT until an error; only the foreman's own
# failures surface.
#
# Each tick:
#   1. draining check; sync a dedicated journal clone.
#   2. CAPACITY DETECTION. In-flight work is jobs/todo/ + jobs/doin/ (queued plus
#      being worked). The board is UNDER-SUBSCRIBED whenever that count is below
#      GARDEN_FOREMAN_ACTIVE_TARGET (default 3). At or above the target the board is
#      FULLY SUBSCRIBED: nothing is pumped. The proxy posts follow-on jobs from
#      completions, so the board's in-flight count reflects the milestone's live
#      work chain.
#   3. DEBOUNCE. Act only on SUSTAINED under-subscription. The first below-target
#      tick records a since marker; a pump fires only once the board has stayed
#      below target for at least GARDEN_FOREMAN_IDLE_SETTLE seconds (so a brief dip
#      between a completion and a follow-on post does not trigger a premature
#      pump). Reaching the target clears the marker.
#   4. On sustained under-subscription, FIRST batch-promote the top deferred plan
#      jobs (jobs/plan/, gate=deferred) by priority/urgency — up to TARGET minus
#      in-flight this tick — pre-approved, queued work that costs no `claude -p`
#      call. Only if NONE is queued, hand a small digest (project, board state,
#      last step posted) to the handler (the foreman role) and post the one job it
#      returns. go-ahead and blocked plan jobs are never auto-promoted.
#   5. COST GATE: the handler (and its `claude -p`) runs ONLY on sustained
#      under-subscription, never while the board is at the target or still within
#      the settle window.
#   6. ANTI-FLAP: the last step posted is recorded; if the handler proposes the
#      identical step again (the board redrained without milestone progress) the
#      foreman does NOT blindly re-post it. It surfaces the repeat as a one-line
#      maintainer note so a stuck step is seen rather than silently looped.
#
# State (host-local, outside any reset-prone worktree) lives in
# GARDEN_STATE/foreman/: `idle-since` (the below-target settle clock), `last-step`
# (anti-flap), `noted` (maintainer-note dedupe), `notice-sig` (the substance
# signature of the last milestone/bottleneck maintainer notice, so a stalled board
# posts that notice ONCE per distinct state, not every tick — mirroring
# identity-drift-guard.sh's per-signature dedup).
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
# Active-job TARGET: how many concurrent jobs (jobs/todo/ + jobs/doin/) the foreman
# keeps actively progressing. The pump fires while in-flight work is BELOW this
# number (the board is UNDER-SUBSCRIBED) and has stayed below it past the settle
# window — not only when the board is fully idle. On a sustained-under tick it
# fills the open slots up to the target: it batch-promotes cheap pre-approved
# deferred plan jobs (up to TARGET - in-flight in ONE tick), and falls through to
# generating ONE new milestone step via the handler only when no deferred plan is
# queued. Default 5 keeps ~5 jobs in flight (kriskowal, 2026-07-03).
# GARDEN_FOREMAN_WIP is the deprecated former name for this knob, still honored as
# an alias so an env/unit that sets it keeps working.
: "${GARDEN_FOREMAN_ACTIVE_TARGET:=${GARDEN_FOREMAN_WIP:-5}}"
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

DIR="${GARDEN_FOREMAN_CLONE:-$GARDEN_STATE/foreman/journal}"
ensure_clone "$DIR"
sync_clone "$DIR"

# The foreman has its OWN brake, independent of the fleet drain (job
# garden-foreman-independent-brake). foreman_braked is true when EITHER the fleet
# is draining (the drain keeps stopping the foreman, unchanged) OR the journal-
# backed foreman brake (GARDEN_FOREMAN_BRAKE_PATH) is set — which stops ONLY the
# foreman, so gardeners keep claiming while the pump is silenced. This is the sole
# call site that changed from fleet_draining; the brake is read from the clone we
# just synced, and sync_clone has already exited the tick if the journal was
# unreadable, so the pump never fires on a journal it could not read (fail-safe).
foreman_braked "$DIR" && exit 0

STATE="$GARDEN_STATE/foreman"
mkdir -p "$STATE"
IDLE_SINCE="$STATE/idle-since"
LAST_STEP="$STATE/last-step"
NOTED="$STATE/noted"
# Substance signature of the last milestone/bottleneck maintainer notice posted.
# Lives under $GARDEN_STATE (per-host, outside any reset-prone worktree), exactly
# like identity-drift-guard.sh's drift marker.
NOTICE_SIG="$STATE/notice-sig"

# Wall clock in epoch seconds, overridable for tests.
now() { printf '%s\n' "${GARDEN_FOREMAN_NOW:-$(date -u +%s)}"; }

# Deliver a one-line maintainer note, deduplicated by <key> so the same concern
# is not re-sent every settle window.
note_once() {
  local key="$1" text="$2" last
  last="$(cat "$NOTED" 2>/dev/null || true)"
  [ "$key" = "$last" ] && return 0
  printf '%s\n' "$text" | GARDEN_SKIP_REF_CHECK=1 GARDEN_SENDER=foreman "$HERE/inbox-send.sh" maintainer
  printf '%s\n' "$key" > "$NOTED"
}

# Compute a stable signature of a milestone/bottleneck notice's SUBSTANCE — the
# milestone ids (M2, M3, …) and PR/issue numbers (#719, #263, …) it references —
# independent of the varying PROSE the `claude -p` handler generates. Two ticks
# describing the same underlying board state yield the SAME signature (the tokens
# are normalized, de-duplicated, and sorted, so phrasing and token order do not
# matter); a new/closed PR or an advancing milestone changes the token set and so
# the signature. This is why the drift-guard-style dedup keys on substance, not on
# a `cksum` of the reworded prose (which changed every tick and flooded the inbox).
# A notice that names no milestone or PR has no substance handle, so we fall back
# to a prose cksum for it — identical prose still dedups, and such token-less
# notices are the rare case.
notice_signature() {
  local body="$1" sig
  sig="$(printf '%s\n' "$body" \
    | grep -oE '\b[Mm][0-9]+\b|#[0-9]+' 2>/dev/null \
    | tr '[:lower:]' '[:upper:]' | sort -u | paste -sd, - || true)"
  if [ -z "$sig" ]; then
    sig="prose:$(printf '%s' "$body" | cksum | awk '{print $1}')"
  fi
  printf '%s\n' "$sig"
}

# Post the milestone/bottleneck maintainer notice at most ONCE per distinct
# substance signature, recorded in the $NOTICE_SIG marker under $GARDEN_STATE —
# exactly like identity-drift-guard.sh posts its report once per distinct drift
# signature. An unchanged state (same signature as last posted) posts NOTHING; a
# genuinely new decision (a new/closed PR, an advancing milestone) changes the
# signature and fires exactly once, then goes quiet again.
note_milestone_once() {
  local body="$1" sig prev
  sig="$(notice_signature "$body")"
  prev="$(cat "$NOTICE_SIG" 2>/dev/null || true)"
  if [ "$sig" = "$prev" ]; then
    log "milestone/bottleneck notice unchanged (sig=$sig); not re-posting"
    return 0
  fi
  printf '%s\n' "$body" | GARDEN_SKIP_REF_CHECK=1 GARDEN_SENDER=foreman "$HERE/inbox-send.sh" maintainer
  printf '%s\n' "$sig" > "$NOTICE_SIG"
  log "posted milestone/bottleneck notice to maintainer inbox (sig=$sig)"
}

# --- capacity detection ------------------------------------------------------
# In-flight work is the queued (todo) plus being-worked (doin) count. The board
# has capacity to pump while that total is below the active-job target; at or
# above it the board is fully subscribed and nothing is pumped this tick.
todo_n="$(list_jobs "$DIR" jobs/todo | grep -c . || true)"
doin_n="$(list_jobs "$DIR" jobs/doin | grep -c . || true)"
inflight=$(( todo_n + doin_n ))

if [ "$inflight" -ge "$GARDEN_FOREMAN_ACTIVE_TARGET" ]; then
  # Board at (or over) the active-job target: clear the settle clock, run no
  # handler, stay silent.
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

# --- token-quota back-off (deterministic; gates a Claude-only pump) -----------
# The board is below the active-job target and past the settle window, so this tick WOULD pump — either
# by promoting a deferred plan job or by generating a new step via `claude -p`.
# Both can eventually ignite spend. The historical meter measures the Claude Max
# subscription only, so when the operational foreman order includes OpenAI or the
# local Ollama route it must not suppress those fallbacks before the handler gets a
# chance to try them. The handler applies the same Claude quota verdict only when
# it reaches anthropic, then advances to the next provider. A custom test handler
# retains the historical global gate because its provider semantics are unknown.
provider_fallback_enabled=false
if [ "$GARDEN_FOREMAN_HANDLER" = "$HERE/handlers/foreman-claude.sh" ]; then
  case ",${GARDEN_FOREMAN_PROVIDER_ORDER:-anthropic}," in *,openai,*|*,local,*) provider_fallback_enabled=true ;; esac
fi
if [ "$provider_fallback_enabled" = false ]; then case "$(meter_quota_status)" in
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
esac; fi

# --- sustained below-target: fill the open slots from deferred plan jobs ------
# Before generating a NEW step (a `claude -p` call), fill the open slots with
# already-parked deferred plan jobs: they are pre-approved work picked by
# priority, so promoting them both honors the maintainer's queue and SAVES the
# handler's cost. go-ahead plan jobs are excluded by plan_deferred_ranked (those
# need maintainer authorization, never auto-selection); blocked plan jobs are
# likewise excluded (they wait for the unblock watcher on their blocker).
#
# Batch, not one-per-tick: we promote up to (TARGET - in-flight) deferred jobs in
# THIS tick, so a board that is under-subscribed by more than one comes up to the
# target within a single settle window rather than one window per slot. This is
# safe for the settle-window semantics because a deferred promotion is a cheap,
# pre-approved move (no `claude -p`); the settle window still gates the FIRST
# promotion (we only get here on sustained under-subscription), and only the
# handler path below — which mints genuinely NEW work — stays paced at one step
# per tick. Each promotion raises the in-flight count, so once the board reaches
# the target the next tick clears the settle clock — exactly like a normal post.
slots=$(( GARDEN_FOREMAN_ACTIVE_TARGET - inflight ))
promoted=0
while [ "$promoted" -lt "$slots" ]; do
  top_deferred="$(plan_deferred_ranked "$DIR" | head -1)"
  [ -n "$top_deferred" ] || break   # no more deferred plan jobs queued this tick
  if "$HERE/promote-plan.sh" "$top_deferred" >/dev/null 2>&1; then
    promoted=$(( promoted + 1 ))
    printf '%s\n' "$top_deferred" > "$LAST_STEP"
    log "promoted deferred plan job '$top_deferred' ($promoted/$slots toward active-job target $GARDEN_FOREMAN_ACTIVE_TARGET)"
    sync_clone "$DIR"   # reflect the promotion so the next pick sees it gone from plan/
  else
    log "failed to promote deferred plan job '$top_deferred'; stopping deferred promotion this tick"
    break
  fi
done
if [ "$promoted" -gt 0 ]; then
  : > "$NOTED"           # forward progress clears the maintainer-note dedupe
  rm -f "$NOTICE_SIG"    # …and the milestone-notice dedupe: a bottleneck that
                         # recurs after real progress is a new state, worth one note
  printf '%s\n' "$NOW" > "$IDLE_SINCE"
  exit 0
fi
# No deferred plan job was available; fall through to generate one new step.

# --- sustained below-target: pump the next milestone step --------------------
last_step="$(cat "$LAST_STEP" 2>/dev/null || true)"

digest="$(mktemp "${TMPDIR:-/tmp}/garden-foreman.XXXXXX")"
{
  printf 'project: %s\n'           "$GARDEN_FOREMAN_PROJECT"
  printf 'board: below active-job target %s (todo=%s doin=%s, in-flight=%s); sustained for %ss\n' "$GARDEN_FOREMAN_ACTIVE_TARGET" "$todo_n" "$doin_n" "$inflight" "$elapsed"
  printf 'last_step_posted: %s\n'  "${last_step:-(none)}"
} > "$digest"

# Capture the handler's stderr and rc EXPLICITLY. The old `2>/dev/null || true`
# made a permanently broken handler (claude not on PATH, an auth failure, a
# crash) indistinguishable from a healthy "no next step": the pump starved
# silently forever, every settle window, with nothing in the logs — while the
# header above promises the foreman's own failures surface. A handler failure
# now WARNs with the stderr tail and (throttled) alerts the maintainer; the
# tick still idles rather than crashing, since a broken pump must not take the
# rest of the foreman down with it.
herrf="$(mktemp "${TMPDIR:-/tmp}/garden-foreman-err.XXXXXX")"
hrc=0
out="$("$GARDEN_FOREMAN_HANDLER" "$digest" 2>"$herrf")" || hrc=$?
if [ "$hrc" -ne 0 ]; then
  log "WARN: foreman handler failed rc=$hrc: $(tail -c 500 "$herrf" 2>/dev/null || echo '<no stderr>')"
  alert_maintainer "foreman-handler-failed-$GARDEN" \
    "garden-foreman's pump handler ($GARDEN_FOREMAN_HANDLER) failed rc=$hrc on $GARDEN; the board pump is starving. stderr tail: $(tail -c 500 "$herrf" 2>/dev/null)"
  out=""
fi
rm -f "$digest" "$herrf"

# Parse at most one block from the handler output. An optional `ROLE <role>` line
# immediately inside a JOB block names the role the gardener wears (designer,
# builder, …); it is threaded to post-job.sh as --role so the job carries a
# `role:` field and inherits that role's default model (Opus for designer, Opus
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
      : > "$NOTED"           # forward progress clears the maintainer-note dedupe
      rm -f "$NOTICE_SIG"    # …and the milestone-notice dedupe (real work resumed)
      log "pumped next milestone step '$base'"
    fi
    ;;
  MAINTAINER)
    # Dedup on the notice's SUBSTANCE signature, not the reworded prose: a board
    # stalled on the same decision re-emits a near-identical notice every tick, and
    # keying on a `cksum` of that varying prose re-posted every time (the inbox
    # flood this fixes). note_milestone_once posts once per distinct state.
    note_milestone_once "$body"
    log "next step blocked on a maintainer decision; noted to maintainer inbox (dedup by substance)"
    ;;
  *)
    log "handler proposed no next step; staying idle"
    ;;
esac

# Reset the settle clock so the next pump is a fresh sustained-below-target window
# away. After a real JOB post the in-flight count rises by one; if that reached the
# active-job target the marker is cleared on the next at-capacity tick, otherwise this
# fresh clock paces the next top-up step. Also matters for the maintainer-note and
# no-op paths, where the board is still below target.
printf '%s\n' "$NOW" > "$IDLE_SINCE"
