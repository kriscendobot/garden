#!/bin/bash
# panel-seat-retry-stub.sh — a deterministic GARDEN_PANEL_SEAT hook for
# panel-seat-retry-test.sh. Counts its invocations in $SEAT_COUNTER and emits a
# real verdict block only once the count reaches $SEAT_SUCCEED_AT — otherwise it
# exits 0 with EMPTY stdout, the exact 0-byte-but-exit-0 signature of the bug the
# retry-on-empty seat fan-out guards against. Kept as a committed in-repo file
# (not a /tmp heredoc) because the test scratch on some hosts is a noexec mount.
# Called by panel.sh as: <seat> <pr> <worktree> <base>.
set -uo pipefail
n=$(cat "$SEAT_COUNTER" 2>/dev/null || echo 0); n=$((n + 1)); echo "$n" > "$SEAT_COUNTER"
if [ "$n" -ge "${SEAT_SUCCEED_AT:-999999}" ]; then
  printf '### seat verdict\nVerdict: approve\nFindings: none\n'
fi
exit 0
