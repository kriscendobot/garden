#!/bin/bash
# garden-pr.sh — the PR-gardening state machine (a SHELL script, not an agent
# checklist). A gardener supervises this script; the script shells out to
# `claude -p` subagents only for DECISIONS (how to proceed, whether to loop),
# and runs deterministic automation itself.
#
# Design contract (see designs/gardening-state-machine.md):
#  * QUIET ON SUCCESS. When things are going well it writes essentially nothing,
#    to protect the supervising agent's context window. Real output is the final
#    state and any genuine failure.
#  * TRACING IS OPT-IN AND DIVERTED. With GARDEN_TRACE=1 it `set -x`'s into
#    $GARDEN_TRACE_LOG (default a temp file), NOT stdout — the supervisor hands
#    that log to a dedicated debugging subagent so trace noise never enters the
#    supervisor's own context.
#  * EVOLVABLE. If a stage fails in a way the supervisor can fix, it edits this
#    script and re-runs; the state machine is data the supervisor owns.
#  * HEURISTIC GATING via sense.sh — only run an automation when a cheap signal
#    says it might matter, EXCEPT the evaluation/test gate before CI, which errs
#    toward running everything (false positives fine, false negatives not).
#
# Usage: garden-pr.sh <worktree> <pr-number> [base-ref]
# Stages: rebase? → sense-gated automations → ALWAYS run evals → push for CI →
#         ask claude -p whether to loop.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SENSE="$HERE/sense.sh"

wt="${1:?usage: garden-pr.sh <worktree> <pr> [base]}"
pr="${2:?pr number}"
base="${3:-HEAD~1}"

# Diverted tracing: on, but into a log the supervisor gives to a debug subagent.
if [ "${GARDEN_TRACE:-0}" = "1" ]; then
  : "${GARDEN_TRACE_LOG:=${TMPDIR:-/tmp}/garden-pr-$pr.trace}"
  exec 9>>"$GARDEN_TRACE_LOG"; export BASH_XTRACEFD=9; set -x
fi

# Decision oracle: ask a claude -p subagent a yes/no (or short) question. The
# supervisor can stub GARDEN_DECIDE for non-interactive runs/tests.
decide() {  # decide "<question>" -> prints the subagent's answer
  if [ -n "${GARDEN_DECIDE:-}" ]; then "$GARDEN_DECIDE" "$1"; return; fi
  claude -p "You are a garden gardener supervising PR #$pr. Answer concisely. $1"
}

fail() { echo "garden-pr #$pr: FAILED at $*" >&2; exit 1; }   # failures are loud

# --- stage: rebase (only if the base moved / branch is behind) --------------
if [ "$("$SENSE" any-change "$wt" "$base"; echo $?)" = 0 ]; then :; fi
# (rebase decision delegated; deterministic mechanics would live here)

# --- sense-gated automations (skip when a cheap signal says they can't matter)
run_if() {  # run_if <sense-test...> -- <command...>
  local -a test=() cmd=(); local sep=0
  for a in "$@"; do if [ "$a" = "--" ]; then sep=1; continue; fi
    if [ "$sep" = 0 ]; then test+=("$a"); else cmd+=("$a"); fi; done
  if "${test[@]}"; then "${cmd[@]}" || fail "${cmd[0]}"; fi
}

# docs automation only if Markdown actually changed
run_if "$SENSE" changed-md "$wt" "$base" -- true   # placeholder: e.g. lint-markdown "$wt"
# import-graph / dep automation only if an import line moved in the diff
run_if "$SENSE" diff-keyword "$wt" import "$base" -- true  # placeholder: e.g. check-deps "$wt"

# workstation-coupling fixer: ONLY when the deterministic detector finds the
# current user's home directory hardcoded in an ADDED diff line (cheap when
# clean; an LLM rewrite when it fires). The detector keys off $HOME dynamically,
# never a literal, so this gate and its handler stay clean under their own check.
# The transplanter juror seat is the semantic backstop for what the grep misses.
DETECT_HOME_COUPLING="$HERE/detect-home-coupling.sh"
: "${GARDEN_HOME_COUPLING_FIXER:=$HERE/../handlers/portability-coupling-claude.sh}"
run_if "$DETECT_HOME_COUPLING" check "$wt" "$base" -- "$GARDEN_HOME_COUPLING_FIXER" "$wt" "$base"

# comment-banner sweep: ONLY when the deterministic detector finds a decorative
# rule comment (a run of repeated dash/equals/etc.) in an ADDED diff line of a code
# file (cheap when clean; an LLM deletion when it fires). This is the gardening
# loop's copy of the no-comment-banners rule, joining the pre-push gate and the
# archivist juror seat; the archivist is the semantic backstop for what the grep
# misses.
DETECT_BANNERS="$HERE/detect-banners.sh"
: "${GARDEN_BANNER_FIXER:=$HERE/../handlers/banner-sweep-claude.sh}"
run_if "$DETECT_BANNERS" check "$wt" "$base" -- "$GARDEN_BANNER_FIXER" "$wt" "$base"

# --- evaluation/test gate BEFORE CI: err toward running everything -----------
# False positives are fine here; false negatives are not. We do NOT sense-gate
# the eval suite: we run it. The default eval runner is the deterministic local
# pre-PR verification harness (format/lint/build/test/docgen, silent on success,
# git-hash-capturing failures for selective inspection); see local-verify.sh and
# skills/local-verify/SKILL.md. A supervisor may override GARDEN_EVAL with a
# project-specific runner that takes the worktree as its single argument.
: "${GARDEN_EVAL:=$HERE/local-verify.sh}"
"$GARDEN_EVAL" "$wt" || fail "local verification (inspect the emitted blob SHAs)"

# --- push for CI (deterministic; mechanics elided in the scaffold) ----------
# git -C "$wt" push --force-with-lease ...   # supervisor/boatman owns identity

# --- loop decision ----------------------------------------------------------
ans="$(decide "CI is running for PR #$pr. Should I wait and loop, or stop here? Answer 'loop' or 'stop'.")"
case "$ans" in
  *loop*) echo "loop" ;;   # supervisor re-invokes
  *)      : ;;             # quiet success
esac
