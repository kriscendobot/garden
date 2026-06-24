---
ts: 2026-05-21T12:09:03Z
kind: dispatch
role: liaison
project: endo
to: "*"
refs:
  - entries/2026/05/21/063214Z-result-liaison-247531.md
prs:
  - repo: endojs/endo-but-for-bots
    pr: 334
    role: source
  - repo: endojs/endo
    pr: 2887
    role: target
---

Re-ferry `endojs/endo-but-for-bots#334` over `endojs/endo#2887`. **Recompute-from-master force-push-with-lease**. Source has 2 commits (one reshape of the original + one new docs commit); upstream has the original single commit. The reshape dropped a now-moot `src/node-modules.js` hunk per the source PR's body.

## Source

- Repo: `endojs/endo-but-for-bots`, PR #334 (OPEN, non-draft, MERGEABLE, no reviews).
- Branch: `mirror/2887-naming-module-location-specifier`
- Head: `30c43c645a9ed5295e62063579dc7082a6222ea6`
- 2 commits:
  1. `c37c8013 fix(compartment-mapper): Correct moduleSpecifier/moduleLocation naming mistakes` — `Kris Kowal <kris@agoric.com>` (2025-07-11; same date/content as the original upstream commit, with one hunk dropped). **Rewrite author/committer to `Kris Kowal <kriskowal@kriskowal.com>`** (current boatman default).
  2. `30c43c64 docs(compartment-mapper): consistent node: import prefix in README` — `endolinbot <main.barn5084@fastmail.com>` (2026-05-21). **Rewrite author/committer to `Kris Kowal <kriskowal@kriskowal.com>`**.

The source body explicitly notes the dropped hunk: "The original patch's only `src/node-modules.js` hunk (a blank-line insertion between `updateShortestPaths` and `findPackage`) is moot on this base: `updateShortestPaths` was refactored out of `node-modules.js` long before #2887 opened, and the surrounding adjacency that motivated the hunk no longer exists."

## Upstream

- Repo: `endojs/endo`, PR #2887 ("fix(compartment-mapper): Correct moduleSpecifier/moduleLocation namin…").
- Branch: `kriskowal-naming-module-location-specifier`
- Current head: `09874b70932001981ba938f6fdd996c33cf57f48`. Single commit `09874b70 fix(compartment-mapper): Correct moduleSpecifier/moduleLocation naming mistakes` by `Kris Kowal <kris@agoric.com>` (2025-07-11). Includes the moot `src/node-modules.js` blank-line hunk that the bot reshape drops.
- State: OPEN, non-draft, **APPROVED**, mergeable: UNKNOWN.
- Title (leave untouched): unchanged from above.

## Human

`Kris Kowal <kriskowal@kriskowal.com>` (current default). **identity_switch_authorized: true**.

## Dispatch root

`/Users/kris/garden/dispatches/boatman--ferry-moduleloc-naming-334--20260521-120850--d1aa19/`. Project worktree on `endojs/endo:kriskowal-naming-module-location-specifier` (detached at `09874b70`).

## Boatman direction

- Detach at `origin/master` (`bf951df346cfcf605a6709e6a5479f2fdd526113`), NOT at the current upstream tip.
- Set local `user.name='Kris Kowal'` / `user.email='kriskowal@kriskowal.com'`.
- Cherry-pick the 2 source commits (`c37c8013` then `30c43c64`) onto `origin/master`. Preserve as 2 commits (one substance + one docs follow-up).
- After each cherry-pick, `git commit --amend --reset-author --no-edit` to set author + committer to `Kris Kowal <kriskowal@kriskowal.com>` (rewriting both commits — commit 1 was `kris@agoric.com`, commit 2 was `endolinbot`).
- **Trailer-strip discipline**: `git interpret-trailers --parse` per commit. Always.
- **Tree-identity check (path-restricted)**: per the lesson surfaced in `entries/2026/05/21/063214Z-result-liaison-247531.md` and parallel-batch siblings, use `git diff 30c43c64 HEAD -- <touched-paths>` where the paths come from `git diff origin/master..HEAD --name-only`. The unrestricted form is misleading because source and upstream live in separate repos with divergent baselines.
- **Verify attribution**: `git log origin/master..HEAD --pretty=fuller` shows 2 commits, all author + committer `Kris Kowal <kriskowal@kriskowal.com>`.
- **Pre-flight ancestor/lease check**: refetch `origin/kriskowal-naming-module-location-specifier`; verify still at `09874b70`.
- **Force-push with lease**: `git push origin HEAD:kriskowal-naming-module-location-specifier --force-with-lease=kriskowal-naming-module-location-specifier:09874b70932001981ba938f6fdd996c33cf57f48`.
- **Title and body untouched** (user did not ask).
- **Approval-persistence verification**: `gh pr view 2887 -R endojs/endo --json reviewDecision,reviews` after push. The branch is unprotected; APPROVED should persist.
- Source-side cross-link comment on `endojs/endo-but-for-bots#334`: post under kriskowal. Name the new upstream head SHA, the 2-commit shape, and the hunk-drop rationale (so reviewers see why the upstream diff narrowed).
- **Identity discipline on `endojs/endo#2887`**: NO direct comments.

## Out of scope

- Title/body edits on #2887.
- Comments on the upstream PR.
- Any source-side changes.

## Expected report

≤300 words:
- Upstream head SHA after force-push + 2 new commit SHAs.
- Attribution verified.
- Path-restricted tree-identity check result.
- Pre-flight ancestor/lease check result.
- Push mode (force-with-lease).
- Approval-persistence (boneskull / whoever) check.
- Source-side cross-link URL.
- One-line `Self-improvement: ...`.

If blocked, `message`-to-liaison and stop.
