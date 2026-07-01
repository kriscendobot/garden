#!/bin/bash
# claude-session-limit-handler-stub.sh — a gardener job handler that flushes the
# Claude Code session/usage-cap message to its stdout (which gardener.sh diverts
# into $capture) and then exits with a NON-signal, NON-timeout, NON-offline rc
# (default 1), emulating an inner `claude -p` that failed because the host's
# 5-hour session limit was hit. The message names its own reset time, so the
# failure is a definitive self-resolving transient: requeuing past the reset
# succeeds. Used by claude-session-limit-classifier-test.sh to prove the
# transient-signature classifier (is_transient_claude_signature) treats this
# capture as transient rather than a handler-nonzero real-failure defect.
#
# This reproduces the 2026-07-01T00:26–00:50Z endolinbot2 incident where 9
# unrelated gardener jobs failed with the byte-identical capture below and, since
# the wording matched none of the then-current transient alternatives, every one
# was falsely escalated to the gardener inbox as a lane-0 handler-nonzero defect.
set -uo pipefail
base="${1:?base}"; jobfile="${2:?jobfile}"; report="${3:?report}"
# The exact captured string from the incident (blob 35b3d8ab…). GARDEN_STUB_MESSAGE
# can override it to exercise wording variants. Assigned in two steps (not a
# `${VAR:-default}` word) because the default carries an apostrophe, which bash
# mis-parses inside a double-quoted parameter-expansion default.
msg="${GARDEN_STUB_MESSAGE:-}"
[ -n "$msg" ] || msg="You've hit your session limit · resets 1:10am (UTC)"
printf '%s\n' "$msg"
# A non-signal, non-timeout, non-offline rc: the path where the ONLY thing that can
# rescue the job from the real-failure branch is the transient-signature match.
exit "${GARDEN_STUB_RC:-1}"
