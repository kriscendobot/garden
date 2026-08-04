#!/bin/bash
# elapsed-constancy-handler-stub.sh — a gardener job handler that runs for a
# controllable wall-time (GARDEN_STUB_SLEEP, default 3s), flushes a transient-claude
# signature to its stdout (which gardener.sh folds into $capture), then exits with a
# NON-signal, NON-timeout, NON-offline rc (default 1). It emulates an inner
# `claude -p` that deterministically OVERRUNS and dies the same way every cycle — a
# Claude Code session/usage cap tripping at the same point, or a prompt that always
# drives the CLI to the same failure — so the handler dies at a near-CONSTANT
# elapsed across requeue cycles. Used by elapsed-constancy-classifier-test.sh to
# prove gardener.sh's elapsed-constancy early-escalation flags the misclassification
# after ~2 cycles instead of waiting out the reaper's ~5-cycle doom threshold.
set -uo pipefail
base="${1:?base}"; jobfile="${2:?jobfile}"; report="${3:?report}"
# Burn a controllable amount of wall-clock so gardener.sh's elapsed measurement
# (SECONDS - handler_start) lands near the seeded prior-cycle elapsed values.
sleep "${GARDEN_STUB_SLEEP:-3}"
# A definitive transient-claude signature (the 2026-07-01 session-cap wording), so
# gardener.sh classifies the failure TRANSIENT via is_transient_claude_signature —
# the exact path the elapsed-constancy check second-guesses.
msg="${GARDEN_STUB_MESSAGE:-}"
[ -n "$msg" ] || msg="You've hit your session limit · resets 1:10am (UTC)"
printf '%s\n' "$msg"
# A non-signal, non-timeout, non-offline rc: NOT is_external_kill_rc/is_handler_timeout_rc,
# so the elapsed-constancy gate's rc exclusion does not drop it.
exit "${GARDEN_STUB_RC:-1}"
