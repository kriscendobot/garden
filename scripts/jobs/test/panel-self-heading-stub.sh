#!/bin/bash
# panel-self-heading-stub.sh — a deterministic GARDEN_PANEL_SEAT hook for
# panel-seat-self-heading-dedup-test.sh. It reproduces the doubled-heading
# template artifact: the seat narrates its process and then RE-HEADS its own block
# with `### <seat>` before the Verdict, on top of panel.sh's own `<summary>` heading
# (endojs/endo-but-for-bots#1281 round 6 assessor example). The aggregate must strip
# this seat-authored heading (and the throwaway preamble before it) so the posted
# review never shows the doubled heading. A UNIQUE finding line lets the test assert
# the real content still survives the strip.
#
# Kept as a committed in-repo file (not a /tmp heredoc) because the test scratch on
# this host is a noexec mount and panel.sh runs the hook directly.
# Called by panel.sh as: <seat> <pr> <worktree> <base>.
set -uo pipefail
seat="$1"
printf 'Now I have the block shape. I'\''ll produce the %s'\''s per-juror block.\n\n' "$seat"
printf '### %s\n\n' "$seat"
printf '**Verdict:** approve\n\n**Findings:**\n- unique-finding-from-%s\n' "$seat"
exit 0
