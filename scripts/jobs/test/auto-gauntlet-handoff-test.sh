#!/bin/bash
# auto-gauntlet-handoff-test.sh: build completion must mint a durable gauntlet
# job for an open draft feature PR, while probes and ready PRs stay untouched.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
TR="$(mktemp -d "${TMPDIR:-/tmp}/garden-auto-gauntlet-test.XXXXXX")"
trap 'rm -rf "$TR"' EXIT

git init -q --bare "$TR/journal.git"
git init -q "$TR/seed"
git -C "$TR/seed" checkout -q -b journal2
mkdir -p "$TR/seed/jobs/"{todo,doin,tada,index} "$TR/seed/work"
touch "$TR/seed/jobs/todo/.gitkeep" "$TR/seed/jobs/doin/.gitkeep" \
  "$TR/seed/jobs/tada/.gitkeep" "$TR/seed/jobs/index/.gitkeep" "$TR/seed/work/.gitkeep"
git -C "$TR/seed" add -A
git -C "$TR/seed" -c user.name=test -c user.email=test@example.invalid commit -q -m seed
git -C "$TR/seed" remote add origin "$TR/journal.git"
git -C "$TR/seed" push -q origin HEAD:journal2

export GARDEN_ROOT="$(cd "$JOBS/../.." && pwd)"
export GARDEN_TEST=1 JOURNAL_REMOTE="$TR/journal.git" JOURNAL_BRANCH=journal2
export GARDEN_STATE="$TR/state" GARDEN=auto-test
export GARDEN_GH="$HERE/auto-gauntlet-gh-stub.sh"

job="$TR/build.md"; report="$TR/report.md"
printf -- '---\nrole: builder\n---\nBuild the feature.\n' >"$job"
printf 'Draft PR: https://github.com/endojs/endo-but-for-bots/pull/999\n' >"$report"

assert_posted() {
  local base="$1" clone
  clone="$TR/check-$base"
  git clone -q --single-branch --branch journal2 "$TR/journal.git" "$clone"
  [ -f "$clone/jobs/todo/$base.md" ]
}

export FAKE_PR_JSON='{"url":"https://github.com/endojs/endo-but-for-bots/pull/999","isDraft":true,"state":"OPEN","title":"feat: feature","body":"normal feature"}'
"$JOBS/auto-gauntlet-handoff.sh" build-feature "$job" "$report"
assert_posted build-feature-gauntlet
grep -q 'auto_gauntlet: true' "$TR/check-build-feature-gauntlet/jobs/todo/build-feature-gauntlet.md"
grep -q 'build_job: build-feature' "$TR/check-build-feature-gauntlet/jobs/todo/build-feature-gauntlet.md"
grep -qx 'handler-timeout: 7200' "$TR/check-build-feature-gauntlet/jobs/todo/build-feature-gauntlet.md"

# A retry is idempotent by the deterministic gauntlet basename.
"$JOBS/auto-gauntlet-handoff.sh" build-feature "$job" "$report"
count="$(git -C "$TR/check-build-feature-gauntlet" ls-tree -r --name-only origin/journal2 -- jobs/todo | grep -c -- 'build-feature-gauntlet.md')"
[ "$count" -eq 1 ]

export FAKE_PR_JSON='{"url":"https://github.com/endojs/endo-but-for-bots/pull/999","isDraft":true,"state":"OPEN","title":"feat: probe","body":"gap-revealing prototype of #1"}'
"$JOBS/auto-gauntlet-handoff.sh" build-probe "$job" "$report"
if assert_posted build-probe-gauntlet; then
  echo 'probe incorrectly received a gauntlet job' >&2
  exit 1
fi

export FAKE_PR_JSON='{"url":"https://github.com/endojs/endo-but-for-bots/pull/999","isDraft":false,"state":"OPEN","title":"feat: ready","body":"normal feature"}'
"$JOBS/auto-gauntlet-handoff.sh" build-ready "$job" "$report"
if assert_posted build-ready-gauntlet; then
  echo 'ready PR incorrectly received a gauntlet job' >&2
  exit 1
fi

echo 'PASS: auto-gauntlet handoff posts once for an open draft feature PR and skips probes/ready PRs'
