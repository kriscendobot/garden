#!/bin/bash
# panel-parallel-fanout-stub.sh — a deterministic GARDEN_PANEL_SEAT hook for
# panel-parallel-fanout-test.sh. It emits a seat-identifying verdict block, and
# while it runs it records its own presence so the test can observe how many
# seats were IN FLIGHT at once:
#
#   $FAN_DIR/inflight/<seat>   a marker file that exists for the seat's lifetime
#   $FAN_DIR/inflight.log      one line per invocation: the in-flight count seen
#
# Counting marker files (each written by exactly one seat) and appending a short
# line (atomic under O_APPEND) needs no locking, so the observation itself does
# not serialize the thing it is measuring.
#
# Env: FAN_DIR (required), FAN_SLEEP (seconds of work per seat, default 0),
#      FAN_FAIL_SEAT (a seat that always exits 0 with EMPTY stdout — the
#      0-byte-but-exit-0 signature the retry logic guards against).
#
# Kept as a committed in-repo file (not a /tmp heredoc) because the test scratch
# on this host is a noexec mount and panel.sh runs the hook directly.
# Called by panel.sh as: <seat> <pr> <worktree> <base>.
set -uo pipefail
seat="$1"
mkdir -p "$FAN_DIR/inflight"
: > "$FAN_DIR/inflight/$seat"
n=$(find "$FAN_DIR/inflight" -type f | wc -l)
echo "$n" >> "$FAN_DIR/inflight.log"
sleep "${FAN_SLEEP:-0}"
rm -f "$FAN_DIR/inflight/$seat"
[ "$seat" = "${FAN_FAIL_SEAT:-}" ] && exit 0
printf 'Verdict: approve\nFindings: none from %s\n' "$seat"
exit 0
