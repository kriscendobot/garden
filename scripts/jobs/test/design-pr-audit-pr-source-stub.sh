#!/bin/bash
# design-pr-audit-pr-source-stub.sh — a GARDEN_DPGCA_PR_SOURCE fixture for
# design-pr-gauntlet-coverage-audit-test.sh. Emits one TSV line per open PR
# (number author head_repo updated_at title) for the repo it is asked about, the
# same contract as handlers/ci-pr-source-gh.sh. Committed (not generated under
# $TMPDIR) because /tmp is mounted noexec in CI, so an executable stub must live on
# the repo filesystem.
set -euo pipefail
repo="${1:?usage: design-pr-audit-pr-source-stub.sh <owner/name> [bot-login]}"
tab=$'\t'
row() { printf '%s%s%s%s%s%s%s%s%s\n' "$1" "$tab" "$2" "$tab" "$3" "$tab" "$4" "$tab" "$5"; }
case "$repo" in
  kriscendobot/minion.town)
    row 47 kriscendobot "$repo" 2026-08-16T00:00:00Z 'ocap redesign (design)'
    row 48 kriscendobot "$repo" 2026-08-16T00:00:00Z 'already-covered design'
    row 49 kriscendobot "$repo" 2026-08-16T00:00:00Z 'fix a bug'
    row 50 interloper   "$repo" 2026-08-16T00:00:00Z 'not the bot design'
    row 51 kriscendobot "$repo" 2026-08-16T00:00:00Z 'probe design'
    row 54 kriscendobot "$repo" 2026-08-16T00:00:00Z 'metadata read hangs'
    row 52 kriscendobot "$repo" 2026-08-16T00:00:00Z 'draft design doc'
    row 53 kriscendobot "$repo" 2026-08-16T00:00:00Z 'design with a COMPLETED gauntlet'
    if [ "${GARDEN_TEST_FRESH_PRS:-0}" = 1 ]; then
      row 55 kriscendobot "$repo" 2099-01-01T00:00:00Z 'fresh ready PR one'
      row 56 kriscendobot "$repo" 2099-01-01T00:00:01Z 'fresh ready PR two'
      row 57 kriscendobot "$repo" 2099-01-01T00:00:02Z 'fresh ready PR over cap'
    fi
    ;;
  kriscendobot/garden)
    # The garden's own repo: a bot-authored design PR that MUST be excluded.
    row 28 kriscendobot "$repo" 2026-08-16T00:00:00Z 'garden own design'
    ;;
esac
