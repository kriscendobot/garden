#!/bin/bash
# auto-gauntlet-handoff-test.sh: build completion must mint a durable staged-gauntlet
# RECORD (jobs/gauntlet/<g>.md, designs/staged-gauntlet.md) for an open draft feature
# PR, while probes and ready PRs stay untouched. The old handoff posted a monolithic
# <base>-gauntlet JOB into jobs/todo/; it now records a gauntlet the deterministic
# gauntlet.sh driver walks one claim-sized stage at a time.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
TR="$(mktemp -d "${TMPDIR:-/tmp}/garden-auto-gauntlet-test.XXXXXX")"
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
export GARDEN_STATE="$TR/state" GARDEN=auto-test
export GARDEN_GH="$HERE/auto-gauntlet-gh-stub.sh"

job="$TR/build.md"; report="$TR/report.md"
printf -- '---\nrole: builder\n---\nBuild the feature.\n' >"$job"
printf 'Draft PR: https://github.com/endojs/endo-but-for-bots/pull/999\n' >"$report"

# A gauntlet RECORD (not a todo job) is the handoff artifact now.
assert_recorded() {
  local base="$1" clone
  clone="$TR/check-$base"
  rm -rf "$clone"
  git clone -q --single-branch --branch journal2 "$TR/journal.git" "$clone"
  [ -f "$clone/jobs/gauntlet/$base.md" ]
}
# It must NOT be a monolithic todo job any more.
assert_not_todo() {
  local base="$1" clone
  clone="$TR/check-todo-$base"
  rm -rf "$clone"
  git clone -q --single-branch --branch journal2 "$TR/journal.git" "$clone"
  [ ! -f "$clone/jobs/todo/$base.md" ]
}

export FAKE_PR_JSON='{"url":"https://github.com/endojs/endo-but-for-bots/pull/999","isDraft":true,"state":"OPEN","title":"feat: feature","body":"normal feature"}'
"$JOBS/auto-gauntlet-handoff.sh" build-feature "$job" "$report"
assert_recorded build-feature-gauntlet
assert_not_todo build-feature-gauntlet
rec="$TR/check-build-feature-gauntlet/jobs/gauntlet/build-feature-gauntlet.md"
grep -q 'build_job: build-feature' "$rec"
grep -qx 'kind: feature' "$rec"
grep -qx 'stage: clean' "$rec"
grep -qx 'state: pending' "$rec"
grep -q 'pr: https://github.com/endojs/endo-but-for-bots/pull/999' "$rec"
grep -qx 'pr_number: 999' "$rec"
grep -qx 'repo: endojs/endo-but-for-bots' "$rec"

# A retry is idempotent by the deterministic gauntlet basename.
"$JOBS/auto-gauntlet-handoff.sh" build-feature "$job" "$report"
count="$(git -C "$TR/check-build-feature-gauntlet" ls-tree -r --name-only origin/journal2 -- jobs/gauntlet | grep -c -- 'build-feature-gauntlet.md')"
[ "$count" -eq 1 ]

# A probe stays draft by design: the AUTO handoff creates NO gauntlet for it (the
# auto-gauntlet invariant is for mergeable-feature builds, not probes — CLAUDE.md).
export FAKE_PR_JSON='{"url":"https://github.com/endojs/endo-but-for-bots/pull/999","isDraft":true,"state":"OPEN","title":"feat: probe","body":"gap-revealing prototype of #1"}'
"$JOBS/auto-gauntlet-handoff.sh" build-probe "$job" "$report"
if assert_recorded build-probe-gauntlet; then
  echo 'probe incorrectly received a gauntlet record' >&2
  exit 1
fi

# A PR already ready-for-review is re-drafted then handed off (a norm violation, not a
# finished chain) — so it DOES get a record.
export FAKE_PR_JSON='{"url":"https://github.com/endojs/endo-but-for-bots/pull/999","isDraft":false,"state":"OPEN","title":"feat: ready","body":"normal feature"}'
"$JOBS/auto-gauntlet-handoff.sh" build-ready "$job" "$report"
assert_recorded build-ready-gauntlet

echo 'PASS: auto-gauntlet handoff records a staged gauntlet for an open draft feature PR and skips probes'
