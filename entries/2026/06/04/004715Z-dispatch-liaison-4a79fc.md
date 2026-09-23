---
ts: 2026-06-04T00:47:15Z
kind: dispatch
role: liaison
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: weaver
dispatch_root: /home/kris/dispatches/weaver--4a79fc
prs:
  - repo: endojs/endo-but-for-bots
    pr: 418
    role: target
refs:
  - entries/2026/06/04/004556Z-result-shepherd-114663.md
---

# dispatch: weaver — #418 rebase onto fresh llm (shepherd auto-chain)

Shepherd `114663` classified all 9 #418 failures as
stale-base. Per memory `feedback_shepherd_to_fixer_auto_chain.md`
extended to weaver, steward auto-dispatches.

Two repairs are present on current llm but not on
`llm-720a396`:

1. `032d88462 fix(bytes,hex): resync SECURITY.md to canonical
   GitHub spelling` (fixes lint).
2. `608809998 fix(deps): dedup ava to a single virtual store`
   (fixes 8 test+cover jobs, was rolled into `9d826ce81`).

## State

- **Current llm**: `2bd9e0cbb` — `docs(designs):
  daemon-git follow-ups (#370)`.
- **#418 base**: `llm-720a396` (lags 19 commits).
- **#418 head**: `0bbf4e8ec` on
  `fix/endo-make-node-evasive-runtime`.

## Procedure

1. Push new frozen-base snapshot `llm-2bd9e0c` from current
   `origin/llm` (`2bd9e0cbb`).
2. Rebase `fix/endo-make-node-evasive-runtime` onto
   `llm-2bd9e0c`.
3. Conflict-resolve per `garden/skills/conflict-resolution/
   SKILL.md`. Expected: clean replay (the fixer's refactor
   was scoped to `packages/daemon/src/worker.js` and a few
   Node-side bootstraps; unlikely to overlap with the new
   llm commits which touch designs/security/dedup).
4. Force-with-lease push using `0bbf4e8ec` as lease anchor.
5. `gh pr edit 418 --base llm-2bd9e0c`.

## Per-action authorizations

- Push new frozen-base `llm-2bd9e0c`. Authorized.
- Rebase `fix/endo-make-node-evasive-runtime`. Authorized.
- Force-with-lease push using `0bbf4e8ec` as anchor.
  Authorized.
- `gh pr edit 418 --base llm-2bd9e0c`. Authorized.

## Not authorized

- Force-pushing without lease anchor.
- Editing source beyond conflict resolution.
- Un-drafting / merging.

## Dispatch protocol

Read in order:

1. `/home/kris/dispatches/weaver--4a79fc/garden/roles/COMMON.md`
2. `/home/kris/dispatches/weaver--4a79fc/garden/roles/weaver/AGENT.md`
3. `garden/skills/conflict-resolution/SKILL.md`
4. `garden/skills/frozen-base-branch/SKILL.md`

Project worktree at `project/` on `fix/endo-make-node-evasive-runtime`
(head `0bbf4e8ec`).

## Report

A `result` journal entry. Include:

- Pre/post-rebase head SHAs.
- New frozen-base SHA.
- Commit count replayed.
- Conflict-resolution summary (expected: none).
- Force-push exit code.
- `gh pr edit --base` exit code.
- Mergeable-state expectation.
