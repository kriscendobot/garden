---
ts: 2026-06-03T03:46:53Z
kind: dispatch
role: liaison
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: weaver
dispatch_root: /home/kris/dispatches/weaver--2d9240
prs:
  - repo: endojs/endo-but-for-bots
    pr: 351
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/351
  - https://github.com/endojs/endo-but-for-bots/pull/351#pullrequestreview-4415266443
---

# dispatch: weaver — rebase #351 onto bot-master (sync already done)

Maintainer directive (kriskowal review `4415266443`,
CHANGES_REQUESTED, 2026-06-03T03:45:55Z):

> Please rebase on actual master. That should clear CI.

PR #351 is the kriscendobot mirror of endojs/endo#2422
(`feat(compartment-mapper): Host module exits`), branch
`mirror/2422-host-module-exits`, head `78818890`.

Per memory `feedback_rebase_on_master_implies_sync.md`,
"rebase on master" is the compound: (1) sync bot-master to
upstream master, (2) rebase, (3) conflict-resolve, (4)
retcon-if-needed. **Step 1 is already done** by the earlier
`weaver--496105` dispatch (bot-master mirrors upstream at
`ba26f4cdb`). This dispatch covers steps 2-4.

## Procedure

1. Rebase `mirror/2422-host-module-exits` onto `origin/master`
   (which is now `ba26f4cdb`).
2. Conflict-resolve per `garden/skills/conflict-resolution/
   SKILL.md` (weave intents; no `--ours`/`--theirs`).
3. Retcon if the resulting commit shape diverges from the
   maintainer's preferred shape for this PR. (Look at the
   pre-rebase commit shape; if it's a 1-2-commit form like
   the prior #387 retcon shape, preserve it.)
4. Force-with-lease push using `78818890` (the prior head)
   as the lease anchor.

The PR is NOT draft. After successful push, CI will re-run.
Per the maintainer's note, this should clear CI.

## Per-action authorizations

- Rebase `mirror/2422-host-module-exits` onto `origin/master`.
  Authorized.
- Conflict-resolve. Authorized.
- Retcon if needed. Authorized.
- Force-with-lease push using `78818890` as anchor. Authorized.

## Not authorized

- Modifying any other branches.
- Force-pushing without `--force-with-lease` anchor.
- Un-drafting / re-drafting / merging.

## Dispatch protocol

Read in order:

1. `/home/kris/dispatches/weaver--2d9240/garden/roles/COMMON.md`
2. `/home/kris/dispatches/weaver--2d9240/garden/roles/weaver/AGENT.md`
3. `garden/skills/conflict-resolution/SKILL.md`
4. `garden/skills/retcon/SKILL.md` (only if a retcon is needed).
5. Other skills referenced just-in-time.

Project worktree at `project/` on `mirror/2422-host-module-exits`
(refetch since the prepare snapshot may be stale; the head
`78818890` is the lease anchor either way).

## Report

A `result` journal entry. Include:

- Pre-rebase head SHA (the lease anchor).
- Post-rebase head SHA.
- Number of commits replayed.
- Conflict-resolution summary (which files, which side prevailed
  and why), if any.
- Retcon decision (kept original shape vs reshaped, with reason).
- Force-push exit code.
