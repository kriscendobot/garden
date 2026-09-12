#!/bin/bash
# panel-record-capture-stub.sh — a GARDEN_PANEL_RECORD test stub. Instead of
# CAS-pushing a panel-run record to the journal, copy the rundir's composed
# `record-meta` to $RECORD_META_OUT so a test can assert the TERMINAL disposition
# panel.sh actually recorded (e.g. `decider-error` vs the default `error`). panel.sh
# invokes the record writer as `<writer> emit <rundir>`. Committed in-repo so it is
# exec'able on a noexec test-scratch mount.
set -uo pipefail
[ "${1:-}" = emit ] || exit 0
rundir="${2:-}"
[ -n "$rundir" ] || exit 0
if [ -n "${RECORD_META_OUT:-}" ] && [ -f "$rundir/record-meta" ]; then
  cp "$rundir/record-meta" "$RECORD_META_OUT" 2>/dev/null || true
fi
exit 0
