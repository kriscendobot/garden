#!/bin/bash
# panel-hook-record-stub.sh — a deterministic GARDEN_PANEL_FIXER / GARDEN_PANEL_UNDRAFT
# hook for panel-single-round-test.sh. It records that it RAN by appending one line
# (its basename plus the args panel.sh passed) to $PANEL_HOOK_LOG, then exits 0. Both
# the fixer hook (called `<wt> <pr> <agg>`) and the un-draft hook (called `<pr>`) point
# at this one stub; the differing arg count in the log distinguishes which ran. The
# staged-gauntlet single-round mode must run NEITHER, so the test asserts the log file
# was never created. Committed in-repo (not a /tmp heredoc) because the test scratch on
# this host is a noexec mount and panel.sh runs the hooks directly.
set -uo pipefail
printf '%s %s\n' "$(basename "$0")" "$*" >> "${PANEL_HOOK_LOG:?PANEL_HOOK_LOG unset}"
exit 0
