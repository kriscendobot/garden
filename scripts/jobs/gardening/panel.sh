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
# Stages: sense panel kind (code vs design) → fan seats to `claude -p`, up to
#         GARDEN_PANEL_CONCURRENCY at once → join and aggregate in seat order →
#         DECIDE disposition → fixer-loop while must-fix → appellate pass →
#         terminate by un-drafting (quiet) on a clean panel.

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
# skills/panel-review). The code panel is the 28-seat source-touching panel; the
# design panel is the 7-seat design-only panel. The script senses which to run
# from the diff (design-only when every changed path is under designs/), then
# iterates the matching seat list. A project can override either list via env.

# Code panel (28 seats) — source-touching PRs. The coverage-auditor is a MANDATORY
# seat (every builder/fixer gauntlet runs the code panel), but it is COST-GATED at
# dispatch: its co-located seat-gate runs a deterministic c8 coverage pre-pass and
# only spends a `claude -p` when the change has uncovered new lines (see
# seat-gate-coverage-auditor.sh and the seat_review gate below).
: "${GARDEN_CODE_SEATS:=assessor typist stylist packager archivist prover curator \
migrator locksmith warden saboteur breaker purist spec-keeper wire-watcher \
engine-realist integrator benchmarker changeset-auditor surfacer scribe pruner \
gateway corner-prober fast-checker releaser transplanter coverage-auditor}"

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

# --- durable panel-run record (best-effort; never fatal) --------------------
# The panel's per-seat prose is scratch: GARDEN_PANEL_RUNDIR is torn down with the
# job's worktree, so nothing durable records which seats reviewed which PR, how
# many fix-loop rounds it took, or what the must-fix items were. On termination —
# pass, the max-rounds bound, or any fail — we push ONE COMPACT record per run to
# the journal via a separate DETERMINISTIC writer (no `claude -p`; the single-
# writer discipline of reputation.sh / review-miss-record.sh). It is invoked
# BEST-EFFORT: a failed journal push WARNs and never fails the panel or blocks an
# un-draft. Set GARDEN_PANEL_RECORD=: to skip it (tests that do not want a push).
PANEL_RECORD_WRITER="${GARDEN_PANEL_RECORD:-$HERE/../panel-run-record.sh}"
PANEL_RECORD_REPO="${GARDEN_PANEL_REPO:-}"
if [ -z "$PANEL_RECORD_REPO" ]; then
  PANEL_RECORD_REPO="$(git -C "$wt" remote get-url origin 2>/dev/null \
    | sed -E 's#^git@[^:]+:##; s#^https?://[^/]+/##; s#\.git$##')" || PANEL_RECORD_REPO=""
  [ -n "$PANEL_RECORD_REPO" ] || PANEL_RECORD_REPO="$(basename "$wt")"
fi
PANEL_DISPOSITION=error            # overwritten at each terminal path (default: unexpected exit)
PANEL_APPELLATE_RAN=0
PANEL_APPELLATE_COUNT=0

# emit_panel_record — assemble record-meta from the accumulated facts and invoke
# the writer. Fully defensive: every step is guarded so this can never fail the
# panel (it runs from an EXIT trap that restores the real exit code).
emit_panel_record() {
  [ -n "$PANEL_RECORD_WRITER" ] && [ "$PANEL_RECORD_WRITER" != ":" ] || return 0
  [ -e "$PANEL_RECORD_WRITER" ] || return 0
  {
    echo "repo=$PANEL_RECORD_REPO"
    echo "pr=$pr"
    echo "panel_kind=${panel_kind%-panel}"
    echo "base_ref=$base"
    echo "disposition=$PANEL_DISPOSITION"
    echo "appellate_ran=$PANEL_APPELLATE_RAN"
    echo "appellate_count=$PANEL_APPELLATE_COUNT"
  } > "$GARDEN_PANEL_RUNDIR/record-meta" 2>/dev/null || return 0
  bash "$PANEL_RECORD_WRITER" emit "$GARDEN_PANEL_RUNDIR" >/dev/null 2>>"$GARDEN_PANEL_RUNDIR/record.log" || true
  return 0
}
# shellcheck disable=SC2154   # rc IS assigned (rc=$?) inside the trap string
trap 'rc=$?; emit_panel_record || true; exit $rc' EXIT

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
  # Cost-gated seats: a seat may ship a deterministic PRE-PASS gate co-located here
  # as seat-gate-<seat>.sh. It runs plain code first and only spends a `claude -p`
  # when it has something to judge (the proxy's deterministic-pre-pass-then-cost-
  # gated-handler pattern), OWNING the seat's block on stdout in every branch. The
  # coverage-auditor is the first such seat (c8 coverage-of-new-lines).
  local gate="$HERE/seat-gate-$seat.sh"
  if [ -x "$gate" ]; then
    "$gate" "$seat" "$pr" "$wt" "$base"; return
  fi
  local brief="$JURORS_DIR/$seat/AGENT.md"
  [ -r "$brief" ] || fail "seat brief $brief"
  claude -p --dangerously-skip-permissions "You are jury seat '$seat' reviewing PR #$pr. Read your operating \
brief, then review the diff and return ONE per-juror block: a Verdict \
(approve / request-changes / comment-only) and Findings, each finding citing a \
standing rule [rule: <path>] or proposing one [proposed-rule: ...]. Brief: \
$(cat "$brief"). Diff base: $base."
  # NOTE: stderr is intentionally NOT swallowed here. The caller redirects this
  # function's stderr to a per-seat .stderr file so a failing `claude -p`
  # (rate-limit/overload/truncation) is DIAGNOSABLE instead of vanishing — the
  # cause of the recurring 0-byte seat blocks that jammed the panel gate.
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

# --- one seat's whole retry-on-empty block, runnable CONCURRENTLY ------------
# RETRY-ON-EMPTY SEAT. A seat's `claude -p` intermittently exits non-zero or
# (worse) exits 0 with EMPTY stdout — a rate-limit / overload / truncation. The
# old `seat_review > block || fail` handled only the non-zero case and, on a
# 0-byte-but-exit-0 answer, SILENTLY aggregated an empty verdict the decider then
# judged over (a seat with no signal, diluting the disposition); the non-zero case
# failed the WHOLE panel on one transient blip, its stderr swallowed by
# `2>/dev/null` so the cause was undiagnosable (the recurring 0-byte
# round-1.typist.md / round-1.prover.md that jammed the finbot merge gate for days
# — /tmp/garden-panel-finbot*/). So: capture the seat's stderr to disk, treat an
# empty/blank block as a failure, retry with backoff, and only fail LOUDLY once the
# attempts are spent. An empty seat verdict is never legitimate signal and must
# never reach the aggregate.
#
# This runs in a BACKGROUND SUBSHELL (see the fan-out below), so it cannot `fail`
# the panel directly — a subshell's `exit` kills only itself. It records its
# outcome in `<block>.status` instead and the join pass turns that into the loud
# failure, in deterministic seat order. The status is written `pending` UP FRONT so
# a subshell that dies mid-flight (a `fail` from inside `seat_review` — an
# unreadable brief — or a kill) is distinguishable from one that exhausted its
# attempts, rather than looking identical to "no verdict".
run_seat() {  # run_seat <seat> <block>  -> writes <block>, <block>.stderr, <block>.status
  local seat="$1" block="$2" attempts try
  attempts="${GARDEN_PANEL_SEAT_ATTEMPTS:-3}"
  echo pending > "$block.status"
  for try in $(seq 1 "$attempts"); do
    if seat_review "$seat" > "$block" 2> "$block.stderr" \
       && grep -q '[^[:space:]]' "$block"; then
      echo ok > "$block.status"; return 0
    fi
    echo "panel #$pr: seat '$seat' returned no verdict (attempt $try/$attempts); retrying" >&2
    [ "$try" -lt "$attempts" ] && sleep "$(( try * ${GARDEN_PANEL_SEAT_BACKOFF:-5} ))"
  done
  echo fail > "$block.status"
  return 1
}

# --- bounded-concurrency knob for the seat fan-out --------------------------
# The seat fan-out used to be a strictly SEQUENTIAL `for seat in $seats` loop,
# which put the 28-seat code panel structurally OUTSIDE a gardener's default
# handler budget: measured on this fleet, one seat reviewing a ~1500-line diff
# takes over three minutes, so a full panel is ~1.5–2.5 hours against a
# `GARDEN_HANDLER_TIMEOUT` of 2400s. Every build's auto-gauntlet and every
# `run the gauntlet` job was therefore unrunnable in one claim unless whoever
# posted it REMEMBERED to stamp `handler-timeout:` — correctness resting on a
# header a human or agent had to write, with a reduced panel and a spillover job
# as the fallback. Parallel fan-out moves that responsibility into the script:
# the panel fits by construction.
#
# The loop body already parallelized cleanly — each seat owns its own
# `round-$round.$seat.md` and `.stderr` and its retry/backoff is self-contained.
# The ONLY order-dependent step was the `>> $agg` append, which is now a separate
# deterministic second pass in `$seats` order after the join, so the aggregate is
# byte-identical to what the sequential loop produced.
#
# Concurrency is bash background jobs + `wait -n`, deliberately NOT `xargs -P`:
# `seat_review` is a shell FUNCTION closing over the whole run's environment and
# hooks, so driving it through xargs would need a GENERATED helper script — which
# on this host cannot live in /tmp at all, because /tmp is mounted `noexec` (a
# `chmod 755` helper written there fails with `Permission denied`, visible only in
# a redirected log). Background subshells need no helper file and no exec bit.
: "${GARDEN_PANEL_CONCURRENCY:=8}"
case "$GARDEN_PANEL_CONCURRENCY" in ''|*[!0-9]*) GARDEN_PANEL_CONCURRENCY=8 ;; esac
[ "$GARDEN_PANEL_CONCURRENCY" -ge 1 ] || GARDEN_PANEL_CONCURRENCY=1

# --- the panel / fixer loop -------------------------------------------------
# One round per iteration: fan the seats, aggregate, decide. While the decision
# is 'must-fix', invoke the fixer and re-run the panel against the new head. When
# the decision is 'pass', run the appellate, then un-draft and terminate quietly.
: "${GARDEN_PANEL_MAX_ROUNDS:=8}"   # loop-exit safety bound; not a normal exit
round=0
while :; do
  round=$((round + 1))
  if [ "$round" -gt "$GARDEN_PANEL_MAX_ROUNDS" ]; then
    PANEL_DISPOSITION="max-rounds-exceeded"
    fail "panel did not converge in $GARDEN_PANEL_MAX_ROUNDS rounds"
  fi

  agg="$GARDEN_PANEL_RUNDIR/round-$round.md"
  : > "$agg"
  # Record the head sha under review THIS round for the durable panel-run record
  # (the worktree HEAD moves as the fixer pushes, so it must be captured per round,
  # not reconstructed after the fact). Best-effort; a non-git worktree leaves it empty.
  git -C "$wt" rev-parse HEAD 2>/dev/null > "$GARDEN_PANEL_RUNDIR/round-$round.head" || true
  attempts="${GARDEN_PANEL_SEAT_ATTEMPTS:-3}"

  # FAN: launch up to GARDEN_PANEL_CONCURRENCY seats at a time. `wait -n` frees a
  # slot as soon as ANY in-flight seat finishes, so one slow seat never idles the
  # pool the way a batch-and-barrier would. `|| true` because a seat that
  # exhausted its attempts returns non-zero and `set -e` would otherwise kill the
  # panel here, BEFORE the join pass can name the seat and point at its stderr.
  inflight=0
  for seat in $seats; do
    if [ "$inflight" -ge "$GARDEN_PANEL_CONCURRENCY" ]; then
      wait -n || true; inflight=$((inflight - 1))
    fi
    run_seat "$seat" "$GARDEN_PANEL_RUNDIR/round-$round.$seat.md" &
    inflight=$((inflight + 1))
  done
  wait || true   # JOIN: every seat has now written its .status

  # AGGREGATE, in `$seats` order — the one order-dependent step, done as a second
  # pass so the fan-out above can be concurrent and this file stays byte-stable
  # regardless of which seat finished when. A seat that did not report `ok` fails
  # the panel LOUDLY here, at the FIRST such seat in seat order (deterministic),
  # pointing at its captured stderr.
  for seat in $seats; do
    block="$GARDEN_PANEL_RUNDIR/round-$round.$seat.md"
    case "$(cat "$block.status" 2>/dev/null || true)" in
      ok)   ;;
      fail) PANEL_DISPOSITION="seat-error"; fail "seat $seat (empty verdict after $attempts attempts; stderr in $block.stderr)" ;;
      *)    PANEL_DISPOSITION="seat-error"; fail "seat $seat (fan-out died before reporting a verdict; stderr in $block.stderr)" ;;
    esac
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
      # Record whether the appellate actually ran (skipped when GARDEN_PANEL_APPELLATE
      # is `:`), and a best-effort proposal count from its bullet/numbered lines.
      if [ "${GARDEN_PANEL_APPELLATE:-}" != ":" ]; then
        PANEL_APPELLATE_RAN=1
        PANEL_APPELLATE_COUNT="$(grep -cE '^[[:space:]]*([-*]|[0-9]+[.)])[[:space:]]' \
          "$GARDEN_PANEL_RUNDIR/appellate.md" 2>/dev/null || echo 0)"
      fi
      PANEL_DISPOSITION="passed"
      undraft
      break ;;
    *)
      PANEL_DISPOSITION="decider-error"
      fail "disposition (decider returned neither 'must-fix' nor 'pass' twice)" ;;
  esac
done

# QUIET SUCCESS: a passing, un-drafted panel prints one terminal line and the run
# dir holds the detail. The supervisor reacts to this line; routine per-seat
# chatter never reached its context.
echo "panel #$pr: $panel_kind PASSED after $round round(s); un-drafted."
