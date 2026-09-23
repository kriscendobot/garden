---
ts: 2026-06-14T11:02:42Z
kind: result
role: fixer
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
worktree: dispatches/fixer--cc1df0/project
refs:
  - jobs/claimed/20260614T110242Z--endolinbot--fixer--f00a--ea095b--endo-but-for-bots-440-r2-summary-fix.md
  - entries/2026/06/14/104800Z-dispatch-justice-1eed16.md
  - entries/2026/06/14/104357Z-result-fixer-9bf98b.md
---

# Result: fixer cc1df0 — PR #440 r2 summary-fix item 1 (registry-host alignment)

Surgical one-line registry update on `packages/chat/formula-view-registry.js`:
the `host` entry's `propertyList` now matches the daemon's emission order from
`packages/daemon/src/formula-record.js` (host case, lines 75-107): `handle`,
`hostHandle`, `mainWorker`, `nodeWorker`, `inspector`, `petStore`,
`mailboxStore`, `mailHub`, `endo`, `networks`, `pins`. Dropped the singular
`worker`; added `hostHandle`, `mainWorker`, `nodeWorker` in the curated order
the back face should render.

## Heads

- Pre-head:  `93b399160` (origin/feat/formula-inspector at dispatch start)
- Post-head: `0407bfb54` (after fix commit, push accepted)
- Commit:    `0407bfb54773d163fa67c7a52dfd6ab340324a5e`
  `fix(chat): align formula-view-registry host propertyList with daemon emission`

## Test

`corepack yarn workspace @endo/chat test` — 496 tests passed (green).
No unit-test in `packages/chat/test/unit/formula-view-registry.test.js`
asserts the host's propertyList specifically; the canonical-coverage test
only verifies the type is registered, which it still is. No test edit
needed.

## Comment

Top-level summary on PR #440 @-mentioning @kriskowal with SHA and
resolution:
https://github.com/endojs/endo-but-for-bots/pull/440#issuecomment-4701540583

## Job board

Claimed: `jobs/claimed/20260614T110242Z--endolinbot--fixer--f00a--ea095b--endo-but-for-bots-440-r2-summary-fix.md`
Completion stamp to be added by the orchestrator on teardown, or by a
follow-up `complete-job.sh done --result-entry <this-entry>` invocation
naming this entry path.

The prior fixer (`9bf98b`) noted friction with `claim-job.sh` from the
dispatch-root layout. Same friction here: the script's `$JRN` resolution
assumes the consumer is the orchestrator with the canonical
`<garden-root>/journal/` worktree, not a subagent inside a dispatch
triple. I claimed by hand inside `dispatches/fixer--cc1df0/journal/`
using the skill's documented `git mv` + frontmatter-append + commit +
push sequence. Push to `origin/journal` was the serialization point and
landed cleanly (commit `14b174e7`).

## Scope discipline

Did NOT touch the broader daemon-vs-registry catalog drift (channel,
timer, git, git-credential, git-remote, mount, scratch-mount,
readable-tree per the round-1 follow-up ledger entry). Did NOT un-draft.
Did NOT re-request review.

## Recommended next stage

PR #440 is the same DRAFT it was when the dispatch began. The judge has
already un-drafted on its termination (per the round-2 result; "the
jury-fixer loop terminated on this round (zero must-fix-loop)"). The
orchestrator's next move:

1. Verify CI converges on the new head `0407bfb54`.
2. If un-draft already happened earlier and is still un-drafted: dispatch
   the conductor to merge (subject to maintainer's reviewDecision; if
   APPROVED, merge per the standard "APPROVED PRs dispatch to conductor"
   pattern). If the PR is still DRAFT despite the judge's termination,
   the orchestrator un-drafts before the conductor dispatch.

Self-improvement: the job-board skill's claim procedure should be amended
with a "from-dispatch-root" form that names the journal sub-worktree path
explicitly (`<dispatch-root>/journal/`) so subagents do not have to fall
back to manual `git mv`. The skill's `claim-job.sh` reads `$JRN` from
the calling shell; setting `JRN=$(pwd)/../journal` works from
`project/`, but the skill body does not document that escape hatch. A
one-paragraph addition to the skill's *Inputs* or *Pitfalls* section
would close the gap. Message to liaison rather than a self-applied
amendment because the skill body is in `garden/` and subagent commits
there are torn down with the dispatch.
