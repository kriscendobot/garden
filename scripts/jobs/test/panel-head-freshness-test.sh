#!/bin/bash
# Re-litigation for post-gauntlet-fixer-change-unreviewed: exact panel-head vs
# presented-head sensing across fixer, shepherd, and designer historical deltas.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
ROOT="$(cd "$JOBS/../.." && pwd)"
SENSOR="$JOBS/assert-panel-head-fresh.sh"
TR="$(mktemp -d "${TMPDIR:-/tmp}/panel-head-freshness.XXXXXX")"
trap 'rm -rf "$TR"' EXIT
fail() { echo "FAIL: $*" >&2; exit 1; }

run_compare() {
  set +e
  "$SENSOR" compare "$1" "$2" "$3" >"$TR/out" 2>"$TR/err"
  RC=$?
  set -e
}

echo '== historical re-litigation =='
run_compare b28bb1fc3 a4767d542b49f67dbae326482e8be80774e3e289 endojs/endo-but-for-bots#475
if [ "$RC" -ne 10 ] || ! grep -q 'disposition=review-required' "$TR/out"; then
  fail '#475 fixer delta was not flagged'
fi
run_compare 7d23bf082 1ec375e2dc9935bc1f2e7502b424ae37494e3926 endojs/endo-but-for-bots#858
if [ "$RC" -ne 10 ] || ! grep -q 'disposition=review-required' "$TR/out"; then
  fail '#858 shepherd delta was not flagged'
fi
run_compare 4e1696a4 8515b8cdef24aa26e8382bcc68b28f3295958883 endojs/endo-but-for-bots#1226
if [ "$RC" -ne 10 ] || ! grep -q 'disposition=review-required' "$TR/out"; then
  fail '#1226 designer rewrite was not flagged'
fi

echo '== negative controls =='
run_compare 4e1696a4ba0f0a615debfa342ae95f93df8bf580 4e1696a4ba0f0a615debfa342ae95f93df8bf580 no-post-panel-delta
if [ "$RC" -ne 0 ] || ! grep -q 'disposition=covered' "$TR/out"; then
  fail 'equal reviewed/presented heads did not pass'
fi
# A title/body/label/comment-only edit does not alter the Git commit identity.
run_compare 7d23bf0820e0364bb33906aeb9c46bc52c802c80 7d23bf0820e0364bb33906aeb9c46bc52c802c80 metadata-only-delta
if [ "$RC" -ne 0 ] || ! grep -q 'disposition=covered' "$TR/out"; then
  fail 'metadata-only (unchanged head) control did not pass'
fi
# A commit described as metadata-only still moves the head. The deterministic
# layer cannot safely bless its contents (workflow and design files disproved
# that shortcut), so it routes the judgment to review.
run_compare eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee ffffffffffffffffffffffffffffffffffffffff metadata-only-commit
if [ "$RC" -ne 10 ] || ! grep -q 'disposition=review-required' "$TR/out"; then
  fail 'metadata-only commit did not conservatively route to review'
fi

echo '== journal discovery and completion routing =='
git init -q --bare "$TR/journal.git"
git init -q "$TR/seed"
git -C "$TR/seed" checkout -q -b journal2
mkdir -p "$TR/seed/panel-runs/endojs-endo-but-for-bots-475" \
  "$TR/seed/panel-runs/endojs-endo-but-for-bots-858" \
  "$TR/seed/panel-runs/endojs-endo-but-for-bots-1226" \
  "$TR/seed/panel-runs/endojs-endo-but-for-bots-200" \
  "$TR/seed/panel-runs/endojs-endo-but-for-bots-202" \
  "$TR/seed/panel-runs/endojs-endo-but-for-bots-203"
cat >"$TR/seed/panel-runs/endojs-endo-but-for-bots-475/old.md" <<'EOF'
---
disposition: passed
---
## Round 1 — head `b28bb1fc`
EOF
cat >"$TR/seed/panel-runs/endojs-endo-but-for-bots-858/old.md" <<'EOF'
---
disposition: passed
reviewed_head: 7d23bf0820e0364bb33906aeb9c46bc52c802c80
---
EOF
cat >"$TR/seed/panel-runs/endojs-endo-but-for-bots-1226/old.md" <<'EOF'
---
disposition: must-fix
reviewed_head: 4e1696a4ba0f0a615debfa342ae95f93df8bf580
---
EOF
cat >"$TR/seed/panel-runs/endojs-endo-but-for-bots-200/current.md" <<'EOF'
---
disposition: passed
reviewed_head: aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
---
EOF
cat >"$TR/seed/panel-runs/endojs-endo-but-for-bots-202/current.md" <<'EOF'
---
disposition: passed
reviewed_head: cccccccccccccccccccccccccccccccccccccccc
---
EOF
cat >"$TR/seed/panel-runs/endojs-endo-but-for-bots-203/old.md" <<'EOF'
---
disposition: passed
reviewed_head: cccccccccccccccccccccccccccccccccccccccc
---
EOF
git -C "$TR/seed" add -A
git -C "$TR/seed" -c user.name=test -c user.email=test@example.invalid commit -q -m seed
cat >"$TR/seed/panel-runs/endojs-endo-but-for-bots-203/new.md" <<'EOF'
---
disposition: passed
reviewed_head: dddddddddddddddddddddddddddddddddddddddd
---
EOF
git -C "$TR/seed" add -A
git -C "$TR/seed" -c user.name=test -c user.email=test@example.invalid commit -q -m 'newer panel'
git -C "$TR/seed" remote add origin "$TR/journal.git"
git -C "$TR/seed" push -q origin HEAD:journal2

export GARDEN_ROOT="$ROOT" GARDEN_TEST=1 GARDEN=panel-head-test
export JOURNAL_REMOTE="$TR/journal.git" JOURNAL_BRANCH=journal2
export GARDEN_STATE="$TR/state" GARDEN_PRODUCER_CLONE="$TR/state/producer/journal"
export GARDEN_GH="$HERE/panel-head-freshness-gh-stub.sh" GARDEN_GH_CALL_LOG="$TR/gh.log"

set +e; "$SENSOR" pr endojs/endo-but-for-bots 858 >"$TR/pr.out" 2>"$TR/pr.err"; rc=$?; set -e
[ "$rc" -eq 10 ] || fail "journal-backed #858 check did not flag (rc=$rc)"
set +e; "$SENSOR" pr endojs/endo-but-for-bots 475 >"$TR/legacy.out" 2>"$TR/legacy.err"; rc=$?; set -e
[ "$rc" -eq 10 ] || fail "legacy eight-hex panel record did not flag #475 (rc=$rc)"
"$SENSOR" pr endojs/endo-but-for-bots 200 | grep -q 'disposition=covered' \
  || fail 'journal-backed equal-head control did not pass'
"$SENSOR" pr endojs/endo-but-for-bots 202 | grep -q 'not-applicable' \
  || fail 'merged PR did not become not-applicable'
"$SENSOR" pr endojs/endo-but-for-bots 203 | grep -q 'reviewed_head=dddddddddddddddddddddddddddddddddddddddd' \
  || fail 'sensor did not select the latest completed panel by journal order'

job="$TR/job.md"; report="$TR/report.md"
printf -- '---\nrole: shepherd\n---\n' >"$job"
printf 'Updated https://github.com/endojs/endo-but-for-bots/pull/858\n' >"$report"
set +e; "$SENSOR" completion historical "$job" "$report" >"$TR/completion.out"; rc=$?; set -e
[ "$rc" -eq 10 ] || fail 'completion path did not surface stale review'

# An in-flight, explicitly requested gauntlet owns its own next-panel transition;
# this completion sensor must not post or imply a second/manual gauntlet trigger.
printf -- '---\ngauntlet: explicit-run\ngauntlet_stage: fix\n---\n' >"$job"
: >"$TR/gh.log"
"$SENSOR" completion stage "$job" "$report" | grep -q 'gauntlet-driver-owns-next-panel' \
  || fail 'explicit gauntlet stage was not routed to its driver'
[ ! -s "$TR/gh.log" ] || fail 'managed gauntlet stage unnecessarily queried/mutated GitHub'

set +e; "$SENSOR" pr --require-reviewed-head endojs/endo-but-for-bots 201 >/dev/null 2>&1; rc=$?; set -e
[ "$rc" -eq 11 ] || fail 'required review with no durable panel did not fail closed'

echo 'PASS: all three historical deltas flag; equal-head and metadata-only controls pass; completion routing preserves the manual-gauntlet trigger'
