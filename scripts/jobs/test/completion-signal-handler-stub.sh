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
#   GARDEN_STUB_ADVANCE_HEAD 1 → make a commit in this job's garden worktree
#                           ($GARDEN_SCRATCH/gardener-wt-<base>) to model a handler
#                           that pushed real work this cycle (the productive-cycle
#                           signal). No-op unless the worktree already exists as a git
#                           repo (a RESUMED worktree persisted from a prior cycle).
#   GARDEN_STUB_ORCHESTRATION_FAILED 1 → make the exact failure signal the
#                           report's last line; gardener.sh must translate it to
#                           stamped frontmatter during completion.
#
# Used by completion-signal-test.sh and productive-cycle-test.sh.
set -uo pipefail
base="${1:?base}"; jobfile="${2:?jobfile}"; report="${3:?report}"

printf '# report for %s\nstub handler ran\n' "$base" > "$report"
[ "${GARDEN_STUB_ORCHESTRATION_FAILED:-0}" = "1" ] \
  && printf '%s\n' '<<<GARDEN-ORCHESTRATION-FAILED>>>' >> "$report"
[ -n "${GARDEN_STUB_CAPTURE:-}" ] && { echo "$GARDEN_STUB_CAPTURE"; echo "$GARDEN_STUB_CAPTURE" >&2; }

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
