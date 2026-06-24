---
ts: 2026-05-29T20:04:30Z
kind: dispatch
role: steward
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: weaver
dispatch_root: /home/kris/dispatches/weaver--a1b99c
prs:
  - repo: endojs/endo-but-for-bots
    pr: 244
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/issues/244
---

# dispatch: weaver — rebase #244 (sync bot-master to upstream first per directive)

Maintainer kriskowal commented on PR #244 at 2026-05-29T~20:03Z:

> Please rebase and shepherd.

PR #244 (`chore(eslint-plugin): require underscore-delimited groups in
numeric literals`) is kriscendobot-authored, base `master`, head
`chore/eslint-numeric-separators-style-master`,
mergeStateStatus=DIRTY/CONFLICTING, no review decision yet.

Per the standing memory rule on rebase semantics for bot-fork PRs
against master ("Rebase on master implies sync-bot-master-to-upstream
first"; kriskowal directive 2026-05-22T20:01Z), "please rebase" on a
bot-fork master-based PR is the compound:

1. Sync bot-master (`endojs/endo-but-for-bots:master`) to current
   `endojs/endo:master` (force-push under bot identity per the
   memory feedback rule `feedback_bot_master_reset_to_actual.md`).
2. Rebase the PR branch onto the synced master.
3. Conflict-resolve any non-trivial conflicts.
4. Retcon-if-needed (only if the rebase produces messy commits;
   retcon discipline preserves per-package boundaries).
5. Force-with-lease push the rebased head to the PR branch.

The second verb in the directive ("shepherd") follows after the
weaver's push triggers CI. The shepherd dispatch is a separate
steward cycle.

## Task

Execute steps 1-5 above. Do not dispatch the shepherd; the steward
handles that as a follow-up after CI runs on the new head.

## Per-action authorizations (forwarded)

- Sync `endojs/endo-but-for-bots:master` to `endojs/endo:master` via
  force-push under bot identity with `--force-with-lease=master:<prior-sha>`.
  Authorized per memory feedback rule.
- Force-with-lease push to
  `endojs/endo-but-for-bots:chore/eslint-numeric-separators-style-master`
  under bot identity. Authorized.
- Posting an explanatory comment on PR #244 if conflict resolution is
  non-trivial. Authorized.

## Not authorized

- Force-pushing to `endojs/endo:master` upstream (only the bot fork's
  master gets the sync; upstream master is read-only here).
- Un-drafting or re-drafting (PR is already un-drafted).
- Merging (the conductor's job, after CI green via shepherd).
- Modifying any source file beyond conflict resolution.

## Dispatch protocol

Read in order:

1. `/home/kris/dispatches/weaver--a1b99c/garden/roles/COMMON.md`
2. `/home/kris/dispatches/weaver--a1b99c/garden/roles/weaver/AGENT.md`
3. `garden/skills/conflict-resolution/SKILL.md` as needed.
4. `garden/skills/frozen-base-branch/SKILL.md` — consult on whether
   to migrate the PR to a frozen base (per-PR snapshot of master)
   versus rebasing onto the live master. The weaver/conductor pair
   prefers frozen-base for `master`-targeted PRs to isolate concurrent
   PRs from each other (per the post-#357 weaver pattern).
5. `garden/skills/retcon/SKILL.md` if the rebase produces messy
   commits.
6. Other skills the weaver names just-in-time.

Project worktree starts at `project/` on
`chore/eslint-numeric-separators-style-master` (detached HEAD at
`292322fac`).

## Report

A `result` journal entry. Include: bot-master sync SHA, new head SHA
after rebase, the master-base SHA the branch is now atop (live or
frozen), any conflicts resolved (with resolution shape), retcon
disposition (yes/no/why), comment IDs of any explanatory comments.
