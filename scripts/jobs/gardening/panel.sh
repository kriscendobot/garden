#!/bin/bash
# panel.sh — the JURY-PANEL state machine (a SHELL script, not an agent
# checklist). A gardener supervises this script; it runs the appropriate jury
# panel by shelling out to `claude -p` once per juror SEAT, collects each seat's
# verdict, DECIDES the disposition, loops to a fixer stage when changes are
# required, and TERMINATES by un-drafting when the panel passes.
#
# This is the v2 scripted translation of v1's JUDICIAL workflow. In v1, three
# judge roles (solicitor / barrister / justice) and an appellate were dispatched
# by an orchestrator agent that walked a checklist. Here the control flow is the
# script; `claude -p` is reserved for the genuine JUDGMENTS (each seat's review,
# the disposition decision, the appellate pass).
#
# Design contract (see designs/gardening-state-machine.md and
# designs/judicial-workflow.md):
#  * QUIET ON SUCCESS. A passing panel prints essentially nothing, to protect
#    the supervising agent's context window. Real output is the terminal state
#    (un-drafted, or a `loop` signal) and any genuine failure. Per-seat verdicts
#    go to a run directory on disk, never to the supervisor's stdout.
#  * DECISIONS VIA `claude -p`, OVERRIDABLE BY A HOOK. The disposition decision
#    and the appellate pass shell to `claude -p`; tests/non-interactive runs stub
#    them via GARDEN_PANEL_DECIDE (and GARDEN_PANEL_SEAT for the seat reviews).
#  * TRACING IS OPT-IN AND DIVERTED. With GARDEN_TRACE=1 it `set -x`'s into
#    $GARDEN_TRACE_LOG (via BASH_XTRACEFD), NOT stdout — the supervisor hands
#    that log to a dedicated debugging subagent so trace noise never enters the
#    supervisor's own context.
#  * EVOLVABLE. If a stage fails in a fixable way, the supervisor edits this
#    script and re-runs; the state machine is data the supervisor owns. The
#    seat list, the fixer hook, and the un-draft hook are the parts a project
#    plugs into.
#
# Usage: panel.sh <worktree> <pr-number> [base-ref]
# Stages: sense panel kind (code vs design) → fan seats to `claude -p` →
#         collect verdicts → DECIDE disposition → fixer-loop while must-fix →
#         appellate pass → terminate by un-drafting (quiet) on a clean panel.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Where the juror seat briefs live (v2 garden). Each seat is a directory with an
# AGENT.md; the panel iterates this list and shells one `claude -p` per seat.
: "${GARDEN_ROOT:=$(cd "$HERE/../../.." && pwd)}"
: "${JURORS_DIR:=$GARDEN_ROOT/roles/jurors}"

wt="${1:?usage: panel.sh <worktree> <pr> [base]}"
pr="${2:?pr number}"
base="${3:-HEAD~1}"

# Per-run scratch: per-seat verdicts and the aggregated body land here on disk,
# OUT of the supervisor's context window. The supervisor reads this dir only when
# it wants the detail; quiet-on-success means it usually does not.
# Keyed by WORKTREE BASENAME + PR, not PR alone: /tmp is host-shared and a
# ~100-worker fleet can run panels for PR #N of two DIFFERENT repos at once —
# a PR-only key made them share one run dir, interleaving round files so one
# panel's disposition was decided over the other's verdicts.
: "${GARDEN_PANEL_RUNDIR:=${TMPDIR:-/tmp}/garden-panel-$(basename "$wt")-$pr}"
mkdir -p "$GARDEN_PANEL_RUNDIR"

# Diverted tracing: on, but into a log the supervisor gives to a debug subagent.
if [ "${GARDEN_TRACE:-0}" = "1" ]; then
  : "${GARDEN_TRACE_LOG:=${TMPDIR:-/tmp}/garden-panel-$pr.trace}"
  exec 9>>"$GARDEN_TRACE_LOG"; export BASH_XTRACEFD=9; set -x
fi

fail() { echo "panel #$pr: FAILED at $*" >&2; exit 1; }   # failures are loud

# --- juror seat list: code panel vs design panel ----------------------------
# The two panel kinds and their seats are the v1 jury composition (see
# skills/panel-review). The code panel is the 27-seat source-touching panel; the
# design panel is the 7-seat design-only panel. The script senses which to run
# from the diff (design-only when every changed path is under designs/), then
# iterates the matching seat list. A project can override either list via env.

# Code panel (27 seats) — source-touching PRs.
: "${GARDEN_CODE_SEATS:=assessor typist stylist packager archivist prover curator \
migrator locksmith warden saboteur breaker purist spec-keeper wire-watcher \
engine-realist integrator benchmarker changeset-auditor surfacer scribe pruner \
gateway corner-prober fast-checker releaser transplanter}"

# Design panel (7 seats) — design-only PRs (paths under designs/).
: "${GARDEN_DESIGN_SEATS:=critic skeptic decomplector ergonomist copyeditor pedant novice}"

# --- stage: sense the panel kind from the diff ------------------------------
# Design panel iff there is at least one change AND every changed path is under a
# design directory (designs/*.md or */designs/*.md) or matches DESIGN*.md.
# Anything else is the code panel. This mirrors v1 panel-hints step 1 and the
# orchestrator's mechanical panel-kind discrimination. On any ambiguity (no base,
# git error, no changed files) we fall to the code panel: the broader, safer
# panel, consistent with sense.sh's bias toward over-reviewing.
sense_panel_kind() {
  local files
  files="$(git -C "$wt" diff --name-only "$base...HEAD" 2>/dev/null || true)"
  [ -n "$files" ] || { echo code-panel; return; }
  local f all_design=true
  while IFS= read -r f; do
    [ -n "$f" ] || continue
    case "$f" in
      designs/*.md|*/designs/*.md) ;;
      DESIGN*.md|*/DESIGN*.md) ;;
      *) all_design=false; break;;
    esac
  done <<EOF
$files
EOF
  if [ "$all_design" = true ]; then echo design-panel; else echo code-panel; fi
}

panel_kind="$(sense_panel_kind)"
case "$panel_kind" in
  design-panel) seats="$GARDEN_DESIGN_SEATS" ;;
  *)            seats="$GARDEN_CODE_SEATS" ;;
esac

# --- DECISION HOOK: a single juror seat's review ----------------------------
# Shells one `claude -p` per seat, briefing it with the seat's AGENT.md and the
# PR diff. Returns the seat's verdict block on stdout; the caller files it under
# the run dir. Overridable by GARDEN_PANEL_SEAT for tests/non-interactive runs:
# the hook is called as `$GARDEN_PANEL_SEAT <seat> <pr> <worktree> <base>`.
seat_review() {  # seat_review <seat> -> prints that seat's per-juror block
  local seat="$1"
  if [ -n "${GARDEN_PANEL_SEAT:-}" ]; then
    "$GARDEN_PANEL_SEAT" "$seat" "$pr" "$wt" "$base"; return
  fi
  local brief="$JURORS_DIR/$seat/AGENT.md"
  [ -r "$brief" ] || fail "seat brief $brief"
  claude -p --dangerously-skip-permissions "You are jury seat '$seat' reviewing PR #$pr. Read your operating \
brief, then review the diff and return ONE per-juror block: a Verdict \
(approve / request-changes / comment-only) and Findings, each finding citing a \
standing rule [rule: <path>] or proposing one [proposed-rule: ...]. Brief: \
$(cat "$brief"). Diff base: $base." 2>/dev/null
}

# --- DECISION HOOK: aggregate the seat verdicts into one disposition ---------
# Reads every seat's block and decides the round's disposition. Echoes one of
# `must-fix` (changes required; loop to the fixer) or `pass` (no must-fix items;
# terminate). Overridable by GARDEN_PANEL_DECIDE for tests/non-interactive runs:
# called as `$GARDEN_PANEL_DECIDE <aggregate-file> <pr>`.
decide_disposition() {  # decide_disposition <aggregate-file> -> must-fix | pass
  local agg="$1"
  if [ -n "${GARDEN_PANEL_DECIDE:-}" ]; then "$GARDEN_PANEL_DECIDE" "$agg" "$pr"; return; fi
  claude -p --dangerously-skip-permissions "You are the gardener acting as panel foreperson on PR #$pr. Below \
are the jury seats' verdict blocks. Apply the disposition rubric: any concrete \
request-changes finding is 'must-fix' and blocks the panel; otherwise the panel \
passes. Answer with exactly one word: 'must-fix' or 'pass'. Verdicts: \
$(cat "$agg")"
}

# --- PLUGGABLE HOOK: the appellate pass (terminating rounds only) ------------
# v1's appellate appealed small-and-in-context follow-up/acknowledge items into
# summary-fix before the un-draft. Here it is one `claude -p` over the passing
# round's aggregate; its proposal list is advisory and goes to the run dir, never
# blocking the un-draft. Overridable / skippable via GARDEN_PANEL_APPELLATE
# (set to `:` to skip). Called as `$GARDEN_PANEL_APPELLATE <aggregate-file> <pr>`.
appellate_pass() {  # appellate_pass <aggregate-file> -> proposals (to run dir)
  local agg="$1"
  if [ -n "${GARDEN_PANEL_APPELLATE:-}" ]; then "$GARDEN_PANEL_APPELLATE" "$agg" "$pr"; return; fi
  claude -p --dangerously-skip-permissions "You are the appellate on PR #$pr. Read the panel's passing verdict \
and, conservatively, list any small-and-in-context follow-up/acknowledge items \
that should be promoted to summary-fix before un-draft. Be terse; silence is a \
valid output. Verdict: $(cat "$agg")" 2>/dev/null || true
}

# --- PLUGGABLE HOOK: fixer invocation (non-terminating rounds) ---------------
# Project-specific: dispatch a fixer with the must-fix items inline, wait for its
# push. The scaffold default is a no-op `true` so the control flow runs in tests;
# the supervisor wires the project's real fixer here (or via GARDEN_PANEL_FIXER).
: "${GARDEN_PANEL_FIXER:=true}"   # e.g. a script that dispatches the fixer role
run_fixer() {  # run_fixer <aggregate-file>
  "$GARDEN_PANEL_FIXER" "$wt" "$pr" "$1" || fail "fixer"
}

# --- PLUGGABLE HOOK: un-draft (the terminal step) ----------------------------
# v1's terminal step is `gh pr ready <N>`. Left as a clearly-marked hook so the
# project plugs in the real identity-bearing call; default is a no-op `true`.
: "${GARDEN_PANEL_UNDRAFT:=true}"   # e.g. gh pr ready "$pr" -R <owner>/<repo>
undraft() { "$GARDEN_PANEL_UNDRAFT" "$pr" || fail "un-draft"; }

# --- the panel / fixer loop -------------------------------------------------
# One round per iteration: fan the seats, aggregate, decide. While the decision
# is 'must-fix', invoke the fixer and re-run the panel against the new head. When
# the decision is 'pass', run the appellate, then un-draft and terminate quietly.
: "${GARDEN_PANEL_MAX_ROUNDS:=8}"   # loop-exit safety bound; not a normal exit
round=0
while :; do
  round=$((round + 1))
  if [ "$round" -gt "$GARDEN_PANEL_MAX_ROUNDS" ]; then
    fail "panel did not converge in $GARDEN_PANEL_MAX_ROUNDS rounds"
  fi

  agg="$GARDEN_PANEL_RUNDIR/round-$round.md"
  : > "$agg"
  for seat in $seats; do
    block="$GARDEN_PANEL_RUNDIR/round-$round.$seat.md"
    seat_review "$seat" > "$block" || fail "seat $seat"
    { echo "### $seat"; cat "$block"; echo; } >> "$agg"
  done

  # STRICT verdict parse — the disposition gate must never fail OPEN. The old
  # `case "$disposition" in *must-fix*) … *) undraft` treated ANY non-"must-fix"
  # output — a refusal, an empty/truncated answer, free prose — as PASS and
  # un-drafted a PR whose panel may have demanded changes; conversely a
  # compliant "pass — no must-fix findings remain" contains the substring and
  # looped the fixer to the round bound. Accept only an answer whose LAST
  # non-blank line is exactly one of the two tokens (case-insensitive,
  # punctuation-trimmed — the prompt demands a single word, so a compliant
  # answer ends with it); retry the decider once on garbage, then FAIL LOUDLY
  # so the supervising gardener re-runs the panel rather than un-drafting on a
  # guess.
  disposition=""
  for _decide_attempt in 1 2; do
    raw="$(decide_disposition "$agg")"
    tok="$(printf '%s\n' "$raw" | awk 'NF{l=$0} END{print l}' | tr -d '\r' \
           | sed "s/[\"'.\!]//g; s/^[[:space:]]*//; s/[[:space:]]*\$//" \
           | tr '[:upper:]' '[:lower:]')"
    case "$tok" in
      must-fix|pass) disposition="$tok"; break ;;
      *) echo "panel #$pr: unparseable disposition '$tok' (attempt $_decide_attempt); re-asking" >&2 ;;
    esac
  done
  case "$disposition" in
    must-fix)
      run_fixer "$agg"      # non-terminating round; loop to re-review the delta
      continue ;;
    pass)
      # terminating round: appellate pass (advisory), then un-draft, then exit.
      appellate_pass "$agg" > "$GARDEN_PANEL_RUNDIR/appellate.md" || true
      undraft
      break ;;
    *)
      fail "disposition (decider returned neither 'must-fix' nor 'pass' twice)" ;;
  esac
done

# QUIET SUCCESS: a passing, un-drafted panel prints one terminal line and the run
# dir holds the detail. The supervisor reacts to this line; routine per-seat
# chatter never reached its context.
echo "panel #$pr: $panel_kind PASSED after $round round(s); un-drafted."
