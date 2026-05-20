---
ts: 2026-05-20T06:00:11Z
kind: result
role: liaison
project: endo
to: "*"
refs:
  - entries/2026/05/20/055402Z-dispatch-liaison-456f58.md
  - entries/2026/05/20/055843Z-result-boatman-570d74.md
prs:
  - repo: endojs/endo-but-for-bots
    pr: 109
    role: source
  - repo: endojs/endo
    pr: 3256
    role: target
---

Recompute-from-master re-ferry of `endojs/endo-but-for-bots#109` over `endojs/endo#3256` closed. **Seventh ferry of #109 in the running.**

- Upstream PR head: `e691e86d8` → `f5182df1751df5b809e8b245ee9f86e279e20f79` via force-push-with-lease (lease against `e691e86d8`; lease satisfied at push time).
- **Four new commits** in order, all author + committer `Kris Kowal <kriskowal@kriskowal.com>`, zero bot trailers:
  - `3d4d265fe` feat(syrup-frame): add @endo/syrup-frame package
  - `eaa96182c` feat(ocapn): add opt-in syrup framing to TCP-testing netlayer
  - `f9ea9accd` chore: Update yarn.lock
  - `f5182df17` chore: regenerate composite tsconfig files
- **Cherry-pick conflicts**: none. All four commits applied cleanly onto current `origin/master` (`c063631fed`), including the yarn.lock cherry-pick (no regeneration needed).
- **Pre-flight ancestor/lease check passed**: `origin/feat/syrups-package` was still at `e691e86d8` immediately before push (no concurrent force-update this time).
- **kumavis's APPROVED persists**: anchored on `ed80869d4` (an old commit OID from the original ferry); the review record stays in the reviews array even though the anchor is no longer reachable.
- Source-side cross-link on #109: [issuecomment-4494988553](https://github.com/endojs/endo-but-for-bots/pull/109#issuecomment-4494988553).

## Naming check observation

The boatman's naming-finding step reported that **code paths are uniformly singular `'syrup'`** (`@endo/syrup-frame`, `makeSyrupReader`, `'syrup'` framing value, `netlayer-tcp-syrup.test.js`, `syrup-initial.md` / `ocapn-tcp-syrup-framing.md` changesets). At the time the boatman ran the check, the **upstream PR's title still used plural `syrups`** ("opt-in syrups framing"). The boatman did not edit the title (user did not ask).

**Liaison-side update**: by the time the liaison verified post-push (~5 min after the boatman's check), the upstream PR's title had been edited to match the code — the title now reads `feat(syrup-frame): add @endo/syrup-frame package and opt-in syrup framing for OCapN TCP-for-testing` (singular `syrup`). The user appears to have edited the title between the boatman's check and the liaison's post-push verification. **Only the branch name remains plural** (`feat/syrups-package`); renaming the branch is non-trivial on an open PR (would require creating a new branch and force-pushing it, then closing/reopening the PR) and is probably not worth the friction. Surface for user awareness; no action recommended.

Worktree-index marked collected; dispatch root torn down.

Self-improvement: nothing new this turn. The recompute-from-master shape applied cleanly; the `kriskowal@kriskowal.com` attribution default landed correctly. The user-side title-edit-mid-ferry is a real concurrency pattern but the boatman's read-only naming check + the liaison's post-push verification together caught it without conflict — no procedural change needed.
