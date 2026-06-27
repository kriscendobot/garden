#!/bin/bash
# empty-output-classifier-test.sh — regression guard for the empty-output
# handler-failure classifier (gardener.sh transient-vs-real decision).
#
# Regression: the classifier used to treat ANY empty-output handler failure
# (`[ ! -s "$capture" ]`) as a transient blip, ignoring the handler's exit code.
# That silently requeued DETERMINISTIC failures — notably rc=127/126 (missing /
# non-executable external tool, the 2026-06-24/25 jq-outage signature) and bare
# rc=1/2 — as if they were self-resolving, deferring human escalation to the
# reaper's multi-hour poison cycle. The fix gates the empty-capture `transient=1`
# on the exit code being a genuine signal/clean-shutdown (143 SIGTERM, 130 SIGINT,
# 137 SIGKILL) or the offline rc (GARDEN_OFFLINE_RC), mirroring the discrimination
# in self-heal-run.sh:121. The decision lives in the pure helper
# is_transient_empty_failure (common.sh); this test drives it directly.
#
# Usage: empty-output-classifier-test.sh
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }

# Scrub ambient fleet env so a live gardener invoking this test cannot splice its
# own GARDEN_* state (notably GARDEN_OFFLINE_RC) underneath the fixture.
unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_|XDG_)' || true) 2>/dev/null || true

# shellcheck source=../common.sh
source "$JOBS/common.sh"

# transient (return 0) → progress note, no escalation; the gardener emits a
# kind:progress note and leaves the job in doin for the TTL requeue.
# deterministic (return 1) → the real-failure path: capture-by-hash + gardener
# inbox escalation.
assert_transient() {  # assert_transient <rc> <why>
  if is_transient_empty_failure "$1"; then
    ok "rc=$1 empty → transient/no-escalation ($2)"
  else
    bad "rc=$1 empty classified DETERMINISTIC; expected transient ($2)"
  fi
}
assert_escalate() {  # assert_escalate <rc> <why>
  if is_transient_empty_failure "$1"; then
    bad "rc=$1 empty classified transient; expected escalation ($2)"
  else
    ok "rc=$1 empty → escalated ($2)"
  fi
}

hr; echo "SUBTEST 1 — signal/clean-shutdown + offline codes are transient"; hr
assert_transient 143 "SIGTERM — systemd stop / killed mid-call"
assert_transient 130 "SIGINT"
assert_transient 137 "SIGKILL — OOM / hard kill"
assert_transient 75  "offline rc (GARDEN_OFFLINE_RC default 75 EX_TEMPFAIL)"

hr; echo "SUBTEST 2 — deterministic non-signal codes escalate immediately"; hr
assert_escalate 127 "missing external tool — the jq-outage signature"
assert_escalate 126 "non-executable external tool"
assert_escalate 1   "bare failure"
assert_escalate 2   "bare failure / usage error"

hr; echo "SUBTEST 3 — a custom GARDEN_OFFLINE_RC is honored as transient"; hr
# The offline rc is configurable; the helper must read it, not hardcode 75.
GARDEN_OFFLINE_RC=64 assert_transient 64 "custom offline rc honored"
# ...and with it remapped, the default 75 is now just another deterministic code.
GARDEN_OFFLINE_RC=64 assert_escalate 75 "old default 75 escalates once offline rc moved"

hr
echo "RESULTS: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
