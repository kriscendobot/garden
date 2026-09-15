#!/bin/bash
# panel-per-section-provenance-stub.sh — a deterministic GARDEN_PANEL_SEAT_PROVENANCE
# hook for panel-per-section-provenance-test.sh. panel.sh calls it once per seat as
# it aggregates that seat's block, to obtain the seat's per-section footnote. This
# stub maps each seat to DISTINCT provenance facts (a different model/harness/
# provider, or `automatic` for a seat that ran deterministically), so the test can
# assert the aggregate carries one distinct footnote per section rather than one
# whole-body footer that misattributes every seat but one.
#
# It sources the REAL provenance library so the rendering under test is the real
# provenance_footnote / provenance_footnote_for_kind, not a hand-rolled string.
# Committed in-repo (not a /tmp heredoc) because the test scratch on this host is a
# noexec mount and panel.sh runs the hook directly. Called as: <seat>.
set -uo pipefail
seat="$1"
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
# shellcheck source=/dev/null
. "$ROOT/scripts/jobs/comment-provenance.sh"
case "$seat" in
  assessor) provenance_footnote_for_kind "claude-opus-5" "monk" ;;    # anthropic/claude
  typist)   provenance_footnote_for_kind "gpt-5" "cleric" ;;          # openai/codex
  stylist)  provenance_footnote "" "" "" 1 ;;                          # deterministic → automatic
  *)        provenance_footnote_for_kind "claude-sonnet-5" "gardener" ;;
esac
