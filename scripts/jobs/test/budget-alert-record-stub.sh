#!/bin/bash
# budget-alert-record-stub.sh — a GARDEN_ALERT_CMD stub for handler-budget-test.sh.
# alert_maintainer (common.sh) invokes it as `<cmd> <dedup-key> <message>`; it
# appends both to $GARDEN_ALERT_RECORD instead of routing to the maintainer inbox
# over the network, so the test can assert the escalation content offline.
set -uo pipefail
printf 'KEY=%s\nMSG=%s\n' "$1" "$2" >> "${GARDEN_ALERT_RECORD:?GARDEN_ALERT_RECORD unset}"
