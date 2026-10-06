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
#      returns. The digest includes config/foreman-mandate when that journal file
#      is non-empty. go-ahead, awaiting-maintainer, and blocked plan jobs are
#      never auto-promoted.
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
# (anti-flap), `noted` (maintainer-note dedupe), `notice-seen/<milestones>` (the
# PR/issue refs already surfaced in a milestone/bottleneck maintainer notice, so a
# stalled milestone notifies once per NEW blocker, not every tick or every
# rewording), `provider-outage-cooldown` (the live handler's bounded all-routes
# outage latch), and `decisions.log` (a durable,
# self-trimming per-tick DECISION record: one line per tick giving inflight,
# target, and the guard/branch that ended it — added after the "malingering
# foreman" investigation, job investigate-malingering-foreman 2026-09-16, found a
# quiesced foreman — GARDEN_FOREMAN_ACTIVE_TARGET=0 — exiting 0 every tick with NO
# trace, diagnosable only by live-debugging the running unit).
#
# Pluggable for tests: GARDEN_FOREMAN_HANDLER <digest-file> emits one block
# (JOB <base> … ENDJOB, or MAINTAINER … ENDMAINTAINER, or nothing).
# GARDEN_FOREMAN_NOW overrides the clock for deterministic settle-window tests.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
export GARDEN_TAG="foreman"

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
# sourced from Claude Code's OWN session logs (~/.claude/projects/**/*.jsonl), one
# independent account per host. The Admin Usage & Cost API (API-key/Console only)
# does NOT apply and is deliberately not wired.
#   config/budget-pools          per-subscription ceiling (journal source of truth).
#   config/token-backoff-fraction journal high-water fraction (when env is unset).
#   config/foreman-mandate       optional free-text priority direction for generation.
#   config/subscription-mapping  explicit host/worker-kind ownership relation.
#   GARDEN_TOKEN_WEEKLY_QUOTA    fallback when no current-host pool row exists.
#   GARDEN_TOKEN_BACKOFF_FRACTION high-water mark as a fraction of quota (default 0.85).
#   budget/reset-events/*         independent reset facts; no global default.
#   GARDEN_CCUSAGE_LOGDIR         Claude Code session-log dir (primary source).
#   GARDEN_USAGE_LEDGER           legacy ledger path (fallback only).
# At/over the high-water mark the foreman pumps NOTHING this tick and emits at most
# one throttled maintainer note; a broken/unreadable meter fails OPEN (pumps, warns).

DIR="${GARDEN_FOREMAN_CLONE:-$GARDEN_STATE/foreman/journal}"
ensure_clone "$DIR"
sync_clone "$DIR"

STATE="$GARDEN_STATE/foreman"
mkdir -p "$STATE"
IDLE_SINCE="$STATE/idle-since"
LAST_STEP="$STATE/last-step"
NOTED="$STATE/noted"
# Per-milestone record of the refs already surfaced in a milestone/bottleneck
# maintainer notice (one file per milestone key; see note_milestone_once). Lives
# under $GARDEN_STATE (per-host, outside any reset-prone worktree).
NOTICE_SEEN="$STATE/notice-seen"
# Seconds a milestone's seen-set stays authoritative. Past it, the next notice for
# that milestone is delivered even with no new ref: a once-a-day reminder of a
# still-stalled decision, amended into the same inbox entry.
: "${GARDEN_FOREMAN_NOTICE_TTL:=86400}"
# Durable per-tick DECISION record. Every tick appends ONE line saying how it
# resolved: the inflight count, the active-job target, the guard/branch that
# ended the tick, and any detail (what was promoted/pumped). This closes the gap
# the "malingering foreman" investigation (job investigate-malingering-foreman,
# 2026-09-16) hit: a tick that exits 0 having pumped nothing — because the
# active-job target is 0 (the fleet-wide quiesce), a budget back-off fired, or
# the settle clock has not elapsed — otherwise leaves NO durable trace, so a
# board sitting under-target for weeks could only be diagnosed by live-debugging
# the running unit. Host-local under $GARDEN_STATE (NOT the journal: a line every
# 5 min would be needless journal churn), self-trimming so an idle host never
# grows it without bound. Best-effort — a logging failure must never fail a tick.
DECISIONS="$STATE/decisions.log"
decide() {
  local guard="$1" detail="${2:-}"
  { printf '%s inflight=%s target=%s guard=%s%s\n' \
      "$(date -u +%Y-%m-%dT%H:%M:%SZ)" "${inflight:-?}" \
      "${GARDEN_FOREMAN_ACTIVE_TARGET:-?}" "$guard" "${detail:+ $detail}" \
      >> "$DECISIONS"; } 2>/dev/null || true
  local n; n="$(wc -l < "$DECISIONS" 2>/dev/null || echo 0)"
  if [ "${n:-0}" -gt 1200 ]; then
    { tail -n 1000 "$DECISIONS" > "$DECISIONS.tmp" && mv "$DECISIONS.tmp" "$DECISIONS"; } 2>/dev/null || true
  fi
}

record_budget_halt() { # sensor status reason detail
  local sensor="$1" status="$2" reason="$3" detail="$4" decision_input_json
  if decision_input_json="$(jq -cn --arg host "$GARDEN" --arg sensor "$sensor" \
    --arg status "$status" --argjson inflight "${inflight:-0}" \
    --argjson target "$GARDEN_FOREMAN_ACTIVE_TARGET" \
    '{host:$host,sensor:$sensor,status:$status,inflight:$inflight,target:$target}')"; then
    record_decision --loop foreman --input-json "$decision_input_json" \
      --decision halt-pump --reason "$reason" --outcome applied \
      --outcome-detail "$detail"
  fi
}

# The foreman has its OWN brake, independent of the fleet drain (job
# garden-foreman-independent-brake). foreman_braked is true when EITHER the fleet
# is draining (the drain keeps stopping the foreman, unchanged) OR the journal-
# backed foreman brake (GARDEN_FOREMAN_BRAKE_PATH) is set — which stops ONLY the
# foreman, so gardeners keep claiming while the pump is silenced. This is the sole
# call site that changed from fleet_draining; the brake is read from the clone we
# just synced, and sync_clone has already exited the tick if the journal was
# unreadable, so the pump never fires on a journal it could not read (fail-safe).
foreman_braked "$DIR" && { decide braked; exit 0; }

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

# Milestone/bottleneck maintainer notices are keyed by MILESTONE and gated on NEW
# refs, not on a signature of the whole notice. The handler's `claude -p` prose
# varies which PRs it names for the same static board (2026-09-27/28: M2 stalled on
# green drafts #1349 and #1356 produced 25 notices over nine hours, alternating
# {#1349,M2}, {#1349,#1356,M2}, {#1356,M2}), so an exact-set signature re-fired on
# every change of subset and every A→B→A flip. Instead:
#   - the key is the notice's milestone ids (`M2`, or `M2-M3`); a notice naming no
#     milestone keys to `general`;
#   - the key's seen-set accumulates every #ref delivered under it; a notice is
#     delivered only when it names a ref NOT yet seen (a genuinely new blocker), or
#     when the seen-set is absent or older than GARDEN_FOREMAN_NOTICE_TTL;
#   - delivery is inbox-send.sh's coalescing mode keyed `foreman-milestone-<key>`,
#     so even a delivered notice amends the milestone's ONE open unread entry
#     (notice_count, latest body) rather than adding a file.
# A `general` notice with no refs uses a prose cksum as its ref, so identical prose
# stays quiet and a reworded one amends the single `general` entry.
notice_milestone_key() {
  local ms
  ms="$(printf '%s\n' "$1" | grep -oE '\b[Mm][0-9]+\b' 2>/dev/null \
    | tr '[:lower:]' '[:upper:]' | sort -u | paste -sd- - || true)"
  printf '%s\n' "${ms:-general}"
}

notice_refs() {
  printf '%s\n' "$1" | grep -oE '#[0-9]+' 2>/dev/null | sort -u || true
}

note_milestone_once() {
  local body="$1" key refs seen stamp age fresh=""
  key="$(notice_milestone_key "$body")"
  refs="$(notice_refs "$body")"
  if [ -z "$refs" ] && [ "$key" = general ]; then
    refs="prose:$(printf '%s' "$body" | cksum | awk '{print $1}')"
  fi
  seen="$NOTICE_SEEN/$key"
  stamp="$(head -1 "$seen" 2>/dev/null || true)"
  [[ "$stamp" =~ ^[0-9]+$ ]] || stamp=""
  if [ -n "$stamp" ]; then
    age=$(( $(now) - stamp ))
    if [ "$age" -lt "$GARDEN_FOREMAN_NOTICE_TTL" ]; then
      fresh="$(comm -23 <(printf '%s\n' "$refs" | grep . || true) \
                        <(tail -n +2 "$seen" | sort -u))"
      if [ -z "$fresh" ]; then
        log "milestone notice for $key adds no new ref ($(printf '%s' "$refs" | paste -sd, -)); not re-posting"
        return 0
      fi
    fi
  fi
  printf '%s\n' "$body" | GARDEN_SKIP_REF_CHECK=1 GARDEN_SENDER=foreman \
    GARDEN_MSG_COALESCE=1 GARDEN_MSG_COALESCE_THROTTLE_SECS=0 \
    GARDEN_MSG_ID="foreman-milestone-$key" "$HERE/inbox-send.sh" maintainer
  mkdir -p "$NOTICE_SEEN"
  {
    now
    { printf '%s\n' "$refs"
      # Within the TTL the seen-set accumulates; past it, it restarts from this notice.
      if [ -n "$fresh" ]; then tail -n +2 "$seen" 2>/dev/null || true; fi
    } | { grep . || true; } | sort -u
  } > "$seen.tmp" && mv "$seen.tmp" "$seen"
  log "posted milestone notice for $key to maintainer inbox (new: $(printf '%s' "${fresh:-$refs}" | paste -sd, -))"
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
  # handler, stay silent. NB target=0 lands here EVERY tick (inflight is a count,
  # always >= 0) — that is the fleet-wide quiesce (GARDEN_FOREMAN_ACTIVE_TARGET=0),
  # and the decision line makes that visible instead of an untraceable silent exit.
  rm -f "$IDLE_SINCE"
  decide subscribed
  exit 0
fi

# --- debounce: only act on sustained below-target capacity -------------------
NOW="$(now)"
if [ ! -f "$IDLE_SINCE" ]; then
  printf '%s\n' "$NOW" > "$IDLE_SINCE"   # first below-target observation; start the clock
  decide settle-start
  exit 0
fi
since="$(cat "$IDLE_SINCE" 2>/dev/null || echo "$NOW")"
elapsed=$(( NOW - since ))
if [ "$elapsed" -lt "$GARDEN_FOREMAN_IDLE_SETTLE" ]; then
  decide settle-wait "elapsed=$elapsed"
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
resolve_token_backoff_fraction "$DIR"
if [ "$provider_fallback_enabled" = false ]; then case "$(meter_quota_status "" "$DIR")" in
  backoff)
    note_once "token-backoff" "foreman: this host's Anthropic subscription is at/over the ${GARDEN_TOKEN_BACKOFF_FRACTION} high-water mark. Pausing the autonomous pump until its independently tracked reset."
    log "token quota high-water reached; backing off (no pump this tick)"
    decide token-backoff
    record_budget_halt current-host-token-quota backoff \
      "Anthropic pool reached its configured high-water mark" \
      "autonomous plan promotion and milestone pumping skipped for this tick"
    exit 0
    ;;
  unknown)
    # Quota configured but the meter could not be read. Never wedge the pump on a
    # broken meter — proceed, but warn so the meter gap is visible.
    log "WARN: token-quota meter unreadable though a quota is set; pumping unmetered (fail-open)"
    ;;
  off|ok) : ;;   # no quota configured, or under the mark — pump as normal
esac; fi

# Promotion has no claimant yet, so its admission check is deliberately coarse:
# stop the batch only when *all* configured bounded pools are confirmed in
# backoff. A single ok/off/unknown pool keeps promotion live; the later claim gate
# makes the precise host/account decision.
case "$(budget_fleet_status "$DIR")" in
  backoff)
    note_once "fleet-budget-backoff" "foreman: every configured subscription is at its high-water mark; deferred-plan promotion and new pumping are paused until a recorded subscription reset restores capacity."
    log "all configured budget pools at high water; stopping promotion/pump this tick"
    decide budget-backoff
    record_budget_halt fleet-budget-pools backoff \
      "all configured bounded pools reached their high-water marks" \
      "deferred-plan promotion and new milestone pumping skipped for this tick"
    exit 0
    ;;
  unknown)
    log "WARN: fleet budget state unreadable; promotion remains open (fail-open)"
    ;;
esac

# --- sustained below-target: fill the open slots from deferred plan jobs ------
# Before generating a NEW step (a `claude -p` call), fill the open slots with
# already-parked deferred plan jobs: they are pre-approved work picked by
# priority, so promoting them both honors the maintainer's queue and SAVES the
# handler's cost. plan_deferred_ranked admits exactly gate=deferred, so go-ahead,
# awaiting-maintainer, blocked, and orchestrated jobs are excluded. An
# awaiting-maintainer job can leave only through the explicit
# promote-plan.sh --maintainer path after its linked answer lands.
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
# Snapshot every deferred item the temporal/per-arc admission gate is holding.
# This is folded into the tick's one durable decision-log line even when another
# eligible plan is promoted, so "the foreman did nothing to this arc" is
# diagnosable without live tracing.
deferred_skips="$(plan_deferred_skipped "$DIR" 2>/dev/null \
  | awk -F'\t' '{printf "%s%s:%s", (NR==1?"":","), $1, $2}' || true)"
skip_detail="${deferred_skips:+ skipped=$deferred_skips}"
while [ "$promoted" -lt "$slots" ]; do
  # Leaf-first (omega-ranked) admission: plan_deferred_ranked_omega floats the
  # lowest-ranked deferred work (leaf R0) ahead of its higher-ranked parents,
  # tie-broken by the existing priority+FIFO order, and fails open to that order
  # when the derivation is unavailable (designs/cybernetics-economic-resilience.md
  # § 5). Its lines are `<omega_rank>\t<base>`.
  # `|| true`: the ranked pipeline ends in a writer (`| sort`); when it emits 2+
  # lines, `head -1` closes the pipe after the first, the writer's next write gets
  # EPIPE and exits 1, and pipefail would abort this whole `set -e` script even
  # though we already captured the line we wanted. Tolerate the writer-side SIGPIPE.
  top_line="$(plan_deferred_ranked_omega "$DIR" | head -1)" || true
  [ -n "$top_line" ] || break        # no more deferred plan jobs queued this tick
  top_rank="${top_line%%$'\t'*}"     # the derived omega rank (0=leaf, admitted first)
  top_deferred="${top_line#*$'\t'}"  # the job base
  if "$HERE/promote-plan.sh" --foreman --omega-rank "$top_rank" "$top_deferred" >/dev/null 2>&1; then
    promoted=$(( promoted + 1 ))
    printf '%s\n' "$top_deferred" > "$LAST_STEP"
    log "promoted deferred plan job '$top_deferred' (omega rank $top_rank; $promoted/$slots toward active-job target $GARDEN_FOREMAN_ACTIVE_TARGET)"
    sync_clone "$DIR"   # reflect the promotion so the next pick sees it gone from plan/
  else
    log "failed to promote deferred plan job '$top_deferred'; stopping deferred promotion this tick"
    break
  fi
done
if [ "$promoted" -gt 0 ]; then
  : > "$NOTED"           # forward progress clears the maintainer-note dedupe
  printf '%s\n' "$NOW" > "$IDLE_SINCE"
  decide promoted "count=$promoted last=$(cat "$LAST_STEP" 2>/dev/null || true)$skip_detail"
  exit 0
fi
# No deferred plan job was available; fall through to generate one new step.

# --- sustained below-target: pump the next milestone step --------------------
last_step="$(cat "$LAST_STEP" 2>/dev/null || true)"

# Per-arc headroom (designs/accountant-arc-apportionment.md § How the foreman
# draws). Once an apportionment has armed the reserve, the agent may only
# generate a step for an arc with headroom; with none anywhere (the reserve
# included) the agent is not invoked at all, and the accountant's edge-latched
# re-slice nudge gets a chance to fire.
arc_headroom=""; arcs_open=""
if arc_reserve_armed "$DIR"; then
  arc_headroom="$(arc_headroom_lines "$DIR" "$NOW" 2>/dev/null || true)"
  arcs_open="$(awk -F'\t' '$6 == "ok" && $5 > 0 { print $2 }' <<<"$arc_headroom")"
  if [ -z "$arcs_open" ]; then
    log "every arc slice (including the $GARDEN_ARC_RESERVE reserve) is held; not invoking the foreman agent"
    GARDEN_RESLICE_NOW="$NOW" "$HERE/accountant-reslice-nudge.sh" --dir "$DIR" >/dev/null 2>&1 || true
    decide arc-held "$skip_detail"
    exit 0
  fi
  GARDEN_RESLICE_NOW="$NOW" "$HERE/accountant-reslice-nudge.sh" --dir "$DIR" --clear >/dev/null 2>&1 || true
fi

digest="$(mktemp "${TMPDIR:-/tmp}/garden-foreman.XXXXXX")"
{
  printf 'project: %s\n'           "$GARDEN_FOREMAN_PROJECT"
  printf 'board: below active-job target %s (todo=%s doin=%s, in-flight=%s); sustained for %ss\n' "$GARDEN_FOREMAN_ACTIVE_TARGET" "$todo_n" "$doin_n" "$inflight" "$elapsed"
  printf 'last_step_posted: %s\n'  "${last_step:-(none)}"
  if [ -s "$DIR/config/foreman-mandate" ]; then
    printf 'priority_mandate: |\n'
    sed 's/^/  /' "$DIR/config/foreman-mandate"
    # Keep the digest line-oriented even when the journal file lacks a final LF.
    [ -z "$(tail -c 1 "$DIR/config/foreman-mandate" 2>/dev/null)" ] || printf '\n'
  fi
  if [ -n "$arc_headroom" ]; then
    printf 'arc_headroom: |\n'
    printf '  # rank arc remaining/cap status: summary. Draw only from an arc marked ok.\n'
    awk -F'\t' '{ printf "  %s %s %s/%s %s: %s\n", $1, $2, $5, $3, $6, $7 }' <<<"$arc_headroom"
  fi
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
  if [ "$hrc" -eq "${GARDEN_TRANSIENT_RC:-75}" ]; then
    # The live handler uses EX_TEMPFAIL when every configured inference route is
    # unavailable (and while its bounded outage latch is live). This is expected,
    # self-recovering timer state: record it and exit success so systemd never
    # marks the timer Failed or emits one maintainer alert per tick. Do not reset
    # idle-since; every timer tick cheaply consults the latch and the first tick
    # after its expiry performs the bounded re-probe immediately.
    log "foreman handler transiently unavailable rc=$hrc; inference deferred to its bounded re-probe"
    decide handler-transient "rc=$hrc"
    rm -f "$digest" "$herrf"
    exit 0
  fi
  log "WARN: foreman handler failed rc=$hrc: $(tail -c 500 "$herrf" 2>/dev/null || echo '<no stderr>')"
  alert_maintainer "foreman-handler-failed-$GARDEN" \
    "garden-foreman's pump handler ($GARDEN_FOREMAN_HANDLER) failed rc=$hrc on $GARDEN; the board pump is starving. stderr tail: $(tail -c 500 "$herrf" 2>/dev/null)"
  decide handler-failed "rc=$hrc"
  out=""
fi
rm -f "$digest" "$herrf"

# Parse at most one block from the handler output. An optional `ROLE <role>` line
# immediately inside a JOB block names the role the gardener wears (designer,
# builder, …); it is threaded to post-job.sh as --role so the job carries a
# `role:` field and inherits that role's default model (Opus for designer, Opus
# for builder). It is consumed here, not folded into the body.
btype=""; base=""; body=""; role=""; job_arc_line=""
while IFS= read -r line; do
  if   [[ "$line" =~ ^JOB[[:space:]]+(.+)$ ]]; then btype="JOB"; base="${BASH_REMATCH[1]}"; body=""; role=""; job_arc_line=""
  elif [ "$line" = "MAINTAINER" ];             then btype="MAINTAINER"; base=""; body=""; role=""; job_arc_line=""
  elif [ "$btype" = "JOB" ] && [[ "$line" =~ ^ARC[[:space:]]+(.+)$ ]]; then job_arc_line="$(printf '%s' "${BASH_REMATCH[1]}" | tr -d '[:space:]')"
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
      decide noop "empty-base$skip_detail"
    elif [ "$base" = "$last_step" ]; then
      # Anti-flap: the same step recurred after the previous post drained without
      # milestone progress. Do not blindly re-post; surface it for review.
      note_once "repeat:$base" "foreman: next step '$base' recurred after the previous post drained without milestone progress. Holding the re-post pending review; it may be stuck."
      log "anti-flap: '$base' repeats last posted step; surfaced to maintainer, not re-posted"
      decide anti-flap "base=$base$skip_detail"
    elif [ -n "$arcs_open" ] && ! grep -qxF "${job_arc_line:-$GARDEN_ARC_RESERVE}" <<<"$arcs_open"; then
      log "refusing step '$base': arc '${job_arc_line:-$GARDEN_ARC_RESERVE}' has no headroom (open: $(paste -sd, <<<"$arcs_open"))"
      decide arc-refused "base=$base arc=${job_arc_line:-$GARDEN_ARC_RESERVE}$skip_detail"
    else
      post_args=()
      [ -n "$role" ] && post_args+=(--role "$role")
      # Stamp the arc the step was drawn from; unarced steps charge the reserve.
      [ -n "$arcs_open" ] && post_args+=(--arc "${job_arc_line:-$GARDEN_ARC_RESERVE}")
      printf '%s' "$body" | "$HERE/post-job.sh" "${post_args[@]}" "$base"
      printf '%s\n' "$base" > "$LAST_STEP"
      : > "$NOTED"           # forward progress clears the maintainer-note dedupe
      log "pumped next milestone step '$base'"
      decide pumped "base=$base${role:+ role=$role}${arcs_open:+ arc=${job_arc_line:-$GARDEN_ARC_RESERVE}}$skip_detail"
    fi
    ;;
  MAINTAINER)
    # A board stalled on the same decision re-emits a reworded notice every tick;
    # note_milestone_once delivers only a new blocker, into one entry per milestone.
    note_milestone_once "$body"
    log "next step blocked on a maintainer decision; noted to maintainer inbox (dedup by milestone + new refs)"
    decide maintainer-note "$skip_detail"
    ;;
  *)
    log "handler proposed no next step; staying idle"
    decide noop "no-block$skip_detail"
    ;;
esac

# Reset the settle clock so the next pump is a fresh sustained-below-target window
# away. After a real JOB post the in-flight count rises by one; if that reached the
# active-job target the marker is cleared on the next at-capacity tick, otherwise this
# fresh clock paces the next top-up step. Also matters for the maintainer-note and
# no-op paths, where the board is still below target.
printf '%s\n' "$NOW" > "$IDLE_SINCE"
