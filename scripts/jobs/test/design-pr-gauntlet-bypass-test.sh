#!/bin/bash
# design-pr-gauntlet-bypass-test.sh — the re-litigation test for review-misses
# cluster `garden-design-pr-gauntlet-bypass` (kriskowal/garden #7,
# endojs/endo-but-for-bots #809, kriscendobot/minion.town #41). Each miss was a
# garden-owned DESIGN PR that reached maintainer review with no design panel staged,
# because the auto-gauntlet completion edge fired only for `role: builder` and the
# three producing jobs carried other roles (researcher-designer, gardener, designer).
#
# Two halves under test, both deterministic:
#   PREVENTION (auto-gauntlet-handoff.sh) — a NON-builder completion that produced a
#     bot-authored OPEN DRAFT DESIGN-ONLY PR now stages that PR's design gauntlet.
#   SENSING (assert-design-pr-gauntlet.sh) — refuses to record such a job complete
#     while its design PR has no gauntlet record (senses the evaluator's absence).
#
# Plus regression coverage for the valid probe exception and an ordinary design PR
# whose gauntlet is already staged (idempotent no-op).

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
TR="$(mktemp -d "${TMPDIR:-/tmp}/garden-design-gauntlet-test.XXXXXX")"
trap 'rm -rf "$TR"' EXIT

git init -q --bare "$TR/journal.git"
git init -q "$TR/seed"
git -C "$TR/seed" checkout -q -b journal2
mkdir -p "$TR/seed/jobs/"{todo,doin,tada,index,gauntlet} "$TR/seed/work"
touch "$TR/seed/jobs/todo/.gitkeep" "$TR/seed/jobs/doin/.gitkeep" \
  "$TR/seed/jobs/tada/.gitkeep" "$TR/seed/jobs/index/.gitkeep" \
  "$TR/seed/jobs/gauntlet/.gitkeep" "$TR/seed/work/.gitkeep"
git -C "$TR/seed" add -A
git -C "$TR/seed" -c user.name=test -c user.email=test@example.invalid commit -q -m seed
git -C "$TR/seed" remote add origin "$TR/journal.git"
git -C "$TR/seed" push -q origin HEAD:journal2

GARDEN_ROOT="$(cd "$JOBS/../.." && pwd)"; export GARDEN_ROOT
export GARDEN_TEST=1 JOURNAL_REMOTE="$TR/journal.git" JOURNAL_BRANCH=journal2
export GARDEN_STATE="$TR/state" GARDEN=design-gauntlet-test
export GARDEN_GH="$HERE/auto-gauntlet-gh-stub.sh"

STAGER="$JOBS/auto-gauntlet-handoff.sh"
SENSOR="$JOBS/assert-design-pr-gauntlet.sh"

fail() { echo "FAIL: $*" >&2; exit 1; }

# A gauntlet RECORD is created on origin/journal2 iff <base>.md exists in jobs/gauntlet.
recorded() {  # recorded <gauntlet-base>
  local base="$1" clone="$TR/check-$1"
  rm -rf "$clone"
  git clone -q --single-branch --branch journal2 "$TR/journal.git" "$clone" >/dev/null 2>&1
  [ -f "$clone/jobs/gauntlet/$base.md" ]
}
# Author a NON-builder job + a completion report naming a PR.
mkjob() {  # mkjob <name> <role> <pr-url>
  local name="$1" role="$2" pr="$3"
  printf -- '---\nrole: %s\n---\nExpand the design.\n' "$role" >"$TR/$name.job.md"
  printf 'Opened the design PR: %s\n' "$pr" >"$TR/$name.report.md"
}
# One reusable FAKE_PR_JSON for a bot-authored OPEN DRAFT DESIGN-ONLY PR.
design_pr_json() {  # design_pr_json <pr-url> <design-path>
  printf '{"url":"%s","isDraft":true,"state":"OPEN","title":"design: X","body":"a design","author":{"login":"kriscendobot"},"files":[{"path":"%s"}]}' "$1" "$2"
}

echo '== (a) PREVENTION: the three historical miss shapes each stage a design gauntlet =='

# --- kriskowal/garden #7 (producing role researcher-designer, a design doc) -------
pr='https://github.com/kriskowal/garden/pull/7'
mkjob garden7 researcher-designer "$pr"
export FAKE_PR_JSON="$(design_pr_json "$pr" designs/systemd-run-vs-gardener-loops.md)"
"$STAGER" investigate-systemd-run-vs-gardener-loops "$TR/garden7.job.md" "$TR/garden7.report.md"
recorded kriskowal-garden-pr7-gauntlet || fail 'garden #7 design PR did not receive a gauntlet record'
rec="$TR/check-kriskowal-garden-pr7-gauntlet/jobs/gauntlet/kriskowal-garden-pr7-gauntlet.md"
grep -qx 'repo: kriskowal/garden' "$rec" || fail 'garden #7 record missing repo'
grep -qx 'pr_number: 7' "$rec" || fail 'garden #7 record missing pr_number'
grep -qx 'kind: feature' "$rec" || fail 'garden #7 record wrong kind'

# --- endojs/endo-but-for-bots #809 (producing role gardener, an issue job) --------
pr='https://github.com/endojs/endo-but-for-bots/pull/809'
mkjob endo809 gardener "$pr"
export FAKE_PR_JSON="$(design_pr_json "$pr" designs/persistent-store.md)"
"$STAGER" issue-kriskowal-garden-59 "$TR/endo809.job.md" "$TR/endo809.report.md"
recorded endojs-endo-but-for-bots-pr809-gauntlet || fail 'endo #809 design PR did not receive a gauntlet record'

# --- kriscendobot/minion.town #41 (producing role designer) -----------------------
pr='https://github.com/kriscendobot/minion.town/pull/41'
mkjob minion41 designer "$pr"
export FAKE_PR_JSON="$(design_pr_json "$pr" designs/git-remote-capability.md)"
"$STAGER" minion-town-git-remote-capability-design "$TR/minion41.job.md" "$TR/minion41.report.md"
recorded kriscendobot-minion.town-pr41-gauntlet || fail 'minion.town #41 design PR did not receive a gauntlet record'

echo '== (b) SENSING: a design PR with no gauntlet record blocks completion =='

# The three staged above now PASS the sensor (record exists) — no wedge.
export FAKE_PR_JSON="$(design_pr_json 'https://github.com/kriscendobot/minion.town/pull/41' designs/git-remote-capability.md)"
if ! "$SENSOR" minion-town-git-remote-capability-design "$TR/minion41.job.md" "$TR/minion41.report.md"; then
  fail 'sensor wrongly blocked a design PR that HAS a staged gauntlet record'
fi

# An UNCOVERED design PR (no record for #999) blocks completion (rc 1).
pr='https://github.com/endojs/endo-but-for-bots/pull/999'
mkjob uncovered designer "$pr"
export FAKE_PR_JSON="$(design_pr_json "$pr" designs/uncovered.md)"
if "$SENSOR" some-design-job "$TR/uncovered.job.md" "$TR/uncovered.report.md"; then
  fail 'sensor did NOT block a design PR that lacks any gauntlet record'
fi
echo '   sensor correctly blocked the uncovered design PR (rc 1)'

echo '== regression: the valid PROBE exception stays draft with NO design gauntlet =='
# A probe is role builder + a gap-revealing prototype; it must never enter this path.
pr='https://github.com/endojs/endo-but-for-bots/pull/700'
printf -- '---\nrole: builder\n---\nProbe the design.\n' >"$TR/probe.job.md"
printf 'Draft probe PR: %s\n' "$pr" >"$TR/probe.report.md"
export FAKE_PR_JSON="{\"url\":\"$pr\",\"isDraft\":true,\"state\":\"OPEN\",\"title\":\"feat: probe (gap-revealing prototype of #41)\",\"body\":\"gap report\",\"author\":{\"login\":\"kriscendobot\"},\"files\":[{\"path\":\"designs/probed.md\"}]}"
"$STAGER" probe-the-design "$TR/probe.job.md" "$TR/probe.report.md"
if recorded endojs-endo-but-for-bots-pr700-gauntlet || recorded probe-the-design-gauntlet; then
  fail 'a probe incorrectly received a design gauntlet record'
fi
# And the sensor never blocks a probe (it early-exits on role builder anyway; also
# exempt by the gap-revealing marker if ever posted under another role).
if ! "$SENSOR" probe-the-design "$TR/probe.job.md" "$TR/probe.report.md"; then
  fail 'sensor wrongly blocked a probe'
fi

echo '== regression: an ordinary design PR whose gauntlet is already staged is an idempotent no-op =='
# Re-run the minion.town #41 stager: the PR-keyed idempotence must NOT add a second
# record, whatever base a peer producer might choose.
export FAKE_PR_JSON="$(design_pr_json 'https://github.com/kriscendobot/minion.town/pull/41' designs/git-remote-capability.md)"
"$STAGER" minion-town-git-remote-capability-design "$TR/minion41.job.md" "$TR/minion41.report.md"
clone="$TR/check-idem"; rm -rf "$clone"
git clone -q --single-branch --branch journal2 "$TR/journal.git" "$clone" >/dev/null 2>&1
n="$(git -C "$clone" ls-tree -r --name-only origin/journal2 -- jobs/gauntlet 2>/dev/null | grep -c 'kriscendobot-minion.town-pr41-gauntlet.md' || true)"
[ "$n" -eq 1 ] || fail "expected exactly one minion.town #41 gauntlet record, found $n"
# A DIFFERENT non-builder job that touches the SAME design PR (a fixer addressing
# panel feedback) must also converge on the one record, not add a second.
mkjob minion41fix fixer 'https://github.com/kriscendobot/minion.town/pull/41'
"$STAGER" minion-town-pr41-fix "$TR/minion41fix.job.md" "$TR/minion41fix.report.md"
rm -rf "$clone"; git clone -q --single-branch --branch journal2 "$TR/journal.git" "$clone" >/dev/null 2>&1
n="$(git -C "$clone" ls-tree -r --name-only origin/journal2 -- jobs/gauntlet 2>/dev/null | grep -c 'pr41-gauntlet.md' || true)"
[ "$n" -eq 1 ] || fail "a second producer on minion.town #41 created a duplicate gauntlet (found $n)"

echo '== regression: a NON-design code PR from a non-builder role stages nothing =='
pr='https://github.com/endojs/endo-but-for-bots/pull/850'
mkjob codepr fixer "$pr"
export FAKE_PR_JSON="{\"url\":\"$pr\",\"isDraft\":true,\"state\":\"OPEN\",\"title\":\"fix: bug\",\"body\":\"code\",\"author\":{\"login\":\"kriscendobot\"},\"files\":[{\"path\":\"packages/foo/src/bar.js\"}]}"
"$STAGER" fix-some-bug "$TR/codepr.job.md" "$TR/codepr.report.md"
if recorded endojs-endo-but-for-bots-pr850-gauntlet; then
  fail 'a non-design code PR from a non-builder role wrongly received a design gauntlet'
fi
# The sensor must not block it either.
if ! "$SENSOR" fix-some-bug "$TR/codepr.job.md" "$TR/codepr.report.md"; then
  fail 'sensor wrongly blocked a non-design code PR'
fi

echo '== regression: sensor is a no-op for builder role and for jobs with no PR =='
printf -- '---\nrole: builder\n---\nBuild.\n' >"$TR/b.job.md"
printf 'Draft PR: https://github.com/endojs/endo-but-for-bots/pull/41\n' >"$TR/b.report.md"
export FAKE_PR_JSON="$(design_pr_json 'https://github.com/endojs/endo-but-for-bots/pull/41' designs/x.md)"
"$SENSOR" a-build "$TR/b.job.md" "$TR/b.report.md" || fail 'sensor should early-exit rc0 for a builder'
printf -- '---\nrole: designer\n---\nNo PR here.\n' >"$TR/nopr.job.md"
: >"$TR/nopr.report.md"
"$SENSOR" no-pr-job "$TR/nopr.job.md" "$TR/nopr.report.md" || fail 'sensor should rc0 when the report names no PR'

echo 'PASS: design PRs (any producing role) stage their gauntlet and are gated at completion; probes and code PRs are untouched; coverage is idempotent per PR'
