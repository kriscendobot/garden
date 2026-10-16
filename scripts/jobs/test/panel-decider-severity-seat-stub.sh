#!/bin/bash
# panel-decider-severity-seat-stub.sh — a GARDEN_PANEL_SEAT hook for
# panel-decider-severity-test.sh: emits the fixture seat block named by
# DECIDER_SEVERITY_FIXTURE. Called by panel.sh as: <seat> <pr> <worktree> <base>.
set -uo pipefail
cat "$DECIDER_SEVERITY_FIXTURE"
