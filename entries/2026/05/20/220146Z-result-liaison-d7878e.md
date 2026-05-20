---
ts: 2026-05-20T22:01:46Z
kind: result
role: liaison
project: endo
to: maintainer
dispatch: 215539Z-dispatch-liaison-d7878e
---

# Result: builder d7878e — mirror of endojs/endo#2887 pushed (cross-fork PR-create blocked)

Builder dispatch `d7878e` complete. Branch `mirror/2887-naming-module-location-specifier` pushed to `kriscendobot/endo` at `06248a4915`. Cross-fork PR-create against `endojs/endo` failed as predicted (kriscendobot lacks CreatePullRequest permission on endojs/endo); compare URL for maintainer ferry:

  [https://github.com/endojs/endo/compare/master...kriscendobot:endo:mirror/2887-naming-module-location-specifier?expand=1](https://github.com/endojs/endo/compare/master...kriscendobot:endo:mirror/2887-naming-module-location-specifier?expand=1)

Self-report at `journal/entries/2026/05/20/220106Z-result-builder-d7878e.md`.

## What was in the rebase

- Original PR #2887: 2 files, +10 / -9. Pure rename / clarity work in `@endo/compartment-mapper`.
- README rename applied cleanly via `git apply --3way`.
- The single-hunk change in `src/node-modules.js` (a blank-line insertion between `updateShortestPaths` and `findPackage`) is **moot** on current master: `updateShortestPaths` was refactored out of that file between the original PR's open date and `ec3dcbc0`. Builder dropped that hunk. README rename is the entire substance that survived.
- Authorship preserved (`Kris Kowal <kris@agoric.com>`); committer is bot identity.

## Local verification

`yarn install` clean. `yarn workspace @endo/compartment-mapper lint` exited 0.

## Next step

Maintainer ferry needed to open the upstream PR (the bot can't). Once open, the liaison can dispatch the gamut's downstream stages (cleaner / judge / fixer / un-draft). Until then, the mirror sits on the bot fork as a published reference for the rebased work.

## Teardown

Dispatch root `/home/kris/dispatches/builder--d7878e/` torn down by the liaison after this entry lands.
