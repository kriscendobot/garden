#!/bin/bash
# panel-decide-stub.sh — a deterministic GARDEN_PANEL_DECIDE hook for
# panel-seat-retry-test.sh. Ignores its args (called as <aggregate-file> <pr>)
# and prints the disposition token from $DECIDE_VERDICT (default `pass`), so the
# panel's terminal path runs without a live `claude -p`. Committed in-repo so it
# is exec'able on a noexec test-scratch mount.
set -uo pipefail
# Optional transient flakiness (inert unless BOTH vars are set): exit NON-ZERO on
# the first $DECIDE_FAIL_TIMES invocations — a count persisted in $DECIDE_COUNT_FILE
# — then behave normally. Simulates the foreperson `claude -p` returning a transient
# non-zero exit (overload / rate-limit / 5xx), the failure that used to abort the
# whole panel under `set -e` (panel-decider-retry-test.sh).
if [ -n "${DECIDE_FAIL_TIMES:-}" ] && [ -n "${DECIDE_COUNT_FILE:-}" ]; then
  n=0; [ -f "$DECIDE_COUNT_FILE" ] && n="$(cat "$DECIDE_COUNT_FILE" 2>/dev/null || echo 0)"
  n=$((n + 1)); printf '%s' "$n" > "$DECIDE_COUNT_FILE"
  if [ "$n" -le "$DECIDE_FAIL_TIMES" ]; then
    echo "panel-decide-stub: simulated foreperson overload (invocation $n)" >&2
    exit 1
  fi
fi
printf '%s\n' "${DECIDE_VERDICT:-pass}"
