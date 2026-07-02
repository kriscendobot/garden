---
gate: blocked
blocked_on: ebfb-594-fresh-llm-pr-merge
priority: normal
posted_by: producer
posted_at: 2026-07-02T09:54:13Z
---

# Resume shepherds for the `llm`-based PRs blocked by the lint projectService ceiling

**Repo:** `endojs/endo-but-for-bots` (bot-pushable; bot-repo work only, no upstream `endojs/endo` touch).

## Why this job exists

The typescript-eslint project-service scaling ceiling reddened CI `lint` on every large PR; the CI-watcher auto-dispatched a shepherd per red PR, none could go green, each failed 5x and the reaper poisoned it. This plan resumes the **`llm`-based** subset once the `llm` branch carries the fix.

The `llm` lint fix lands via job **`ebfb-594-fresh-llm-pr-merge`** (a fresh PR basing #594's bucketed `scripts/eslint-repo.sh` on `llm`, merged without delay). This plan is `gate: blocked, blocked_on: ebfb-594-fresh-llm-pr-merge`; `garden-unblock` promotes it to `todo/` when that job reaches `tada/`.

This is the **`llm` half** of the split maintainer directive (kriskowal, 2026-07-02): resume the `llm`-based blocked PRs as soon as the `llm` fix is in, without waiting for the separately-deliberated `master` decision. The `master`-based and feature-branch-stacked PRs stay in `resume-lint-ceiling-shepherds` (parked on the master lint landing).

## Guard before acting

Confirm the `llm` lint fix **actually merged** to `llm` (the blocker job could report done without a merge). Check that current `origin/llm` carries the bucketed `scripts/eslint-repo.sh` and that `yarn lint:eslint` delegates to it. If it did not merge, post a maintainer-inbox note and re-park this plan — do not resume.

## Action once unblocked (and the llm fix confirmed on `origin/llm`)

For each PR below, dispatch a **shepherd** (`post-job.sh <base>` per PR so the fleet parallelizes) to **rebase the PR onto current `llm` (unfreezing any `llm-<sha>` snapshot base to live `llm`) and drive CI to green**. With the ceiling gone on `llm`, `lint` should pass on rebase; the shepherd handles any other still-red check and re-escalates only for a genuinely different, out-of-shepherd-scope failure. Each shepherd re-fetches live PR state, so any PR that has since merged/closed is a fast no-op.

## `llm`-based blocked PRs to resume (15; open as of 2026-07-02)

#101 #242 #301 #306 #313 #316 #318 #320 #324 #335 #581 #585 #590 #592 #593

(Bases: most are live `llm`; #242/#320 are `llm-b1c3f4d`, #581 `llm-f98d663`, #585 `llm-5a4f9a9` frozen snapshots — the shepherd rebases onto live `llm`, which carries the fix. #101/#301/#306 were originally weaver-poisoned; a shepherd's rebase-and-green subsumes the rebase intent and escalates to a fixer if a genuine conflict remains.)

## Provenance

Split from `resume-lint-ceiling-shepherds` by the liaison (leader, endolinbot) on 2026-07-02 per the maintainer's "llm now, master after the decision" directive. Base-branch classification done live against the open-PR set. Source fix: `ebfb-594-fresh-llm-pr-merge`.
