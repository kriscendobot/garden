#!/bin/bash
# minion-town-press-preflight.sh — deterministic PARK gate for the
# `minion-town-agenda-review` press (the minion.town primary-phase two-hourly
# press; issue-kriscendobot-garden-58). Maintainer @kriskowal 2026-08-23
# (kriscendobot/garden#58, issuecomment-5388921796):
#   "If we see that there are no next steps twice, or that we have spent half our
#    weekly token budget on the press, just park the scheduled press."
#
# Usage: minion-town-press-preflight.sh <schedule-name>
#   <schedule-name> is passed by the scheduler for symmetry; this gate reads the
#   board (usage ledgers + completed press reports), not the stamp.
#
# Wired into schedules/minion-town-agenda-review.md as
# `preflight: minion-town-press-preflight.sh`. The scheduler runs it when the
# cadence has elapsed and acts on the exit code (scheduler.sh; skills/schedule):
#   exit 0 = work present → dispatch a fresh press tick + advance the clock
#   exit 2 = PARKED       → advance the clock only, dispatch nothing
#   (any other exit is treated as work-present — fail OPEN, never wrongly park.)
#
# Two park conditions, evaluated in plain code (no LLM), mapping the maintainer's
# two clauses:
#
#   (BUDGET) press-attributed billable tokens over the trailing weekly window
#            (GARDEN_TOKEN_WINDOW_SECS, default 7d) have reached HALF of the fleet
#            weekly token quota (GARDEN_TOKEN_WEEKLY_QUOTA). Summed from the press's
#            own per-tick usage ledgers (usage/<prefix>-*.jsonl). SELF-RECOVERING:
#            as old spend ages out of the trailing window the press un-parks on its
#            own. Inert when no weekly quota is configured (fail toward running).
#
#   (IDLE)   the two most-recent COMPLETED press ticks BOTH reported no available
#            next step, via a machine-readable `press-status: no-next-step` line the
#            press body is instructed to emit at column 0. "no next steps twice" →
#            park. STICKY: while parked no new tick runs, so the two frozen reports
#            keep it parked until a human RESUMES (resume-minion-town-press.sh writes
#            a per-host resume watermark this gate honours — reports at/older than the
#            watermark are ignored for the streak). Pre-existing reports with NO
#            marker read as "advanced" (unmarked), so the gate never parks on the
#            deploy-transition history — only on two freshly-marked idle ticks.
#
# FAIL OPEN on ambiguity: an unreadable/offline journal, an unset quota (BUDGET
# inert), a missing jq, a malformed usage row, or fewer than two markered reports
# all fall through to exit 0 (dispatch). The gate parks ONLY on a positively
# observed condition, never on uncertainty — a park stops real work, so the safe
# default is to keep running.
#
# ONE-SHOT alert: entering a park episode pages the maintainer ONCE (a per-host
# episode marker keyed by reason suppresses the per-tick re-page); a dispatching
# tick clears the marker so a future park pages again.
#
# Read-only against the board (ensure_clone / sync_clone; never writes or pushes
# to the journal). Per-host state (the park-episode marker and the resume
# watermark) lives under $GARDEN_STATE, uncommitted — the scheduler that runs this
# gate is a leader-only singleton, so per-host leader state is the right scope, and
# any loss fails safe (re-page once, or re-evaluate the stateless conditions).

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
export GARDEN_TAG="minion-town-press-preflight"

# The press whose ticks and usage this gate reasons over. Overridable for the test.
: "${GARDEN_MT_PRESS_PREFIX:=minion-town-agenda-review}"
# The trailing spend window and the fleet weekly quota (shared with usage-meter.sh /
# the foreman gate). Quota 0/unset ⇒ the BUDGET condition is inert.
: "${GARDEN_TOKEN_WINDOW_SECS:=604800}"
: "${GARDEN_TOKEN_WEEKLY_QUOTA:=0}"
# Fraction of the weekly quota that, once spent ON THE PRESS, trips the budget park.
: "${GARDEN_MT_PRESS_BUDGET_FRACTION:=0.5}"

name="${1:-${GARDEN_MT_PRESS_PREFIX}.md}"

DIR="${GARDEN_MT_PRESS_PREFLIGHT_CLONE:-$GARDEN_STATE/minion-town-press-preflight/journal}"
STATE_DIR="$GARDEN_STATE/minion-town-press-preflight"
EPISODE_FILE="$STATE_DIR/parked-episode"     # holds the reason key while parked
RESUME_FILE="$STATE_DIR/resume-watermark"    # ISO; idle streak ignores reports at/older

# --- sync the journal clone (fail OPEN on an unreadable/offline journal) ------
if ! ensure_clone "$DIR" 2>/dev/null || ! sync_clone "$DIR" 2>/dev/null; then
  log "WARN: journal unreachable; failing open (dispatch) — never park on an unreadable journal"
  exit 0
fi

now_epoch="$(date -u +%s 2>/dev/null || echo 0)"
log "evaluating park gate for schedule '$name' (prefix $GARDEN_MT_PRESS_PREFIX)"

# Enter a park episode: page the maintainer ONCE per (reason) episode, then defer.
park() {  # $1=reason-key  $2=message
  local rkey="$1" msg="$2"
  mkdir -p "$STATE_DIR" 2>/dev/null || true
  if [ ! -f "$EPISODE_FILE" ] || [ "$(head -1 "$EPISODE_FILE" 2>/dev/null || true)" != "$rkey" ]; then
    printf '%s\n' "$rkey" > "$EPISODE_FILE" 2>/dev/null || true
    alert_maintainer "minion-town-press-parked-${rkey}-${GARDEN}" "$msg"
    log "PARKED ($rkey): $msg"
  else
    log "still parked ($rkey); dispatch nothing (alert already delivered this episode)"
  fi
  exit 2
}

# Leaving the parked state: clear the episode marker so a future park re-pages.
unpark() {
  if [ -f "$EPISODE_FILE" ]; then
    rm -f "$EPISODE_FILE" 2>/dev/null || true
    log "press active again; cleared park-episode marker"
  fi
}

# --- (BUDGET) half the weekly quota spent on the press? -----------------------
quota="$GARDEN_TOKEN_WEEKLY_QUOTA"
case "$quota" in ''|*[!0-9]*) quota=0 ;; esac
if [ "$quota" -gt 0 ] && command -v jq >/dev/null 2>&1; then
  cutoff_epoch=$(( now_epoch - GARDEN_TOKEN_WINDOW_SECS ))
  cutoff_iso="$(date -u -d "@$cutoff_epoch" +%FT%TZ 2>/dev/null || echo '')"
  spend=0
  if [ -n "$cutoff_iso" ] && [ -d "$DIR/usage" ]; then
    for f in "$DIR"/usage/"${GARDEN_MT_PRESS_PREFIX}"-*.jsonl; do
      [ -f "$f" ] || continue
      # Sum billable tokens on well-formed, in-window rows ONLY; a malformed or
      # bookkeeping (`source:none`) row is skipped, never errored on. Undercounting
      # fails toward NOT parking — the safe direction for a work-stopping gate.
      s="$(jq -sre --arg c "$cutoff_iso" '
            [ .[]
              | select((.ts?|type)=="string" and .ts >= $c)
              | select((.input_tokens?|type)=="number"
                       or (.output_tokens?|type)=="number"
                       or (.cache_creation_tokens?|type)=="number")
              | ((.input_tokens // 0)+(.output_tokens // 0)+(.cache_creation_tokens // 0)) ]
            | add // 0' "$f" 2>/dev/null)" || continue
      case "$s" in ''|*[!0-9]*) : ;; *) spend=$(( spend + s )) ;; esac
    done
    threshold="$(awk -v q="$quota" -v fr="$GARDEN_MT_PRESS_BUDGET_FRACTION" \
                   'BEGIN{ printf "%d", q*fr }' 2>/dev/null || echo 0)"
    case "$threshold" in ''|*[!0-9]*) threshold=0 ;; esac
    if [ "$threshold" -gt 0 ] && [ "$spend" -ge "$threshold" ]; then
      park budget "minion.town press has spent $spend billable tokens over the trailing $(( GARDEN_TOKEN_WINDOW_SECS / 86400 ))d — at or past HALF the weekly token quota ($quota; park threshold $threshold). Per kriscendobot/garden#58 (kriskowal, 2026-08-23): parking the two-hourly press. It un-parks automatically as spend ages out of the window; force-resume with resume-minion-town-press.sh."
    fi
    log "budget: press spend $spend / threshold $threshold (window ${GARDEN_TOKEN_WINDOW_SECS}s, quota $quota) — under the park line"
  fi
else
  log "budget check inert (GARDEN_TOKEN_WEEKLY_QUOTA unset/0 or jq missing) — idle condition alone governs parking"
fi

# --- (IDLE) two most-recent press ticks both reported no next step? -----------
# A resume watermark (per-host, written by resume-minion-town-press.sh) makes the
# gate ignore reports at/older than it, so a maintainer can un-stick an idle park.
resume_iso="$(head -1 "$RESUME_FILE" 2>/dev/null | tr -d '[:space:]' || true)"
resume_epoch=0
[ -n "$resume_iso" ] && resume_epoch="$(date -u -d "$resume_iso" +%s 2>/dev/null || echo 0)"

# base tail `YYYYMMDD-HHMMSS` → epoch (0 on any parse failure).
base_ts_epoch() {  # $1=YYYYMMDD-HHMMSS
  local t="$1" d hms
  case "$t" in
    [0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9][0-9][0-9]) : ;;
    *) echo 0; return ;;
  esac
  d="${t%%-*}"; hms="${t##*-}"
  date -u -d "${d:0:4}-${d:4:2}-${d:6:2} ${hms:0:2}:${hms:2:2}:${hms:4:2}" +%s 2>/dev/null || echo 0
}

# Collect the press tada reports newest-first. base = <prefix>-YYYYMMDD-HHMMSS, so
# lexical sort is chronological; sort -r puts the newest first.
statuses=()
if [ -d "$DIR/$JOBS_TADA" ]; then
  while IFS= read -r rf; do
    [ -f "$rf" ] || continue
    bn="$(basename "$rf" .md)"
    ts="${bn##"${GARDEN_MT_PRESS_PREFIX}"-}"   # YYYYMMDD-HHMMSS
    if [ "$resume_epoch" -gt 0 ]; then
      rep_epoch="$(base_ts_epoch "$ts")"
      [ "$rep_epoch" -gt "$resume_epoch" ] || continue   # older than resume → ignore
    fi
    if grep -qiE '^press-status:[[:space:]]*no-next-step' "$rf" 2>/dev/null; then
      statuses+=("idle")
    else
      # `press-status: advanced` OR any legacy/unmarked report both BREAK the
      # idle streak — only an explicit no-next-step marker counts as idle.
      statuses+=("advanced")
    fi
  done < <(find "$DIR/$JOBS_TADA" -type f -name "${GARDEN_MT_PRESS_PREFIX}-*.md" 2>/dev/null | sort -r)
fi

if [ "${#statuses[@]}" -ge 2 ] && [ "${statuses[0]}" = idle ] && [ "${statuses[1]}" = idle ]; then
  park idle "minion.town press reported NO available next step on its two most-recent ticks (both blocked on a maintainer decision, an outage, or work already in flight). Per kriscendobot/garden#58 (kriskowal, 2026-08-23: \"if we see there are no next steps twice … just park\"): parking the two-hourly press. Resume once the blockers clear with resume-minion-town-press.sh (issue #58)."
fi

# --- work present: dispatch a fresh press tick --------------------------------
unpark
log "work present: dispatch minion.town press (recent statuses: ${statuses[0]:-none}/${statuses[1]:-none}; budget under the park line)"
exit 0
