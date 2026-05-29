---
ts: 2026-05-29T03:26:00Z
kind: dispatch
role: steward
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: shepherd
dispatch_root: /home/kris/dispatches/shepherd--120d31
prs:
  - repo: endojs/endo-but-for-bots
    pr: 79
    role: target
refs:
  - entries/2026/05/29/032450Z-result-steward-a8b9c0.md
  - https://github.com/endojs/endo-but-for-bots/pull/79#issuecomment-4570135880
---

# dispatch: shepherd on endojs/endo-but-for-bots#79 — CI on rebased head

Continuation of kriskowal's compound directive on PR #79 (rebase +
shepherd). The weaver returned cleanly (rebase to `master-c49fb04`,
new head `3e12fef1a`); now shepherd CI to green.

## Current state

- PR #79: `test(ses): pin namespace mutation parity with Node.js`,
  OPEN, not draft, MERGEABLE.
- Head: `ses-namespace-mutation-test@3e12fef1a` (just rebased).
- Base: `master-c49fb04@c49fb048b` (just created).
- Diff: 6 files, +177 lines, single-test contribution.

Push of the rebased head landed at 03:22:37Z; new CI checks should be
in flight by the time you start. If the head hasn't triggered checks
yet, give GitHub a moment then proceed.

## Task

Drive PR #79 CI to green. Per the shepherd role:

- Read the check statuses on the new head.
- For real failures (non-flaky, in-scope of the PR's own diff):
  surface to the steward via the standard escalation classification
  (`next: <role>`) per `roles/shepherd/AGENT.md` § Escalation
  classification. The steward applies the shepherd-to-fixer auto-pickup
  chain (`roles/steward/AGENT.md` § Auto-pickup chains) per the
  2026-05-23 codification.
- For flake-shaped failures (timeout, runner died, transient
  network): re-run the failed job(s).
- For pre-existing-base failures (CI failure that is not the PR's
  own fault): apply the operational-flake handling discipline (
  `roles/steward/AGENT.md` § Operational-flake handling) if the
  failure matches a broadcast row, or surface to the steward
  otherwise.

The PR's net diff is small and test-only; substantive CI failures
should be rare. The most likely failure shape is the same
`Deploy TypeDoc site` / `Release` workflows that the bulletin lists
as 100%-failure-on-master (in *Awaits maintainer decision* per
`entries/2026/05/13/004800Z-message-steward-f78473.md`); those are
pre-existing and out of scope.

## Per-action authorizations (forwarded)

- Re-running failed CI jobs on PR #79: implicit in the maintainer's
  "shepherd through CI" verb.
- Posting an explanatory comment on PR #79 if a non-trivial CI
  outcome warrants it: authorized.
- Push to the PR branch to fix a real CI failure: NOT directly
  authorized in this dispatch. If you find a real failure, escalate
  per the classification (`next: fixer`) and stop; the steward
  auto-picks-up the fixer per the standing rule.

## Dispatch protocol

Read in order:

1. `garden/roles/COMMON.md`
2. `garden/roles/shepherd/AGENT.md`
3. Skills your role references just-in-time.

Project worktree starts at `project/` on the
`ses-namespace-mutation-test` branch (detached HEAD at `3e12fef1a`).

## Report

A `result` journal entry. Include: final CI status per check, any
re-runs initiated and their outcomes, any escalation classification
(`next: <role>`) if applicable, and the comment IDs of any
explanatory comments posted.
