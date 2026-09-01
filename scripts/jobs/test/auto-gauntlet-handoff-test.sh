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

export FAKE_PR_JSON='{"url":"https://github.com/endojs/endo-but-for-bots/pull/999","isDraft":true,"state":"OPEN","title":"feat: feature","body":"normal feature","author":{"login":"kriscendobot"}}'
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
export FAKE_PR_JSON='{"url":"https://github.com/endojs/endo-but-for-bots/pull/999","isDraft":true,"state":"OPEN","title":"feat: probe","body":"gap-revealing prototype of #1","author":{"login":"kriscendobot"}}'
"$JOBS/auto-gauntlet-handoff.sh" build-probe "$job" "$report"
if assert_recorded build-probe-gauntlet; then
  echo 'probe incorrectly received a gauntlet record' >&2
  exit 1
fi

# A PR already ready-for-review is re-drafted then handed off (a norm violation, not a
# finished chain) — so it DOES get a record.
export FAKE_PR_JSON='{"url":"https://github.com/endojs/endo-but-for-bots/pull/999","isDraft":false,"state":"OPEN","title":"feat: ready","body":"normal feature","author":{"login":"kriscendobot"}}'
"$JOBS/auto-gauntlet-handoff.sh" build-ready "$job" "$report"
assert_recorded build-ready-gauntlet

# REGRESSION (2026-07-29, endojs/endo-but-for-bots#671): a PR URL that appears only
# in the JOB FILE is a citation the producer wrote, never a PR the build opened — the
# PR did not exist when the job was posted. The garden-`main2` build
# `fix-pr-feedback-preflight-argv-e2big` opened no PR at all; its body merely cited the
# PR whose preflight had crashed, and the hook force-drafted that live, ready-for-review
# PR out from under a peer worker and posted a gauntlet to review it "cold". A job-file
# citation must produce NO record and NO GitHub mutation whatsoever.
cite_job="$TR/cite-build.md"; cite_report="$TR/cite-report.md"
printf -- '---\nrole: builder\n---\nFix the preflight that crashed on\nhttps://github.com/endojs/endo-but-for-bots/pull/671 — see that PR for the payload.\n' >"$cite_job"
printf 'Landed on main2 as abc1234. No PR: the garden does not use PRs on itself.\n' >"$cite_report"
export FAKE_PR_JSON='{"url":"https://github.com/endojs/endo-but-for-bots/pull/671","isDraft":false,"state":"OPEN","title":"feat: someone else work","body":"unrelated"}'
GARDEN_GH_CALL_LOG="$TR/gh-calls.log" "$JOBS/auto-gauntlet-handoff.sh" build-cited "$cite_job" "$cite_report"
if assert_recorded build-cited-gauntlet; then
  echo 'a PR merely CITED in the job file incorrectly received a gauntlet record' >&2
  exit 1
fi
if [ -s "$TR/gh-calls.log" ]; then
  echo 'a PR merely CITED in the job file was touched on GitHub:' >&2
  cat "$TR/gh-calls.log" >&2
  exit 1
fi

# The same citation must also not be reachable via the probe/ready branches: no PR at
# all in either document is simply "no handoff required", not an error.
: >"$TR/empty-report.md"
printf -- '---\nrole: builder\n---\nGarden infrastructure work, no PR.\n' >"$TR/empty-job.md"
GARDEN_GH_CALL_LOG="$TR/gh-calls-none.log" \
  "$JOBS/auto-gauntlet-handoff.sh" build-nopr "$TR/empty-job.md" "$TR/empty-report.md"
if assert_recorded build-nopr-gauntlet; then
  echo 'a build with no PR anywhere incorrectly received a gauntlet record' >&2
  exit 1
fi
[ ! -s "$TR/gh-calls-none.log" ]

# A report that names several PRs still hands off on the first, but says so.
multi_report="$TR/multi-report.md"
printf 'Draft PR: https://github.com/endojs/endo-but-for-bots/pull/999\nSame shape as https://github.com/endojs/endo-but-for-bots/pull/671.\n' >"$multi_report"
export FAKE_PR_JSON='{"url":"https://github.com/endojs/endo-but-for-bots/pull/999","isDraft":true,"state":"OPEN","title":"feat: feature","body":"normal feature","author":{"login":"kriscendobot"}}'
"$JOBS/auto-gauntlet-handoff.sh" build-multi "$job" "$multi_report" 2>"$TR/multi.log"
assert_recorded build-multi-gauntlet
grep -q 'pr: https://github.com/endojs/endo-but-for-bots/pull/999' \
  "$TR/check-build-multi-gauntlet/jobs/gauntlet/build-multi-gauntlet.md"
grep -q 'distinct PR URLs' "$TR/multi.log"

# REGRESSION (2026-07-29, endojs/endo-but-for-bots#867): a completion REPORT can cite
# ANOTHER author's PR by FULL URL (a related-work link), which the report-only scrape
# takes as the build's own. The build `fix-botanist-scripts-enabled-install-gap` (which
# opened no PR of its own) named the live dependabot `@noble/curves` bump #867 as the
# botany that surfaced its gap; the hook force-drafted that PR out of the maintainer's
# MERGE-NOW queue, blocking its merge. A build opens its own PR under the BOT identity,
# so a PR authored by anyone else cannot be a build artifact: NO record, and NO mutation
# beyond the read-only `pr view`.
dep_report="$TR/dep-report.md"
printf 'Fixed on main2. Surfaced by the botany of\nhttps://github.com/endojs/endo-but-for-bots/pull/867 (a @noble/curves bump).\n' >"$dep_report"
export FAKE_PR_JSON='{"url":"https://github.com/endojs/endo-but-for-bots/pull/867","isDraft":false,"state":"OPEN","title":"chore: bump @noble/curves","body":"dependabot","author":{"login":"app/dependabot"}}'
GARDEN_GH_CALL_LOG="$TR/gh-dep.log" "$JOBS/auto-gauntlet-handoff.sh" build-dep "$job" "$dep_report"
if assert_recorded build-dep-gauntlet; then
  echo 'a PR authored by another user (dependabot) incorrectly received a gauntlet record' >&2
  exit 1
fi
# The hook may READ the PR (pr view) to learn its author, but must make NO mutation —
# above all no `pr ready --undo` that force-drafts a PR that is not the build's.
if grep -q 'pr ready' "$TR/gh-dep.log"; then
  echo 'a PR authored by another user was mutated (re-drafted) by the hook:' >&2
  cat "$TR/gh-dep.log" >&2
  exit 1
fi

# REGRESSION (2026-08-27, kriscendobot/garden#58): shorthand issue citations are
# syntactically indistinguishable from shorthand PR citations, so the shared extractor
# normalizes this issue to a /pull/58 URL. GitHub's definitive PullRequest lookup error
# means the reference is not a PR artifact. That answer must make the handoff succeed
# without recording a gauntlet; otherwise gardener.sh treats a completed issue-driven
# job as a failed handoff and leaves it in doin for the reaper to run again.
issue_report="$TR/issue-report.md"
printf 'Fixed on main2. Follow-up to kriscendobot/garden#58.\n' >"$issue_report"
export FAKE_PR_VIEW_ERROR='GraphQL: Could not resolve to a PullRequest with the number of 58. (repository.pullRequest)'
GARDEN_GH_CALL_LOG="$TR/gh-issue.log" \
  "$JOBS/auto-gauntlet-handoff.sh" build-issue-ref "$job" "$issue_report" 2>"$TR/issue.log"
unset FAKE_PR_VIEW_ERROR
if assert_recorded build-issue-ref-gauntlet; then
  echo 'an issue citation incorrectly received a gauntlet record' >&2
  exit 1
fi
grep -q 'not a PullRequest' "$TR/issue.log"
[ "$(wc -l <"$TR/gh-issue.log")" -eq 1 ]
grep -q '^pr view https://github.com/kriscendobot/garden/pull/58 ' "$TR/gh-issue.log"

# Only GitHub's definitive non-PR answer is safe to skip. Authentication, network,
# rate-limit, and other inspection failures must still fail the handoff so it retries.
export FAKE_PR_VIEW_ERROR='HTTP 503: upstream unavailable'
set +e
GARDEN_GH_CALL_LOG="$TR/gh-transient.log" \
  "$JOBS/auto-gauntlet-handoff.sh" build-transient "$job" "$issue_report" 2>"$TR/transient.log"
transient_rc=$?
set -e
unset FAKE_PR_VIEW_ERROR
[ "$transient_rc" -ne 0 ]
grep -q 'HTTP 503: upstream unavailable' "$TR/transient.log"
grep -q 'gh could not inspect https://github.com/kriscendobot/garden/pull/58' "$TR/transient.log"
if assert_recorded build-transient-gauntlet; then
  echo 'a transient lookup failure incorrectly received a gauntlet record' >&2
  exit 1
fi

echo "PASS: auto-gauntlet handoff records feature PRs, skips probes and citations (including issues), never mutates another author's PR, and retries transient lookup failures"
