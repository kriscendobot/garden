---
ts: 2026-06-03T04:54:53Z
kind: dispatch
role: liaison
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: shepherd
dispatch_root: /home/kris/dispatches/shepherd--797060
prs:
  - repo: endojs/endo-but-for-bots
    pr: 343
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/343
  - https://github.com/endojs/endo-but-for-bots/issues/343
---

# dispatch: shepherd — #343 drive CI to green

Maintainer directive on PR #343 (issue comment, 2026-06-03T04:53:45Z):

> Please shepherd.

PR #343 is the **foundation of the gateway-package design stack**
(`feat(gateway)` design and architecture base). Head `89d68e71e`
on branch `design/gateway-package`; base `llm-b1c3f4d` (NOT the
new `llm-720a396`; the base is a frozen snapshot from before the
recent bots/llm sync).

## Current CI failures (10 jobs, all completed)

- lint
- test (20.x, 22.x, 24.x ubuntu + macos)
- cover (20.x, 24.x ubuntu)
- test-xs

Same shape as #388, #394 — the inherited stack failures
(`packages/ocapn/test/netlayer-tcp-syrup.test.js` `makeClient`
import error + cascade). #343 is the lowest layer of the stack
where these manifest; fixing CI here unblocks the entire phase-2
through phase-10 chain.

## Diagnosis hypothesis

The failures are likely STALE-BASE-induced: #343's base
`llm-b1c3f4d` predates the recent bots/llm sync to actual/master
(which now carries the #3294 fix and possibly other content that
resolves the `makeClient` issue). The bots/llm head is now
`720a39600`.

**The fix may simply be**: rebase #343 onto a new frozen-base
snapshot `llm-720a396`, which would inherit the bots/llm sync's
content.

But the shepherd's job is to DIAGNOSE, not pre-emptively fix.
Per `garden/skills/pr-ci-watch/SKILL.md`:

1. Pull the failing job logs.
2. Classify each failure (real-and-fixer-fixable / known-flake /
   stale-base-induced / etc.).
3. Re-enqueue flakes; surface real failures + suggested fixer
   dispatch to the steward.

Per memory `feedback_shepherd_to_fixer_auto_chain.md`: if you
classify a failure as "real-and-fixer-fixable" (or in this case
likely "needs-rebase-onto-current-llm"), surface that explicitly
in your verdict and the steward auto-dispatches the next role.

## Per-action authorizations

- Pull failing job logs via `gh run view --log-failed` and
  similar. Authorized.
- Re-enqueue CI runs via `gh run rerun --failed` IF a job
  classifies as transient flake. Use judgment; same-flake
  re-enqueues are wasteful.
- Post a classification comment on #343 with the per-job
  verdicts. Authorized.

## Not authorized

- Modifying source files (fixer / weaver work).
- Force-pushing.
- Rebasing #343 (weaver work — surface as escalation if needed).
- Un-drafting / re-drafting / merging.

## Dispatch protocol

Read in order:

1. `/home/kris/dispatches/shepherd--797060/garden/roles/COMMON.md`
2. `/home/kris/dispatches/shepherd--797060/garden/roles/shepherd/AGENT.md`
3. `garden/skills/pr-ci-watch/SKILL.md`
4. Other skills referenced just-in-time.

Project worktree at `project/` on `design/gateway-package` (head
`89d68e71e`).

## Report

A `result` journal entry. Include:

- Per-failure classification with log evidence.
- Action taken (re-enqueue / no-op / classification comment).
- Comment IDs posted.
- Escalation flagged: if classification points at "rebase onto
  llm-720a396" (most likely), say so explicitly so the steward
  can dispatch a weaver next cycle.
