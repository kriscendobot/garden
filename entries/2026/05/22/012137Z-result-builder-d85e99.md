---
ts: 2026-05-22T01:21:37Z
kind: result
role: builder
repo: endojs/endo-but-for-bots
project: endo
refs:
  - entries/2026/05/22/010659Z-dispatch-liaison-d85e99.md
---

Opened DRAFT PR https://github.com/endojs/endo-but-for-bots/pull/346 at head SHA `6a72d10f04ab6dcb0f04a8262f9f6f604d27be8a` on branch `fix/bundle-source-aliased-exports-2981`.

## Root cause

The `nestedEvaluate` / `getExport` bundle generator's `importsCellSetter` (in `packages/compartment-mapper/src/bundle-mjs.js`) emitted one property per export name on the `onceVar` / `liveVar` calling-convention object literal, keyed by the local binding. When a single local binding was aliased to multiple export names (e.g. `details`, `X`, `redacted`), the duplicate keys collapsed to the last one under JavaScript object-literal semantics, and only one cell ever received its setter; the rest stayed `undefined`.

## Fix

`packages/compartment-mapper/src/bundle-mjs.js:20-58` (lines after edit): invert the export map to `Map<localName, exportName[]>`, emit one property per local binding, and use a fan-out function `value => { cells[i].A.set(value); cells[i].B.set(value); }` when the local maps to more than one export.

The companion regression test `packages/bundle-source/test/export-alias.test.js` is un-`.failing`'d in the same commit; it was committed as `test.failing` by endojs/endo#2980 specifically to track this bug. Its sibling `marshal-failure.test.js` is not `.failing` on master (the d3a081c2 `fix(errors): avoid export aliases` workaround in `@endo/errors` had silently neutralized the symptom by replacing aliased exports with `export const`s), but its underlying assertion still passes after the fix.

## Regression evidence

Under `packages/bundle-source/` with the un-`.failing`'d `export-alias.test.js`:

- With the fix reverted (via `git stash push -u packages/compartment-mapper/src/bundle-mjs.js`): `yarn test test/export-alias.test.js` exits non-zero, ava reports `[fail]: export alias`, the difference `actual: undefined, expected: 42` (the local-binding `numberValue` was aliased to four export names; only the last cell got a setter).
- With the fix restored (`git stash pop`): the same command exits zero, ava reports `1 test passed`.

Confirmation method: dumped the generated bundle for the `marshal-failure` demo before and after the fix and inspected the `onceVar` block. Before the fix it contained `details: cells[8].details.set, details: cells[8].X.set, details: cells[8].redacted.set,` (three duplicate keys); after the fix it contained one entry `details: value => { cells[8].details.set(value); cells[8].X.set(value); cells[8].redacted.set(value); },`.

## Per-command local test status

- `yarn test` in `packages/bundle-source`: 40 passed, 2 known failures (`let-export` mutable-binding issue, `endo-script-format` ts-as-js issue; both pre-existing and unrelated).
- `yarn test` in `packages/compartment-mapper`: 876 passed, 6 known failures (all pre-existing).
- `yarn lint` in `packages/compartment-mapper`: pass.
- The repo-wide `pre-push-gates.sh` reports two pre-existing failures (`no-inline-import-jsdoc` on `packages/evasive-transform/src/index.js`, `security-md-hash-uniform` on several packages); both are unrelated to this diff and the auto-fixer's drive-by reformats were unstaged before commit.

## Out of scope (per dispatch)

No upstream cross-post on `endojs/endo#2981`; PR stays DRAFT; no ferry.

Self-improvement: nothing this time.
