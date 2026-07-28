#!/bin/bash
# panel-run-record-fixer-stub.sh — a deterministic GARDEN_PANEL_FIXER hook for
# panel-run-record-test.sh. Called by panel.sh as <worktree> <pr> <aggregate>. It
# "fixes" the diff by creating $FIX_MARKER, so the seat stub approves on the next
# round — modeling a must-fix→pass loop in exactly two rounds. When $FIX_MARKER is
# unset it is a genuine no-op (the never-converges / max-rounds path).
set -uo pipefail
[ -n "${FIX_MARKER:-}" ] && : > "$FIX_MARKER"
exit 0
