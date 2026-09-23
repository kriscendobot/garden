---
ts: 2026-06-03T22:34:14Z
kind: dispatch
role: liaison
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: conductor
dispatch_root: /home/kris/dispatches/conductor--c37e61
prs:
  - repo: endojs/endo-but-for-bots
    pr: 400
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/400
  - entries/2026/06/03/223236Z-result-weaver-06a758.md
---

# dispatch: conductor — #400 merge (post-weaver rebase)

Weaver `06a758` rebased #400 cleanly onto current `llm`. PR is
now MERGEABLE / CLEAN at `aeccae207`. Re-dispatching conductor.

## Target

- PR: endojs/endo-but-for-bots#400
- Head: `aeccae207` (post-rebase).
- Base: `llm`.
- Mergeable state: CLEAN.
- Review state: APPROVED (kriskowal `4423229570`).
- Draft state: DRAFT — un-draft before merging.

## Per-action authorizations

- `gh pr ready 400` (un-draft). Authorized.
- Merge per conductor canonical norm. Authorized (no merge
  method named per memory rule).

## Not authorized

- Force-pushing.
- Re-drafting.
- Closing without merging.

## Dispatch protocol

Read in order:

1. `/home/kris/dispatches/conductor--c37e61/garden/roles/COMMON.md`
2. `/home/kris/dispatches/conductor--c37e61/garden/roles/conductor/AGENT.md`
3. Other skills referenced just-in-time.

Project worktree at `project/` on `groom/mcp-bridge-rebucket`
(head `aeccae207`).

## Report

A `result` journal entry. Include:

- Merge SHA on `llm`.
- Merge method used.
- Un-draft action.
- Branch cleanup status.
