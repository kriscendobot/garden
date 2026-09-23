---
ts: 2026-06-04T00:41:59Z
kind: dispatch
role: liaison
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: shepherd
dispatch_root: /home/kris/dispatches/shepherd--114663
prs:
  - repo: endojs/endo-but-for-bots
    pr: 418
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/418
  - https://github.com/endojs/endo-but-for-bots/pull/418#issuecomment-4617916812
---

# dispatch: shepherd — #418 nine CI failures (Pray shepherd)

Maintainer directive (kriskowal, comment `4617916812`, 2026-06-04T00:41:16Z):

> Please shepherd.

User: "This seems stalled. Please shepherd to completion."

## Target

- PR: endojs/endo-but-for-bots#418
- Branch: `fix/endo-make-node-evasive-runtime`
- Head: `0bbf4e8ec` (post fixer `091a1a`'s evasive-parser
  injection refactor).
- Base: `llm-720a396`.
- State: DRAFT.

## Current CI failures (9 jobs, all completed)

- lint
- test (20.x, 22.x, 24.x; ubuntu + macos)
- cover (20.x, 24.x ubuntu)

## Diagnosis hypotheses

Two leading candidates:

1. **Stale-base induced**: #418's base `llm-720a396` is a
   frozen snapshot. Since then, llm has advanced (#367, #370,
   #414, #400 merges + zizmor fix landed at #3297 / bot-master
   `07aff334e`). #418 may be lagging.

2. **Refactor regression**: Fixer `091a1a`'s evasive-parser
   injection refactor (moved parser-map wiring from
   `worker.js` into Node-specific powers layer) may have a
   test still expecting the direct path.

The shape is BOTH possible; lint+test+cover with no test-xs
suggests it could be either. Logs will discriminate.

## Procedure

Per `garden/skills/pr-ci-watch/SKILL.md`:
1. Pull failing job logs.
2. Classify each:
   - If stale-base shape (e.g.,
     `packages/ocapn/test/netlayer-tcp-syrup.test.js`
     `makeClient`): surface as `next: weaver` (rebase onto
     fresh llm).
   - If refactor-induced (e.g., test references injected
     power signature that's off): surface as `next: fixer`.
   - Mixed: surface both.
3. Post a classification comment on #418.
4. Re-enqueue flakes if any.

Per memory `feedback_shepherd_to_fixer_auto_chain.md`,
escalate explicitly via `next: <role>` so the steward auto-
chains.

## Per-action authorizations

- Pull failing job logs. Authorized.
- Re-enqueue CI runs for transient flakes. Authorized.
- Post a classification comment. Authorized.

## Not authorized

- Modifying source files.
- Force-pushing.
- Rebasing (weaver's job).
- Un-drafting / merging.

## Dispatch protocol

Read in order:

1. `/home/kris/dispatches/shepherd--114663/garden/roles/COMMON.md`
2. `/home/kris/dispatches/shepherd--114663/garden/roles/shepherd/AGENT.md`
3. `garden/skills/pr-ci-watch/SKILL.md`

Project worktree at `project/` on `fix/endo-make-node-evasive-runtime`
(head `0bbf4e8ec`).

## Report

A `result` journal entry. Include:

- Per-failure classification with log evidence.
- Action taken (re-enqueue / no-op / classification comment).
- Comment IDs posted.
- Escalation with `next: <role>` if applicable (likely
  `next: weaver` and/or `next: fixer`).
