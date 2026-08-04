#!/bin/bash
# empty-output-classifier-test.sh — regression guard for the empty-output
# handler-failure classifier (gardener.sh transient-vs-real decision).
#
# Regression: the classifier used to treat ANY empty-output handler failure
# (`[ ! -s "$capture" ]`) as a transient blip, ignoring the handler's exit code.
# That silently requeued DETERMINISTIC failures — notably rc=127/126 (missing /
# non-executable external tool, the 2026-06-24/25 jq-outage signature) and bare
# rc=1/2 — as if they were self-resolving, deferring human escalation to the
# reaper's multi-hour doom cycle. The fix gates the empty-capture `transient=1`
# on the exit code being a genuine signal/clean-shutdown (143 SIGTERM, 130 SIGINT,
# 137 SIGKILL) or the offline rc (GARDEN_OFFLINE_RC), mirroring the discrimination
# in self-heal-run.sh:121. The decision lives in the pure helper
# is_transient_empty_failure (common.sh); this test drives it directly.
#
# Usage: empty-output-classifier-test.sh
set -euo pipefail
# Explicit positive test-context sentinel: protects this standalone suite even when
# invoked outside the test-tree entrypoint heuristic.
export GARDEN_TEST=1
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

hr; echo "SUBTEST 4 — the transient progress line carries the reaper's requeue-cycle count"; hr
# A transiently-failing job looks identical on its 1st and 5th requeue, so a job
# that dies the SAME way every cycle (a wedged fetch, an OOM) stays invisible until
# the reaper's ~5×TTL doom threshold (~5h). The gardener now folds the reaper's
# already-present `<!-- garden-reaped: N -->` marker (read-only, defaulting to 0)
# into the transient note so the cycle is greppable in the journal immediately.
# reap_count does the extraction; assert it AND that the count surfaces in the line
# the gardener formats.
tmpd="$(mktemp -d)"; trap 'rm -rf "$tmpd"' EXIT
# Reproduce the gardener's transient note exactly, parameterized on the cycle, so
# the test fails if the line ever stops carrying the count.
transient_line() {  # transient_line <jobfile>
  local cyc; cyc="$(reap_count "$1")"
  printf 'gardener-7 on host: job demo handler exited rc=143 with empty/transient-signature output; transient handler outage (requeue cycle %s); left in doin for TTL requeue (no escalation)' "$cyc"
}
assert_cycle() {  # assert_cycle <jobfile> <expected> <why>
  local got; got="$(reap_count "$1")"
  if [ "$got" = "$2" ] && case "$(transient_line "$1")" in *"requeue cycle $2"*) true;; *) false;; esac; then
    ok "reap_count=$got and line carries 'requeue cycle $2' ($3)"
  else
    bad "reap_count='$got' / line='$(transient_line "$1")'; expected count $2 ($3)"
  fi
}
# absent marker → first-pass job → cycle 0 (default, not blank).
printf 'do the thing\n' > "$tmpd/no-marker.md"
assert_cycle "$tmpd/no-marker.md" 0 "no marker defaults to 0"
# a marker present → its count surfaces in the line.
printf 'do the thing\n\n<!-- garden-reaped: 3 -->\n' > "$tmpd/reaped.md"
assert_cycle "$tmpd/reaped.md" 3 "single marker N=3"
# defensive `tail -1`: if multiple markers ever coexist, the LAST wins (mirrors
# reaper.sh's own extraction).
printf 'body\n\n<!-- garden-reaped: 1 -->\n\n<!-- garden-reaped: 4 -->\n' > "$tmpd/multi.md"
assert_cycle "$tmpd/multi.md" 4 "last of multiple markers wins"
# a missing file is treated as cycle 0, never an error.
assert_cycle "$tmpd/does-not-exist.md" 0 "missing file defaults to 0"

hr
echo "RESULTS: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
