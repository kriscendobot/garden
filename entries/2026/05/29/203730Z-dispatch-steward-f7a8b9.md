---
ts: 2026-05-29T20:37:30Z
kind: dispatch
role: steward
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: weaver
dispatch_root: /home/kris/dispatches/weaver--37859b
prs:
  - repo: endojs/endo-but-for-bots
    pr: 345
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/345
---

# dispatch: weaver — rebase #345 onto current llm (kriskowal directive)

Maintainer kriskowal commented on PR #345 at ~2026-05-29T20:36Z:

> Please rebase and retcon.

PR #345 (`feat(cancel): @endo/cancel cancellation primitive (mirror of
endojs/endo#3032)`) is kriscendobot-authored, base `llm`, head
`mirror/3032-cancel`, mergeStateStatus=DIRTY/CONFLICTING.

The verb pair maps to:
1. **rebase**: weaver migrates the PR onto a frozen base
   (`llm-<sha>` snapshot of current `origin/llm`) per the
   `frozen-base-branch` skill (this is now standard after the
   post-#357 weaver pattern).
2. **retcon**: separate fixer dispatch *after* this weaver's push
   lands. The retcon skill restructures commits per-package boundary
   per `skills/retcon/SKILL.md`.

This dispatch is the weaver only — the fixer (retcon) follows in the
next steward cycle.

## Why no master sync

Unlike #244 (which was master-based), #345's base is `llm`. The
bot-master sync rule from `feedback_rebase_on_master_implies_sync.md`
applies to master-based PRs only. No upstream sync needed for `llm`
(it's a bot-fork-only long-lived branch).

## Task

1. Fetch current `origin/llm` head.
2. Create frozen-base `llm-<sha>` snapshot if not already present.
3. Rebase `mirror/3032-cancel` onto the frozen-base snapshot.
4. Resolve any conflicts non-trivially.
5. Force-with-lease push to `mirror/3032-cancel`.
6. Migrate PR base via `gh pr edit 345 --base llm-<sha>`.

Do NOT retcon — that's the fixer's job in the next cycle. The weaver
just rebases; the retcon happens after.

## Per-action authorizations (forwarded)

- Create `llm-<sha>` frozen-base branch on the fork. Authorized.
- Force-with-lease push to
  `endojs/endo-but-for-bots:mirror/3032-cancel` under bot identity.
  Authorized.
- Migrate PR base via `gh pr edit 345 --base llm-<sha>`. Authorized.
- Posting an explanatory comment on PR #345 if conflict resolution
  is non-trivial. Authorized.

## Not authorized

- Restructuring commits (retcon). The fixer handles that next cycle.
- Modifying any source file beyond conflict resolution.
- Force-pushing to `llm`.
- Un-drafting or re-drafting.

## Dispatch protocol

Read in order:

1. `/home/kris/dispatches/weaver--37859b/garden/roles/COMMON.md`
2. `/home/kris/dispatches/weaver--37859b/garden/roles/weaver/AGENT.md`
3. `garden/skills/frozen-base-branch/SKILL.md`
4. `garden/skills/conflict-resolution/SKILL.md` as needed.

Project worktree starts at `project/` on `mirror/3032-cancel`
(detached HEAD at `78e29b255`).

## Report

A `result` journal entry. Include: new head SHA after rebase, the
llm-base SHA and frozen-base branch name the branch is now atop,
any conflicts resolved (with resolution shape), comment IDs of any
explanatory comments.
