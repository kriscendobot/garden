---
ts: 2026-05-29T20:54:31Z
kind: dispatch
role: steward
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: shepherd
dispatch_root: /home/kris/dispatches/shepherd--298244
prs:
  - repo: endojs/endo-but-for-bots
    pr: 244
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/244
  - entries/2026/05/29/201100Z-result-steward-e6f7a8.md
  - entries/2026/05/29/204819Z-result-steward-c7e089.md
---

# dispatch: shepherd — #244 drive CI to green (kriskowal directive, second verb of `rebase and shepherd`)

Maintainer kriskowal directed on PR #244 at 2026-05-29T20:03:25Z:

> Please rebase and shepherd.

The rebase phase completed by weaver `a1b99c`. The base was then
reverted from frozen `master-814dfa1` back to live `master` per
kriskowal's 20:39:12Z follow-up (steward result `c7e089`). This
dispatch is the **shepherd** phase.

## Task

Drive PR #244's CI to green per
`garden/skills/pr-ci-watch/SKILL.md`. Current state:

- `mergeStateStatus`: UNSTABLE
- CI: 17 SUCCESS, 1 FAILURE (`test-xs`)
- Failing job:
  https://github.com/endojs/endo-but-for-bots/actions/runs/26660065197/job/78580095052

Per the shepherd's job: pull the `test-xs` log, classify as
flake / known-pre-existing / real-failure / out-of-scope-fixer-fixable.
Re-enqueue if flake. Comment with classification if pre-existing.
Escalate to fixer if real-failure-and-fixer-fixable (per the standing
memory rule `feedback_shepherd_to_fixer_auto_chain.md`, the shepherd's
"needs fixer" verdict is the steward's authorization to dispatch the
fixer next cycle — surface it explicitly in the report).

## Starting state

- Branch: `chore/eslint-numeric-separators-style-master`
- Head: `63a1a60689525a3e395d8f16db8570de1aefa97d` (includes
  fixer-`d20324`'s lint commit on top of the weaver's rebase head)
- Base: `master` (re-pointed from `master-814dfa1` after the
  base-reversion)

## Per-action authorizations (forwarded)

- Re-enqueue CI jobs via `gh run rerun <run-id> --failed` for flake
  classification. Authorized.
- Posting an explanatory comment on PR #244 with classification
  (flake / pre-existing / etc.). Authorized.

## Not authorized

- Modifying any source file (fixer's job if needed).
- Force-pushing to the PR branch.
- Un-drafting or re-drafting.
- Merging.

## Dispatch protocol

Read in order:

1. `/home/kris/dispatches/shepherd--298244/garden/roles/COMMON.md`
2. `/home/kris/dispatches/shepherd--298244/garden/roles/shepherd/AGENT.md`
3. `garden/skills/pr-ci-watch/SKILL.md`
4. `garden/skills/ci-status-summary/SKILL.md` as needed.

Project worktree starts at `project/` on
`chore/eslint-numeric-separators-style-master` (head `63a1a6068`).

## Report

A `result` journal entry. Include: failure classification (with
evidence), action taken (re-enqueue / comment / escalate / none),
comment IDs of any posted comments, final CI state if known by
return-time, and any fixer-fixable escalation flagged for the
next steward cycle.
