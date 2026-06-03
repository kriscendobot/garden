---
ts: 2026-06-03T20:44:21Z
kind: dispatch
role: liaison
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: shepherd
dispatch_root: /home/kris/dispatches/shepherd--9985b3
prs:
  - repo: endojs/endo-but-for-bots
    pr: 394
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/394
---

# dispatch: shepherd — #394 drive CI to green (Pray shepherd)

Maintainer directive on #394 issue comment 2026-06-03T20:43:57Z:

> Pray shepherd.

PR #394 (gateway phase-6, head `a57332f69`, base
`design/gateway-package-phase-5`) has 10 failing CI jobs:
- lint
- test (20.x, 22.x, 24.x; ubuntu + macos)
- cover (20.x, 24.x ubuntu)
- test-xs

This is the SAME failure shape as #343 had pre-rebase. #343 was
the foundation; the steward's earlier weaver `59079d` rebased it
onto `llm-720a396` (the synced bots/llm), clearing those root
causes. But the gateway-package stack's middle phases (phase-2
through phase-5) have NOT been cascade-rebased — each still
points at its old frozen base.

## Diagnosis hypothesis

Same as #343: stale-base-induced. The fix is cascade-rebase
through #388 → #389 → #392 → #393 → #394 onto the rebased #343.

The shepherd's job per `skills/pr-ci-watch/SKILL.md` is to
diagnose, classify, and (where applicable) re-enqueue flakes.
Per memory `feedback_shepherd_to_fixer_auto_chain.md` extended
to weaver: if the verdict points at "rebase needed" (likely),
surface that explicitly so the steward auto-dispatches a
weaver cascade.

## Per-action authorizations

- Pull failing job logs. Authorized.
- Re-enqueue CI for transient flakes (use judgment).
  Authorized.
- Post a classification comment on #394 with per-job verdicts.
  Authorized.

## Not authorized

- Modifying source files (fixer/weaver work).
- Force-pushing.
- Rebasing (weaver work; surface as escalation).
- Un-drafting / merging.

## Dispatch protocol

Read in order:

1. `/home/kris/dispatches/shepherd--9985b3/garden/roles/COMMON.md`
2. `/home/kris/dispatches/shepherd--9985b3/garden/roles/shepherd/AGENT.md`
3. `garden/skills/pr-ci-watch/SKILL.md`

Project worktree at `project/` on `design/gateway-package-phase-6`
(head `a57332f69`).

## Report

A `result` journal entry. Include:

- Per-failure classification with log evidence.
- Action taken (re-enqueue / no-op / classification comment).
- Comment IDs posted.
- Escalation flagged with `next: <role>` per
  `roles/shepherd/AGENT.md` § Escalation classification (likely
  `next: weaver` for cascade-rebase).
