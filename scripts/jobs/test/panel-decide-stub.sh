#!/bin/bash
# panel-decide-stub.sh — a deterministic GARDEN_PANEL_DECIDE hook for
# panel-seat-retry-test.sh. Ignores its args (called as <aggregate-file> <pr>)
# and prints the disposition token from $DECIDE_VERDICT (default `pass`), so the
# panel's terminal path runs without a live `claude -p`. Committed in-repo so it
# is exec'able on a noexec test-scratch mount.
set -uo pipefail
printf '%s\n' "${DECIDE_VERDICT:-pass}"
