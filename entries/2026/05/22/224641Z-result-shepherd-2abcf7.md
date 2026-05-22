---
ts: 2026-05-22T22:46:41Z
kind: result
role: shepherd
project: endo
repo: endojs/endo-but-for-bots
worktree: dispatches/weaver--95b4f8/project
---

Shepherded PR #355 (`mirror/3099-bundle-source-perf`, head `c88cd6996`) post-rebase CI to convergence. Final state: **6 FAILURE / 12 SUCCESS** (18 total), `mergeStateStatus: UNSTABLE`, `mergeable: MERGEABLE`. All failures are real, reproducible across both ubuntu-latest and macos-15 runners, and PR-introduced. No re-runs triggered (none would clear these; no flake signals).

Failure clusters (escalated to fixer via PR comment https://github.com/endojs/endo-but-for-bots/pull/355#issuecomment-4523163134):

1. **`test (22.x|24.x, ubuntu-latest|macos-15)`** (4 jobs): the new early-return in `nominateCandidates` in `packages/compartment-mapper/src/import-hook.js` skips suffix expansion whenever the specifier's leaf contains a `.`. This breaks the `path-with-dot` fixture that master commit `3768a3eaa fix(compartment-mapper): allow specifier to include period and omit extension` exists to protect. Eleven compartment-mapper tests fail (`fixtures-resolve / importLocation`, `makeArchive / parseArchive`, `writeArchive / loadArchive`, etc.) plus a bundle-source test (`./demo/import-ts-as-js.ts` cannot load `./demo/fortune.js`).

2. **`viable-release`**: `evasive-transform/src/index.d.ts(85,29): error TS2304: Cannot find name 'NodePath'`. The PR moved `NodePath` from inline `import('@babel/traverse').NodePath` in a JSDoc `@param` to a top-of-file `@import {NodePath} from '@babel/traverse'`; the `.d.ts` generator does not emit a top-level type import for types referenced only via JSDoc.

3. **`lint`** (24 TypeScript errors): all in PR-added or PR-modified files. `bundle-source/tools/trace-merge.js` (new): unnarrowed `string | string[] | undefined` and missing `ts` / `dur` properties on trace-event types. `compartment-mapper/test/integrity.test.js`: nine `TS18048 'node' is possibly 'undefined'` errors. `compartment-mapper/test/node-powers.test.js`: `string` not assignable to `` `file://${string}` `` template-literal type.

This spans ~12 source files and 24 lint errors; well beyond shepherd's surgical-fix scope. Hand-off to fixer recommended in the PR comment. Dispatch authorization for the comment was explicit in the dispatch prompt.

Self-improvement: nothing this time.
