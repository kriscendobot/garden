---
ts: 2026-05-29T20:48:19Z
kind: result
role: steward
host: endolinbot
to: "*"
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/244
prs:
  - repo: endojs/endo-but-for-bots
    pr: 244
    role: target
---

# result: steward — #244 base reverted from frozen `master-814dfa1` to live `master` (kriskowal directive)

Maintainer kriskowal commented on PR #244 at 2026-05-29T20:39:12Z:

> Please rebase (adjusting the merge base to match actual master and
> discarding the old master ref).

This reverses the earlier weaver `a1b99c`'s frozen-base migration. The
maintainer's wording is explicit and specific: the frozen `master-814dfa1`
ref is to be discarded and the PR base returned to live `master`.

## Why no weaver / no code rebase

Bot-master (`endojs/endo-but-for-bots:master`) and upstream
(`endojs/endo:master`) are both at `814dfa1fdab4b3d6b8443a808a233e20263ef638`
— the very SHA the frozen ref was pinned to. The PR head
`63a1a60689525a3e395d8f16db8570de1aefa97d` (post-fixer-`d20324`'s lint
fix) already descends from `814dfa1fd`, so the "rebase onto actual
master" is conceptually a no-op for code. Only the base label and the
frozen ref need to change.

Skipping the weaver dispatch overhead: the operation is two CLI calls
under bot identity (PR base migration via `gh pr edit`, ref deletion via
`gh api -X DELETE`), both within steward authority.

## Operations executed

1. `gh pr edit 244 --repo endojs/endo-but-for-bots --base master`
   → PR base now `master` (was `master-814dfa1`).
2. `gh api -X DELETE /repos/endojs/endo-but-for-bots/git/refs/heads/master-814dfa1`
   → frozen ref deleted; no other open PR depended on it (only #377 uses
   a master-* frozen ref, and it's `master-c49fb04`, unaffected).

## Post-state

- baseRefName: `master`
- headRefName: `chore/eslint-numeric-separators-style-master`
- headRefOid: `63a1a60689525a3e395d8f16db8570de1aefa97d`
- mergeStateStatus: `UNSTABLE` (1 FAILURE / 17 SUCCESS in CI — the same
  pre-existing flake; not a mergeability issue)

## Pattern signal

This is the second time the maintainer has corrected the frozen-base
pattern (the post-#357 weaver established it; now the post-#244 weaver
unwinds it for master-targeted PRs). The interpretation question for
the steward is whether this extends to `llm-*` frozen bases as well —
#345 currently sits on `llm-5b1361d`, and #357 was on the same.

Conservative reading of the maintainer's wording ("the old master ref",
singular, specifically referencing master): act only on what was
directed. `llm-*` frozen bases stand until directed otherwise. Flagging
for the next cycle: if a maintainer comment on #345 or #357 echoes the
same shape, treat the llm-* frozen-base pattern as reversed too, and
queue a gardener dispatch to update `skills/frozen-base-branch/SKILL.md`
and the steward AGENT.md.

## Stale worktree teardown

The `dispatches/weaver--c7e089` worktree prepared earlier (when the plan
was a full weaver dispatch) is torn down. Its starting head
(`30bb6725d`) was already stale relative to the actual PR head
(`63a1a606`) due to fixer-`d20324`'s lint commit landing on top.

## Steward queue post-engagement

- **#244** base reverted to live `master`; UNSTABLE on the pre-existing
  CI flake; shepherd dispatch still pending (second verb of the original
  20:03Z `rebase and shepherd` directive — but the base-reversion may
  have changed the shepherd's job; will re-assess in next cycle).
- **#345** rebased onto `llm-5b1361d` (weaver `52ab4e` complete);
  retcon (second verb of the 20:36Z `rebase and retcon` directive)
  pending; fixer dispatch next cycle.
- **#357** APPROVED, UNSTABLE on pre-existing failures; awaiting
  maintainer disposition.
- **#377** awaiting kriskowal reply to fixer's response.
- **#343**, **#358** awaiting kriskowal re-review.
- **#79** unchanged.

Parallel-context note: a liaison on the credentialed host dispatched a
boatman at 20:42:57Z to re-ferry #244 to upstream `endojs/endo#3263`.
That dispatch handled the upstream side; this entry handles the
bot-side base-reversion. No collision — different repos.
