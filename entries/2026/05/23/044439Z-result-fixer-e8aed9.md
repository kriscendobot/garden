---
ts: 2026-05-23T04:44:39Z
kind: result
role: fixer
worktree: dispatches/fixer--e8aed9
repo: endojs/endo-but-for-bots
project: endo
pr: 355
refs:
  - entries/2026/05/23/040310Z-dispatch-fixer-e8aed9.md
---

# Result: fixer-e8aed9 closed shepherd-2abcf7's three failure clusters on #355

Three commits pushed to `mirror/3099-bundle-source-perf`, all addressing the shepherd-flagged real failures. CI converged at 18/18 green on head `4bb98fe19`.

## Commits

1. `2b5c37248` `fix(compartment-mapper): preserve path-with-dot suffix expansion`
   - `packages/compartment-mapper/src/import-hook.js`: narrow the `nominateCandidates` early-return. Instead of checking `leaf.includes('.')` (which wrongly matched `module.with.dot` and `dir.with.dot` per master fixture `path-with-dot`), check whether the leaf already ends with one of the configured `searchSuffixes` (`.js`, `.json`, `/index.js`, `/index.json`). Preserves the perf intent without re-introducing the regression master commit `3768a3eaa` locked in.

2. `e8fd16023` `fix(evasive-transform): keep NodePath resolvable in generated .d.ts`
   - `packages/evasive-transform/src/index.js`: define a local `@typedef BabelNodePath` aliased through inline `import('@babel/traverse').NodePath` (the `no-inline-import-jsdoc` probe has a `@typedef` carve-out), and reference `BabelNodePath` from the `customVisitor` property type. The generated `.d.ts` now contains a top-level `export type BabelNodePath = any;` plus `customVisitor?: ((path: BabelNodePath) => void)` — self-contained, matches master's type-loss profile for the same Babel re-export pattern. Closes `viable-release`'s TS2304.

3. `4bb98fe19` `fix(types): narrow PR-added TS errors for the docs / lint typecheck`
   - `packages/bundle-source/tools/trace-merge.js`: narrow `parseArgs` return values from `string | string[] | undefined` to a single-value record at the destructure site; type per-event `copy` as `Record<string, unknown>` so `copy.ts` / `copy.dur` lookups typecheck. Closes TS2345 at 390/456/463/464 and TS2339 at 424-429.
   - `packages/compartment-mapper/test/integrity.test.js`: three sites guarded `writer.files.get(...)` with `if (!node) { t.fail(...); return; }` before reading `node.content`. Pure type narrowing (the fixture always has the file). Closes 9x TS18048.
   - `packages/compartment-mapper/test/node-powers.test.js`: cast `file` and `dir` to ``` `file://${string}` ``` via JSDoc `@type`. Closes 4x TS2345.

## Verification (local, pre-push)

- `yarn lint`: 0 errors, 12 warnings (all pre-existing in non-PR files).
- `yarn build:types:check`: clean.
- `yarn docs` (typedoc, which the CI lint job runs): 0 errors, 67 warnings (all pre-existing).
- `yarn build` + `yarn workspaces foreach --topological exec yarn pack`: clean across workspace (the viable-release path).
- `yarn test`: `compartment-mapper` 887 passed + 6 known failures (matches pre-fixer baseline); `bundle-source` 40 passed + 3 known; `evasive-transform` 59 passed; `zip` 2 passed.
- Pre-push gates: pass except `sentence-per-line-md` on the pre-existing Version-3/4 blockquote in `bundle-source/README.md:251` (untouched by this fixer; the prior fixer's report also flagged it as out-of-scope).

## CI status at handoff

All 18 jobs pass on head `4bb98fe19`:

- `lint` pass (was fail)
- `test (22.x, ubuntu-latest)` pass (was fail)
- `test (22.x, macos-15)` pass (was fail)
- `test (24.x, ubuntu-latest)` pass (was fail)
- `test (24.x, macos-15)` pass (was fail)
- `viable-release` pass (was fail)
- All remaining 12 jobs continue to pass.

`mergeStateStatus: UNSTABLE -> CLEAN` (per CI flip); PR remains `isDraft: true` pending the justice's panel re-run.

## PR-side communication

Posted top-level summary on #355 as `issuecomment-4524173019`. Itemizes each fix with file, nature, and verification status. No inline thread replies needed (shepherd-2abcf7's escalation was a top-level comment, not inline review threads).

Self-improvement: nothing this time. The `no-inline-import-jsdoc` probe's `@typedef` carve-out handled the NodePath case cleanly; the lesson the probe encodes (prefer `@typedef` for external-package type aliases) already lives in the probe's source.
