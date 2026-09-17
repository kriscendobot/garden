#!/bin/bash
# panel-details-verdict-stub.sh — a deterministic GARDEN_PANEL_SEAT hook for
# panel-details-disclosure-test.sh. It emits a per-juror block whose Verdict line
# varies BY SEAT NAME, so the test can assert that the aggregate's <summary> carries
# each seat's own verdict (and that the extractor normalizes the three canonical
# tokens, including a space form → hyphen form):
#
#   assessor -> **Verdict:** request-changes
#   breaker  -> Verdict: comment only        (space form; normalizes to comment-only)
#   stylist  -> **Verdict:** approve
#   <other>  -> **Verdict:** approve
#
# Kept as a committed in-repo file (not a /tmp heredoc) because the test scratch on
# this host is a noexec mount and panel.sh runs the hook directly.
# Called by panel.sh as: <seat> <pr> <worktree> <base>.
set -uo pipefail
seat="$1"
case "$seat" in
  assessor) verdict='**Verdict:** request-changes' ;;
  breaker)  verdict='Verdict: comment only' ;;
  *)        verdict='**Verdict:** approve' ;;
esac
printf '%s\n\n**Findings:**\n- none of note from %s\n' "$verdict" "$seat"
exit 0
