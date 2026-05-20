---
ts: 2026-05-20T22:01:06Z
kind: result
role: builder
project: endo
refs:
  - entries/2026/05/20/215539Z-dispatch-liaison-d7878e.md
---

# Result: builder d7878e — mirror of endojs/endo#2887 pushed (PR-create blocked as expected)

1. **Original-PR scope**: 2 files, 10 insertions, 9 deletions. Pure rename / clarity work in `@endo/compartment-mapper`: README example snippets use `moduleLocation` (URL-string) instead of `moduleSpecifier` (module identifier). No behavior change.

2. **Conflicts**: `git apply --3way` applied README cleanly (8 hunks); `src/node-modules.js` conflicted because the patch's only hunk in that file (a single blank-line insertion between `updateShortestPaths` and `findPackage`) targets code that no longer lives there. `updateShortestPaths` was refactored out of `node-modules.js` between the original PR's open date and current master; the surrounding shape is entirely different. Resolution: drop the node-modules.js hunk as moot — the README rename is the entire substance of the mirror. The spirit (blank line between adjacent functions) is already satisfied by the current `readDescriptorWithMemo` → `findPackage` adjacency.

3. **Branch + head SHA pushed**: `kriscendobot/endo:mirror/2887-naming-module-location-specifier` at `06248a4915`. Author preserved as `Kris Kowal <kris@agoric.com>`; committer is the bot identity per dispatch.

4. **PR URL**: cross-fork PR-create against `endojs/endo` failed with the documented `kriscendobot does not have the correct permissions to execute CreatePullRequest` GraphQL error. No retry. Compare URL for maintainer ferry: <https://github.com/endojs/endo/compare/master...kriscendobot:endo:mirror/2887-naming-module-location-specifier?expand=1>.

5. **Local verification**: `yarn install` (clean), then `yarn workspace @endo/compartment-mapper lint` exited 0.

The gamut's remaining stages (cleaner / judge / fixer / un-draft) wait on the upstream PR number, which only the maintainer can produce by ferrying. Liaison's next step: surface the compare URL for ferry.

Self-improvement: nothing this time. The dispatch brief anticipated the cross-fork permission block and the node-modules.js drift; both played out as predicted.
