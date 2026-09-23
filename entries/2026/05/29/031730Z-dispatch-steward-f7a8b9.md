---
ts: 2026-05-29T03:17:30Z
kind: dispatch
role: steward
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: weaver
dispatch_root: /home/kris/dispatches/weaver--917bc6
prs:
  - repo: endojs/endo-but-for-bots
    pr: 79
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/79#issuecomment-4570135880
---

# dispatch: weaver on endojs/endo-but-for-bots#79 — rebase on bot-master + frozen-base anchor

Maintainer directive from kriskowal at 2026-05-29T03:15:13Z on garden
PR #79: *"Please rebase on master, anchor the PR base to the current
master-xxxxxxx, and shepherd through CI."*
(Comment URL: https://github.com/endojs/endo-but-for-bots/pull/79#issuecomment-4570135880)

The steward posted the eyes (👀) reactji on the comment at
2026-05-29T03:17:00Z and is dispatching this weaver to execute the
rebase. A shepherd dispatch follows the weaver's return.

## Current state (read at dispatch time)

- PR #79: `test(ses): pin namespace mutation parity with Node.js`, OPEN,
  not draft, mergeable=MERGEABLE.
- Head: `ses-namespace-mutation-test@40143c4d1` (the head you start
  from in `project/`).
- Base: `llm@ea8f5bfb5` (the maintainer wants this moved to a
  `master-<sha>` frozen base).
- Bot master: `endojs/endo-but-for-bots@master = 67c5fcd8e`.
- Upstream master: `endojs/endo@master = c49fb048b`. **Bot master is
  behind upstream**, so the rebase-on-master sequence implies the
  bot-master sync first (per kriskowal's 2026-05-22T20:01Z
  confirmation that "rebase on master" is the compound on bot
  PRs).
- Existing frozen-base branches under `master-*`: only
  `master-455ce47` exists (at 455ce4749). This is older than current
  bot/master and well-older than current upstream/master.

## Task

Execute the rebase per the compound directive. The exact shape lives
in `garden/skills/frozen-base-branch/SKILL.md` and the weaver role
file. The expected sequence is:

1. Sync `endojs/endo-but-for-bots@master` to
   `endojs/endo@master` (currently `67c5fcd8e` → `c49fb048b`).
   This is a kriscendobot-identity force-push to the bot fork's
   master; no kriskowal identity needed. Per skill discipline use
   `--force-with-lease=master:67c5fcd8e` to make the lease anchor
   explicit. If the lease check fails (someone advanced bot/master
   in the meantime), re-fetch and re-decide.

2. Create the new frozen-base branch `master-c49fb04` at the
   new bot/master tip (`c49fb048b9...`), per the
   `frozen-base-branch` skill's `<base>-<7-char-short-sha>` naming.

3. Move PR #79's base from `llm` to `master-c49fb04` via
   `gh pr edit 79 --base master-c49fb04` (the bot has write
   on the bot fork; this is not a kriskowal action).

4. Rebase the head branch `ses-namespace-mutation-test` onto
   `master-c49fb04`. The PR is a single-file test addition
   (test/ses-namespace-mutation-test by the title); conflicts
   should be rare but resolve them per the weaver role's
   `conflict-resolution` skill if any surface.

5. Force-push the rebased head with `--force-with-lease=ses-
   namespace-mutation-test:40143c4d1` to make the lease anchor
   explicit.

6. Update the bulletin / `journal/projects/endo-but-for-bots/`
   notes if the rebase exposed anything noteworthy (a non-trivial
   conflict resolution, a retcon need, etc.). If a retcon is
   warranted, surface to a `message: weaver → steward` and stop;
   the steward dispatches the fixer for the retcon as a separate
   step.

## Per-action authorizations the steward forwards

- Force-push to `endojs/endo-but-for-bots:master` under kriscendobot
  identity (the sync step). Authorization implicit in the maintainer's
  "rebase on master" directive (which the steward parsed as the
  compound sync+rebase per the standing convention; see
  `feedback_rebase_on_master_implies_sync` memory the steward
  carries).
- Force-push to `endojs/endo-but-for-bots:ses-namespace-mutation-test`
  under kriscendobot identity (the rebase step). Authorization
  implicit in the directive's "rebase" verb.
- `gh pr edit 79 --base master-c49fb04` under kriscendobot identity.
  Authorization implicit in "anchor the PR base."
- Posting an explanatory comment on PR #79 if the conflict resolution
  is non-trivial: per-action authorization granted (the maintainer
  comments freely on the bot's bot-fork PRs; explanatory comments
  on the maintainer's own directive are in scope).

**Not authorized this dispatch**: opening or modifying any PR on
upstream `endojs/endo`; cross-linking #79's upstream mirror
endojs/endo#3231 (separate cross-link discipline, already handled
via the backfill); shepherd dispatch (steward will dispatch
shepherd separately after this weaver returns).

## Dispatch protocol

Read in order:

1. `garden/roles/COMMON.md`
2. `garden/roles/weaver/AGENT.md`
3. `garden/skills/frozen-base-branch/SKILL.md` (consult as needed)
4. Skills the weaver names just-in-time.

Project worktree starts at `project/` on the
`ses-namespace-mutation-test` branch (detached HEAD at `40143c4d1`).

## Report

A `result` journal entry. Include: new bot/master SHA, new
frozen-base branch name and SHA, new head SHA after rebase, any
conflicts resolved (with the resolution shape), whether a retcon
is warranted, and the comment IDs of any explanatory comments
posted.
