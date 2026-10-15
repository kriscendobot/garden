#!/bin/bash
# A staged gardener/panel job is claimable by native monk and cleric workers only.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
source "$HERE/test-fixture-helpers.sh"
PASS=0; FAIL=0
ok() { echo "PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "FAIL: $*"; FAIL=$((FAIL+1)); }

TR="$(mktemp -d "${TMPDIR:-/tmp}/panel-claim-eligibility.XXXXXX")"
trap 'rm -rf "$TR"' EXIT

check_kind() { # <kind> <claimed|left>
  local kind="$1" expected="$2" sub bare seed rc=0 got
  sub="$TR/$kind"; bare="$sub/journal.git"; seed="$sub/seed"
  mkdir -p "$sub"
  git init -q --bare "$bare"
  git init -q "$seed"; git -C "$seed" checkout -qb journal2
  mkdir -p "$seed"/{jobs/{todo,doin,tada,plan,index},work,repos,msgs,hosts,entries,schedules,cursors}
  printf -- '---\nrole: gardener\nhandler-budget-role: panel\nhandler-timeout: 10800\ntier: mentor\ndispatch: automatic\n---\npanel stage\n' \
    >"$seed/jobs/todo/panel-stage.md"
  seed_calibrated_test_pool "$seed" testhost "$kind"
  mkdir -p "$sub/usage-empty"
  git -C "$seed" add -A
  git -C "$seed" -c user.name=test -c user.email=test@test commit -qm seed
  git -C "$seed" remote add origin "$bare"
  git -C "$seed" push -q -u origin journal2

  got="$(GARDEN_TEST=1 GARDEN=testhost GARDEN_STATE="$sub/state" \
    GARDEN_WORKER_CLONE="$sub/clone" GARDEN_WORKER_KIND="$kind" \
    GARDEN_CCUSAGE_LOGDIR="$sub/usage-empty" \
    JOURNAL_REMOTE="$bare" JOURNAL_BRANCH=journal2 \
    "$JOBS/claim-job.sh" 1 2>"$sub/err")" || rc=$?
  if [ "$expected" = claimed ] && [ "$rc" -eq 0 ] && [ "$got" = panel-stage ]; then
    ok "$kind claims a 10800s handler-budget-role: panel stage"
  elif [ "$expected" = left ] && [ "$rc" -eq 3 ]; then
    ok "$kind remains ineligible for the native-provider panel stage"
  else
    bad "$kind expected $expected, got rc=$rc output='$got' err='$(tail -2 "$sub/err")'"
  fi
}

check_kind cleric claimed
check_kind monk claimed
check_kind hermit left
check_kind fireworker left

echo "panel-claim-eligibility-test: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
