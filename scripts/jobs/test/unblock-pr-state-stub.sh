#!/bin/bash
# unblock-pr-state-stub.sh — deterministic PR-state reader for the unblock test.
# Invoked as "<owner/repo> <pr-number>"; prints "<state>\t<merged>" read from the
# file named by $UNBLOCK_PR_STATE_FILE (e.g. "open\tfalse" or "closed\ttrue"), so
# a test can flip a PR from open to merged/closed between unblock ticks. Fails if
# the file is unset/missing, mirroring the real reader's refuse-to-guess discipline.
set -euo pipefail
: "${1:?usage: unblock-pr-state-stub.sh <owner/repo> <pr-number>}"
: "${2:?usage: unblock-pr-state-stub.sh <owner/repo> <pr-number>}"
: "${UNBLOCK_PR_STATE_FILE:?set UNBLOCK_PR_STATE_FILE}"
[ -f "$UNBLOCK_PR_STATE_FILE" ] || { echo "no state file" >&2; exit 1; }
cat "$UNBLOCK_PR_STATE_FILE"
