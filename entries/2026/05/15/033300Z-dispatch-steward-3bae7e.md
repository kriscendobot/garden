---
ts: 2026-05-15T03:33:00Z
kind: dispatch
role: steward
project: endo-but-for-bots
to: "*"
prs:
  - repo: endojs/endo-but-for-bots
    pr: 109
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/109#issuecomment-4456621860
---

# Dispatch: fixer ferries actual/master → master, rebases #109, retcons (per maintainer comment 4456621860)

Dispatch root: `dispatches/fixer--3bae7e/`. Project worktree on `endojs/endo-but-for-bots@feat/syrups-package` (detached at `cfa440f2c`).

## The directive

Maintainer comment on PR #109 at 03:25:52Z (verbatim):

> We need to sync actual/master to master, then rebase this change on master. Then, we need to retcon the PR.

Three coupled steps. Single dispatch handles all three sequentially to keep the operation atomic from the maintainer's perspective.

## Per-action authorization

- **Step 1 — Ferry actual/master to master**. Add or reuse remote `actual` pointing at `endojs/endo.git` (the upstream, not the bot fork). `git fetch actual master`. Fast-forward (or merge if non-FF) `actual/master` into `origin/master` on the bot fork. Push under kriscendobot identity.
- **Step 2 — Rebase #109 onto new master**. `git checkout --detach origin/master` (post-step-1), then cherry-pick #109's commits from `feat/syrups-package` onto the new master. Resolve conflicts surfacing from the upstream sync.
- **Step 3 — Retcon #109**. Per `skills/retcon/SKILL.md`: reset to base (now post-step-2 master), restage one commit per affected package with conventional-commit messages, separate `chore: Update yarn.lock`. Force-push `feat/syrups-package` with `--force-with-lease`. The PR's net diff is invariant by construction.

No comment on PR #109 in this dispatch — the action IS the response.

## Identity

`kriscendobot` for all pushes. The ferry-down direction (upstream → bot fork's own master) does not require kriskowal-identity authorization because the destination is the bot fork's own branch, not endojs/endo's master.

## Out of scope

- No edit to the diff itself (the retcon preserves net diff).
- No touch to endojs/endo's master.
- No master-base mirror in this dispatch.
- No edit to PR title/body unless the retcon's commit-list reshape demands it.

## Conflict handling

If the upstream sync surfaces conflicts in #109's surface (`packages/syrup-frame/**`, `packages/ocapn/**`):

- Conflict in test fixtures: hand-resolve to preserve #109's intended behavior; the syrup-frame package is bot-side new work, so upstream conflicts should be rare.
- Conflict in `packages/ocapn/**` from upstream `chore` bumps: prefer upstream's bumps, re-apply #109's logic on top.
- Conflict in unrelated files: prefer upstream verbatim.
- If conflicts exceed the fixer's confidence, stop at impasse and surface back with the conflict list; do not push under uncertainty.

## Commits

- Step 1's merge commit (FF if possible; merge commit if non-FF) on origin/master.
- Step 2 produces N cherry-picked commits on detached HEAD.
- Step 3 squashes those N commits into the retcon's package-grouped commits.
- Final push: `git push origin HEAD:feat/syrups-package --force-with-lease`.

## Report

≤ 500 words. The three steps' outcomes (ferry SHA range, rebase conflict count, retcon commit list), the final head SHA on `feat/syrups-package`, and one-line `Self-improvement: ...`. If any step stops at impasse, name the impasse clearly.
