---
ts: 2026-05-21T06:07:52Z
kind: result
role: builder
project: endo-but-for-bots
refs:
  - entries/2026/05/21/060324Z-dispatch-liaison-d7d813.md
  - entries/2026/05/20/220106Z-result-builder-d7878e.md
---

# Result: builder d7d813 — mirror endojs/endo#2887 onto endo-but-for-bots@master, draft PR #334 opened

## 1. Conflict count + dropped-hunk audit

`git apply --3way /tmp/2887-ebfb.patch` produced one conflict.

- `packages/compartment-mapper/README.md`: applied cleanly (all 6 hunks, 9 insertions / 9 deletions).
- `packages/compartment-mapper/src/node-modules.js`: conflicted. The patch's sole hunk inserts a blank line between `updateShortestPaths` and `findPackage`, but `updateShortestPaths` was refactored out of `node-modules.js` before this base, so the targeted adjacency no longer exists. Same disposition as the prior kriscendobot mirror (d7878e): the hunk is moot; dropped via `git checkout HEAD -- packages/compartment-mapper/src/node-modules.js`. README rename is the entire substance.

Net: 1 file changed, 9 insertions(+), 9 deletions(-) staged.

## 2. Branch + head SHA

- Branch: `mirror/2887-naming-module-location-specifier` on `endojs/endo-but-for-bots`.
- Head SHA: `c37c80134ce79f8894957b5605d6251694843fdd`.
- Author: `Kris Kowal <kris@agoric.com>` preserved (with the original 2025-07-11 author date). Committer: `endolinbot <main.barn5084@fastmail.com>` per dispatch pin.
- Commit subject: `fix(compartment-mapper): Correct moduleSpecifier/moduleLocation naming mistakes`.

## 3. PR URL

<https://github.com/endojs/endo-but-for-bots/pull/334> (draft, base `master`, head `mirror/2887-naming-module-location-specifier`).

## 4. yarn lint + yarn test

Both green for `@endo/compartment-mapper` on the rebased branch.

- `yarn workspace @endo/compartment-mapper lint`: exit 0.
- `yarn workspace @endo/compartment-mapper test`: 879 passed, 6 known failures (pre-existing), exit 0.

## 5. Self-improvement

Self-improvement: nothing this time. The dispatch brief named the dropped hunk and the rebase base precisely; the redo on the bot-pushable fork went straight through.
