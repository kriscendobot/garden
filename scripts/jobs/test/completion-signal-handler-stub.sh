#!/bin/bash
# completion-signal-handler-stub.sh — a gardener job handler that lets a test
# drive the DETERMINISTIC completion signal (common.sh § job completion signal)
# independently of the exit code, to exercise gardener.sh's doin→tada gate.
#
# Knobs (env):
#   GARDEN_STUB_RC          exit code (default 0)
#   GARDEN_STUB_SIGNAL      1 → write the completion sentinel (a genuine
#                           completion); anything else → do NOT (an exit-0-
#                           unsatisfying / killed / errored run).
#   GARDEN_STUB_CAPTURE     text emitted to stdout+stderr (folded into $capture by
#                           gardener.sh) so the non-zero classifier can see an API/
#                           rate-limit/quota transient signature.
#   GARDEN_STUB_REPORT      exact report body, used to model a provider envelope
#                           written to the report while captured stdout stays empty.
#   GARDEN_STUB_ADVANCE_HEAD 1 → make a commit in this job's garden worktree
#                           ($GARDEN_SCRATCH/gardener-wt-<base>) to model a handler
#                           that pushed real work this cycle (the productive-cycle
#                           signal). No-op unless the worktree already exists as a git
#                           repo (a RESUMED worktree persisted from a prior cycle).
#   GARDEN_STUB_ORCHESTRATION_FAILED 1 → make the exact failure signal the
#                           report's last line; gardener.sh must translate it to
#                           stamped frontmatter during completion.
#   GARDEN_STUB_HANDOFF_SUCCESSOR <base> -> emit the exact handoff disposition.
#   GARDEN_STUB_COMPLETION_MARKER 1 -> append the completion marker as the
#                           report's last line (a worker that reached its final
#                           act) regardless of GARDEN_STUB_SIGNAL/RC.
#   GARDEN_STUB_CALL_LOG     optional file receiving one basename per invocation.
#   GARDEN_STUB_POST_RESULT  <body> -> post a `result` journal entry with this body
#                           through journal-entry.sh (as a worker does before its
#                           final report), under the claim env gardener.sh exports.
#   GARDEN_STUB_RESULT_FP    override the claim fingerprint that result is stamped
#                           with (models a predecessor claim's record).
#
# Used by completion-signal-test.sh and productive-cycle-test.sh.
set -uo pipefail
base="${1:?base}"; jobfile="${2:?jobfile}"; report="${3:?report}"

[ -n "${GARDEN_STUB_CALL_LOG:-}" ] && printf '%s\n' "$base" >> "$GARDEN_STUB_CALL_LOG"

if [ -n "${GARDEN_STUB_REPORT:-}" ]; then
  printf '%s\n' "$GARDEN_STUB_REPORT" > "$report"
else
  printf '# report for %s\nstub handler ran\n' "$base" > "$report"
fi
[ "${GARDEN_STUB_ORCHESTRATION_FAILED:-0}" = "1" ] \
  && printf '%s\n' '<<<GARDEN-ORCHESTRATION-FAILED>>>' >> "$report"
[ "${GARDEN_STUB_ORCHESTRATION_AUTH_UNAVAILABLE:-0}" = "1" ] \
  && printf '%s\n' '<<<GARDEN-ORCHESTRATION-AUTH-UNAVAILABLE>>>' >> "$report"
[ -n "${GARDEN_STUB_HANDOFF_SUCCESSOR:-}" ] \
  && printf '<<<GARDEN-JOB-HANDED-OFF: %s>>>\n' "$GARDEN_STUB_HANDOFF_SUCCESSOR" >> "$report"
[ "${GARDEN_STUB_COMPLETION_MARKER:-0}" = "1" ] \
  && printf '%s\n' '<<<GARDEN-JOB-COMPLETE>>>' >> "$report"
[ -n "${GARDEN_STUB_CAPTURE:-}" ] && { echo "$GARDEN_STUB_CAPTURE"; echo "$GARDEN_STUB_CAPTURE" >&2; }

if [ -n "${GARDEN_STUB_POST_RESULT:-}" ]; then
  printf '%s\n' "$GARDEN_STUB_POST_RESULT" \
    | GARDEN_JOB_CLAIM_FP="${GARDEN_STUB_RESULT_FP:-${GARDEN_JOB_CLAIM_FP:-}}" GARDEN_ROLE=builder \
      "$(dirname "${BASH_SOURCE[0]}")/../journal-entry.sh" result >/dev/null 2>&1
fi

# Model real per-cycle progress: advance the persisted garden worktree's HEAD.
if [ "${GARDEN_STUB_ADVANCE_HEAD:-0}" = "1" ] && [ -n "${GARDEN_SCRATCH:-}" ]; then
  wt="$GARDEN_SCRATCH/gardener-wt-$base"
  if [ -e "$wt/.git" ]; then
    printf 'work at %s\n' "$(date -u +%s%N)" >> "$wt/progress.txt"
    git -C "$wt" add -A >/dev/null 2>&1 || true
    git -C "$wt" -c user.name=test -c user.email=test@localhost \
      commit -q -m "stub: real progress this cycle" >/dev/null 2>&1 || true
  fi
fi

# Emit the completion sentinel ONLY when told to model a genuine completion.
if [ "${GARDEN_STUB_SIGNAL:-0}" = "1" ] && [ -n "${GARDEN_COMPLETION_SENTINEL:-}" ]; then
  : > "$GARDEN_COMPLETION_SENTINEL"
fi

exit "${GARDEN_STUB_RC:-0}"
