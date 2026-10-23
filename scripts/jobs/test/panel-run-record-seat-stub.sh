#!/bin/bash
# panel-run-record-seat-stub.sh — a deterministic GARDEN_PANEL_SEAT hook for
# panel-run-record-test.sh. It models a fix loop WITHOUT a live `claude -p`:
#
#   * If $FIX_MARKER exists (the fixer stub "fixed" the diff on a prior round) the
#     seat APPROVES.
#   * Otherwise it REQUESTS CHANGES, emitting a bullet finding whose TITLE the
#     record should capture AND a block of verbose prose carrying the sentinel
#     $PROSE_SENTINEL. The compact record must NOT leak it, while the fixer handoff
#     must retain it in full.
#
# $SEAT_MODE forces a fixed verdict regardless of the marker:
#   approve        — always approve (the clean-pass path)
#   request        — always request-changes (the never-converges / max-rounds path)
#   (unset)        — the marker-driven fix-loop path above
#
# Called by panel.sh as: <seat> <pr> <worktree> <base>.
set -uo pipefail
seat="${1:-seat}"

emit_request() {
  printf '### %s\n' "$seat"
  printf 'Verdict: request-changes\n'
  printf 'Findings:\n'
  printf -- '- %s must handle the empty-input case before merge\n' "$seat"
  printf '\n%s\n' "${PROSE_SENTINEL:-SEATPROSE}"
  printf 'A long paragraph of seat reasoning that must reach the fixer in full,\n'
  printf 'but must never propagate into the compact durable audit record.\n'
}
emit_approve() {
  printf '### %s\nVerdict: approve\nFindings: none\n' "$seat"
}

case "${SEAT_MODE:-}" in
  approve) emit_approve ;;
  request) emit_request ;;
  *)       if [ -e "${FIX_MARKER:-/nonexistent}" ]; then emit_approve; else emit_request; fi ;;
esac
exit 0
