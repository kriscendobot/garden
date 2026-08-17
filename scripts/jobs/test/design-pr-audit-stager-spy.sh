#!/bin/bash
# design-pr-audit-stager-spy.sh — a GARDEN_DPGCA_POST_GAUNTLET spy for
# design-pr-gauntlet-coverage-audit-test.sh. Records every invocation's args to
# $GARDEN_DPGCA_STAGE_LOG (so the test can assert on which PRs the audit DECIDED to
# stage — its own skip logic, independent of post-gauntlet.sh's dedup) and then
# forwards to the real stager at $GARDEN_DPGCA_REAL_POST_GAUNTLET so the on-journal
# records the record_count assertions read still get written. Committed (not under
# $TMPDIR) because /tmp is mounted noexec in CI.
set -euo pipefail
printf '%s\n' "$*" >>"${GARDEN_DPGCA_STAGE_LOG:?spy needs GARDEN_DPGCA_STAGE_LOG}"
exec "${GARDEN_DPGCA_REAL_POST_GAUNTLET:?spy needs GARDEN_DPGCA_REAL_POST_GAUNTLET}" "$@"
