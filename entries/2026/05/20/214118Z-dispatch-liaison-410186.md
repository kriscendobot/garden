---
ts: 2026-05-20T21:41:18Z
kind: dispatch
role: liaison
project: endo
to: "*"
refs:
  - entries/2026/05/20/060011Z-result-liaison-456f58.md
prs:
  - repo: endojs/endo-but-for-bots
    pr: 109
    role: source
  - repo: endojs/endo
    pr: 3256
    role: target
---

Re-ferry `endojs/endo-but-for-bots#109` over `endojs/endo#3256`. **Recompute-from-master force-push** with current master tip `ec3dcbc0`. **Eighth ferry of #109 in the running.**

## What's different this time

- **Source #109 head is unchanged** at `2627e81a3d5881e817eb0e11c4596ae4c060f9c9` — the same 4-commit shape from the prior ferry. No new bot work since.
- **Upstream master has advanced 11 commits** since the prior recompute (was `c063631fed`, now `ec3dcbc0cbf65b0b65725d041d4ee8f2ccf1610f`). Notable new master commits:
  - `f22f4b5d chore: Drop Node 18 and 20 (#3084)` — the Node 18/20 drop landed.
  - `36104778 chore: bump actions/checkout from 4.3.1 to 6.0.2 (#3236)`.
  - `ec3dcbc0 fix(skel): remove too-broad includes from default tsconfig (#3271)` (most recent; 21:28Z, ~24 min before this dispatch).
- The current upstream PR `#3256` is at `f5182df1751df5b809e8b245ee9f86e279e20f79` (the boatman's prior recompute). Its tree differs from current master because master has the 11 new commits.

The natural read of "ferry #109 again" with an unchanged source head but an advanced upstream master is: **rebase the upstream PR onto the new master tip**, applying the source's intent on top of the fresher master.

## Source (unchanged)

- Repo: `endojs/endo-but-for-bots`, PR #109.
- Branch: `feat/syrups-package`
- Head: `2627e81a3d5881e817eb0e11c4596ae4c060f9c9`
- 4 commits (same as the prior ferry):
  1. `dc729c8b feat(syrup-frame): add @endo/syrup-frame package`
  2. `561e54ed feat(ocapn): add opt-in syrup framing to TCP-testing netlayer`
  3. `f7e9339e chore: Update yarn.lock`
  4. `2627e81a chore: regenerate composite tsconfig files`

## Upstream (to be replaced)

- Repo: `endojs/endo`, PR #3256.
- Branch: `feat/syrups-package`
- Current head: `f5182df1751df5b809e8b245ee9f86e279e20f79` (the prior recompute's tip).
- State: OPEN, **APPROVED** by kumavis (still persisting; anchored on an old commit OID from the original ferry).
- New master tip: `ec3dcbc0cbf65b0b65725d041d4ee8f2ccf1610f`.

## Human

`Kris Kowal <kriskowal@kriskowal.com>`. **identity_switch_authorized: true**.

## Dispatch root

`/Users/kris/garden/dispatches/boatman--ferry-syrup-frame-109-rebase-on-new-master--20260520-214109--410186/`. Project worktree on `endojs/endo:origin/feat/syrups-package` (detached at `f5182df17`).

## Boatman direction

- Detach at `origin/master` (`ec3dcbc0`), NOT at the current upstream tip. Recompute-from-master onto the fresher master.
- Set local `user.name='Kris Kowal'` / `user.email='kriskowal@kriskowal.com'`.
- Cherry-pick the 4 source commits (`dc729c8b`, `561e54ed`, `f7e9339e`, `2627e81a`) onto `origin/master`. Preserve as 4 commits.
- Use `cherry-pick + git commit --amend --reset-author --no-edit` per commit.
- **Expect conflict on commit 4** (`chore: regenerate composite tsconfig files`): the new master commit `ec3dcbc0 fix(skel): remove too-broad includes from default tsconfig (#3271)` likely touches `tsconfig.composite.json` files. The source's commit 4 regenerates the same files. Resolve by **regenerating against current master rather than verbatim-applying the source's commit 4** if possible — the goal is consistent composite-tsconfig state on the new master, not a verbatim re-apply of stale regeneration output. If a regeneration script exists (`yarn build`, `yarn build:typescript`, or similar), use it; otherwise apply the source's commit 4 and let CI catch any drift.
- **Yarn.lock**: the new master may have a different yarn.lock. If commit 3 conflicts, apply the source's intent (the package addition) and regenerate via `yarn install --mode=update-lockfile` (the established remedy from the agoric-sdk ferry; see `entries/2026/05/20/024415Z-result-boatman-25ace0.md`).
- **Trailer-strip discipline**: `git interpret-trailers --parse` per commit. Always.
- **Verify attribution**: `git log origin/master..HEAD --pretty=fuller` shows 4 commits, all author + committer `Kris Kowal <kriskowal@kriskowal.com>`.
- **Pre-flight ancestor/lease check**: `git fetch origin feat/syrups-package` to refresh, then confirm `origin/feat/syrups-package` is still at `f5182df17` (the lease tip). The user has been actively cleaning up PRs; concurrent force-pushes are possible.
- **Force-push with lease**: `git push origin HEAD:feat/syrups-package --force-with-lease=feat/syrups-package:f5182df1751df5b809e8b245ee9f86e279e20f79`.
- **Title and body untouched** (the title was edited concurrently last time to align singular `syrup`; the user did not ask for further changes this turn).
- Source-side cross-link comment on `endojs/endo-but-for-bots#109`: post under kriskowal. Name the new upstream head SHA, that the rebase was onto the new master tip, and the four-commit shape preserved.
- **Identity discipline on `endojs/endo#3256`**: NO direct comments.

## Expected report

≤300 words:
- New master tip used (`ec3dcbc0`) + upstream head SHA after force-push + four new commit SHAs.
- Attribution verified.
- Pre-flight ancestor/lease check passed.
- Push mode (force-with-lease, not unsafe `--force`).
- Conflict resolution notes — especially on commit 4 (tsconfig.composite.json regeneration) and commit 3 (yarn.lock).
- kumavis-approval persistence check.
- Source-side cross-link URL.
- One-line `Self-improvement: ...`.

If blocked, `message`-to-liaison and stop.
