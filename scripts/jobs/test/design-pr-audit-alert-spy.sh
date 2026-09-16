#!/bin/bash
# design-pr-audit-alert-spy.sh — a GARDEN_ALERT_CMD sink for the readiness-audit test.
# alert_maintainer invokes it as: <cmd> <key> <msg> <count> <first-seen>. Append the
# key + message to $GARDEN_AUDIT_ALERT_LOG so the test can assert which PRs alerted.
# Committed (not generated under $TMPDIR) because /tmp is mounted noexec in CI.
set -euo pipefail
printf '%s\t%s\n' "${1:-}" "${2:-}" >> "${GARDEN_AUDIT_ALERT_LOG:?}"
exit 0
