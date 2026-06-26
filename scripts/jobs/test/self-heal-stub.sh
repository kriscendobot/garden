#!/bin/bash
# self-heal-stub.sh — a deterministic stand-in for the self-heal responder
# (handlers/self-heal-claude.sh) used by run-test.sh. It records each invocation
# and its arguments to $SELF_HEAL_STUB_CALLS so the test can assert that the
# wrapper invoked the responder the right number of times with the right SHA,
# context, exit code, and work-id — without spawning a real `claude -p`.
#
# Invoked as: self-heal-stub.sh <sha> <clone-dir> <context> <rc> [work-id] [role]
set -euo pipefail
printf 'RESPONDER sha=%s clone=%s ctx=%s rc=%s workid=%s role=%s\n' \
  "${1:-}" "${2:-}" "${3:-}" "${4:-}" "${5:-}" "${6:-}" >> "${SELF_HEAL_STUB_CALLS:-/dev/null}"
exit 0
