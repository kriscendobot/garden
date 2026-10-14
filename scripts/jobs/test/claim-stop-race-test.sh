#!/bin/bash
# claim-stop-race-test.sh — regression guard for a SIGTERM that lands while
# claim-job.sh runs (gardener.sh, the post-claim stop check).
#
# bash defers the gardener's TERM trap until the foreground claim returns, so the
# top-of-loop stop check has already passed. Before the fix the gardener went on to
# run the freshly claimed job, and a deploy's `systemctl restart` of that worker
# waited for the whole handler budget (oros, 2026-10-14). The gardener must instead
# leave the handler unstarted, stamp the reap-now hint on its claim, and exit 0.
#
# Usage: claim-stop-race-test.sh
set -euo pipefail
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }

unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_|XDG_)' || true) 2>/dev/null || true

TR="$(mktemp -d "${TMPDIR:-/tmp}/garden-claimstop.XXXXXX")"; trap 'rm -rf "$TR"' EXIT
git_id=(-c user.name=test -c user.email=test@localhost)
BRANCH=journal2
# shellcheck source=test-fixture-helpers.sh
source "$HERE/test-fixture-helpers.sh"

BARE="$TR/journal.git"; SEED="$TR/seed"
git init -q --bare "$BARE"
git init -q "$SEED"; git -C "$SEED" checkout -q -b "$BRANCH"
( cd "$SEED"
  for d in jobs/todo jobs/doin jobs/tada work repos msgs hosts entries schedules cursors; do
    mkdir -p "$d"; touch "$d/.gitkeep"
  done
  printf -- '---\ntier: mentor\ndispatch: automatic\n---\n# racejob\n\ndo the work\n' > jobs/todo/racejob.md )
seed_calibrated_test_pool "$SEED" racehost monk
git -C "$SEED" add -A
git -C "$SEED" "${git_id[@]}" commit -q -m "seed"
git -C "$SEED" remote add origin "$BARE"
git -C "$SEED" push -q -u origin "$BRANCH"

RAN="$TR/handler-ran"
rc=0
env JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH="$BRANCH" \
    GARDEN="racehost" GARDEN_STATE="$TR/state" \
    GARDEN_ONESHOT=1 GARDEN_IDLE_SLEEP=1 \
    GARDEN_CLAIM_JOB_CMD="$HERE/claim-term-stub.sh" \
    GARDEN_JOB_HANDLER="$HERE/handler-ran-marker-stub.sh" GARDEN_STUB_RAN="$RAN" \
    "$JOBS/gardener.sh" 1 > "$TR/gardener.log" 2>&1 || rc=$?

[ "$rc" -eq 0 ] && ok "gardener exited 0 (clean stop)" || bad "gardener exited rc=$rc. log: $(tail -5 "$TR/gardener.log")"
if grep -q "stop requested during the claim of 'racejob'" "$TR/gardener.log"; then
  ok "stop during the claim was noticed"
else
  bad "no post-claim stop log line. log: $(tail -5 "$TR/gardener.log")"
fi
[ ! -e "$RAN" ] && ok "handler was never started" || bad "handler ran despite the pending stop"

V="$TR/verify"; git clone -q --single-branch --branch "$BRANCH" "$BARE" "$V" 2>/dev/null
if [ -f "$V/jobs/doin/racejob.md" ] && grep -q '^<!-- garden-reap-now -->$' "$V/jobs/doin/racejob.md"; then
  ok "claim left in doin with the reap-now hint for the reaper"
else
  bad "claim not in doin with reap-now hint (doin=$([ -f "$V/jobs/doin/racejob.md" ] && echo y || echo n))"
fi

echo "claim-stop-race-test: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
