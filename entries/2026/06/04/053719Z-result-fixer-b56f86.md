---
ts: 2026-06-04T05:37:19Z
kind: result
role: fixer
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
dispatch_root: /home/kris/dispatches/fixer--533a68
short_id: b56f86
prs:
  - { repo: endojs/endo-but-for-bots, pr: 244, role: target }
refs:
  - entries/2026/06/04/052416Z-dispatch-fixer-533a68.md
  - https://github.com/endojs/endo-but-for-bots/pull/244
  - https://github.com/endojs/endo-but-for-bots/pull/244#issuecomment-4619295328
---

# result: fixer — bots#244 rebased onto master-07aff33; CI green; ready for re-ferry

## Outcome

- Old base: `master-ba26f4c` (SHA `ba26f4cdb`).
- New base: `master-07aff33` (pins `endojs/endo-but-for-bots:master` at `07aff334e`). The branch already existed on origin (likely created by a concurrent PR rebase); reused per `skills/frozen-base-branch/SKILL.md` § *When the frozen-base sha collides*.
- New PR head: `6757edc8f4e2814b9ac4eb91dfc7b598d4d9b15d` (force-pushed with `--force-with-lease` from prior `dbe04c499`).
- PR #244 `base` field updated via `gh pr edit 244 --base master-07aff33`; `mergeable: MERGEABLE`.

## Rebase mechanics

Used `git rebase --onto origin/master-07aff33 origin/master-ba26f4c HEAD` per `skills/rebase-before-followup/SKILL.md` § *Cross-base rebase requires --onto*. Both PR commits (`chore(eslint-plugin)…` and `chore: Update yarn.lock`) replayed cleanly with no conflicts. Master's two intervening commits (`31d6b8808`, `07aff334e`) touched only `.github/workflows/release.yml`, which the PR does not touch.

`yarn install` on the rebased tree was a no-op (clean working tree afterward); the existing `chore: Update yarn.lock` commit carries forward without regeneration.

## CI rollup

Initial run: 15 success, 1 failure (`test (22.x, macos-15)` — `endo › lifecycle` with `RemoteError: write EPIPE`, the well-known flaky daemon-connection test on macOS, unrelated to the PR's eslint-plugin substance).

Re-ran the failed job via `gh run rerun 26932721123 --failed`. Final rollup: **SUCCESS=16** (all checks pass).

## PR comment

Posted top-level summary at https://github.com/endojs/endo-but-for-bots/pull/244#issuecomment-4619295328, citing the new base branch + SHA, the rebased head SHA, and the maintainer's intent to re-ferry. Standing relaxation on `endojs/endo-but-for-bots` covers the comment.

## Out-of-scope items left untouched

- Old frozen-base branch `master-ba26f4c` not deleted (other PRs may reference it; deletion happens later under separate authority).
- No lint/test cleanup beyond what the rebase mechanically required.

## Self-improvement

The frozen-base SKILL.md's "branch already exists on origin" branch (skill § *When the frozen-base sha collides*) is documented but easy to miss because the *Create at PR open* section reads as imperative push. Worth a forward reference in *Rebase: move both base and head* to make the "if it already exists, reuse it" branch first-class on the rebase path too; concurrent rebases will hit this often as more PRs adopt the convention. Will surface as a small inbox note rather than land directly. Self-improvement: forward-reference the existing-branch reuse in `frozen-base-branch/SKILL.md` § *Rebase: move both base and head* so concurrent rebasers find the no-push-needed branch on first read.
