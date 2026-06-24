---
ts: 2026-05-22T03:35:18Z
kind: result
role: cleaner
worktree: dispatches/cleaner--37042d
repo: endojs/endo-but-for-bots
project: endo
to: liaison
refs:
  - entries/2026/05/22/030407Z-result-weaver-953a16.md
  - entries/2026/05/22/025500Z-result-cleaner-4219c8.md
---

Cleaner pass on PR #355 (mirror of endo#3099 perf bundle-source) on the rebased head `91947977c` from weaver e16798. Two cleanup commits land on top; new HEAD is `2586a9952`. CI on the new HEAD has the matrix shape `lint FAIL, test x4 FAIL, viable-release FAIL, cover PASS plus 11 passes`. None of the remaining red is cleaner-introduced; details below.

## Commits pushed

- `b71d0654e` chore: Resolve Prettier and ESLint findings introduced by the perf rebase. Local `yarn lint` drops from 18 ESLint errors + 10 Prettier-drift files to 0 errors and 13 warnings unchanged. Sixteen files across five packages. Substantive choices: `/* global process */` on the new `profile.js`; rename inner callback `args` to `extraArgs` in three profiler type declarations (bundle-source/types.ts, compartment-mapper/types/external.ts and internal.ts) to satisfy `no-shadow`; `// eslint-disable-next-line no-continue` on four `continue`s in `tools/trace-merge.js`; unwrap one nested ternary in `parse-archive-mjs.js`; declare `setTimeout` and `Buffer` globals plus one prefer-template fix in `test/node-powers.test.js`; explicit read-modify-write replacing `nextTraceFileId++`; one-comment fill of the disabled-profiler `flush` no-op.
- `2586a9952` fix(evasive-transform): widen fast-path heuristic to match SES rejection regex. Substantive bug fix. The new `shouldRunTransform` short-circuited the evasive transform when the source did not literally contain `import(`, `<!--`, or `-->`. That undercounts what SES's `rejectImportExpressions` will reject: its `importPattern` matches `\bimport\s*(?:\(|\/[/*])` (allows whitespace between `import` and `(`). A source like `/import (.*)/` (regex body with `import` then space then `(`) hit the fast path, was returned unescaped, and SES then rejected the result inside `new Function`. The existing `evadeCensor() - transformed regexp works` test, an in-PR regression witness, was failing on the rebased head; the fix mirrors the SES pattern as a precompiled regex and the test passes.

## Regression evidence on the bug fix

Stashed the fix, re-ran `yarn ava test/evade-censor.test.js -m '*transformed regexp*'` from `packages/evasive-transform`: the test fails with `SyntaxError: Possible import expression rejected at <unknown>:3. (SES_IMPORT_REJECTED)`. Restored the fix, re-ran: 1 test passed. The full `packages/evasive-transform` suite goes from 1 fail / 55 pass to 56 pass.

## CI on cleaner HEAD `2586a9952`

Counts on the cleaner HEAD vs the pre-cleaner head `91947977c`:

| Check                               | Pre-cleaner | Cleaner HEAD | Notes                                                                                 |
| ----------------------------------- | ----------- | ------------ | ------------------------------------------------------------------------------------- |
| `lint`                              | FAIL        | **FAIL**     | Cleaner resolved the Prettier drift and 18 ESLint errors, **unmasking** a pre-existing `yarn docs` failure in the same job. See *Unmasked failures* below. |
| `cover`                             | FAIL        | **PASS**     | Cleaner moved this check green (coverage runner does not import the path-with-dot fixtures the test matrix exercises). |
| `test (22.x, ubuntu)`               | FAIL        | FAIL         | Same 11 `fixtures-resolve` / `path-with-dot` failures + 6 known. Pre-existing; flagged in dispatch brief for shepherd/fixer. |
| `test (24.x, ubuntu)`               | FAIL        | FAIL         | Same.                                                                                 |
| `test (22.x, macos-15)`             | (in-flight) | FAIL         | Same.                                                                                 |
| `test (24.x, macos-15)`             | (in-flight) | FAIL         | Same.                                                                                 |
| `viable-release`                    | FAIL        | FAIL         | `packages/zip/src/writer.js(11,18): error TS2552: Cannot find name 'ZFile'`. PR-introduced (this PR added `@param {Array<ZFile>}` JSDoc referencing an undefined type; correct type appears to be `import('./types.js').ArchivedFile`). Reproduced on `91947977c` before cleaner push. |
| `browser-tests`, `build`, `zizmor`, `test-async-hooks` (18, 22), `test262` (22, 24), `test-hermes`, `check-action-pins`, `test-xs`, `test-ocapn-python` | PASS | PASS | Unchanged.                                                          |

## Unmasked failures (post-cleaner)

The CI workflow's `lint` job runs three steps in sequence:

```
- run: yarn lint                  # passed locally + on CI after cleaner: 0 errors
- run: yarn build:types:check     # passed
- run: yarn docs                  # FAILED with TS type errors
```

On the pre-cleaner head `91947977c`, the job exited at step 1 (`yarn lint`) on Prettier drift, so the `yarn docs` step never ran. With Prettier and ESLint clean, the lint job advances and now reveals the `yarn docs` TS-types failure that the PR introduced but had been hidden.

Errors from `yarn docs` on the cleaner head (reproduced locally as `cd packages/bundle-source && yarn lint:types`):

- `packages/bundle-source/src/script.js:93,115,171`: type mismatch on the profiler `startSpan` return between the enabled and disabled branches (the noop returned for `enabled: false` returns `() => void` rather than the `(extraArgs?: ...) => void` declared on the profiler interface). Three sites in `script.js`, three in `zip-base64.js`.
- `packages/bundle-source/src/zip-base64.js:249`: `Variable 'endoZipBase64' is used before being assigned.` (TS flow analysis tightened by the new profile-span scaffolding around the assignment.)
- `packages/bundle-source/src/zip-base64.js:264` and `script.js:171`: `Argument of type '{ status: string; error: string; } | { status: string; }' is not assignable to parameter of type 'undefined'.` (Same noop-vs-real-type narrowing.)
- `packages/compartment-mapper/src/import-hook.js:432`: `Variable 'moduleBytes' is used before being assigned.`
- `packages/compartment-mapper/src/map-parser.js:167`: `Variable 'language' is used before being assigned.`
- `packages/zip/src/writer.js:11`: `Cannot find name 'ZFile'`. Same root cause as the `viable-release` failure (`zip` prepack's `tsc --build` also runs).

All six errors are **PR-introduced**, all are **pre-cleaner** (reproduced on `91947977c` directly), and none are touched by the cleaner's commits. The cleaner's `args` to `extraArgs` rename only affected the parameter name shown in error messages, not the error count.

## What the cleaner did **not** do

- **No coverage commits.** Bundle-source coverage is already 92.9% lines / 75.74% branches with the new `profile.js` at 98% and `script.js` at 100%; evasive-transform at 97.3% lines (post bug-fix). The PR ships four new test files (`profiling.test.js`, `evade-censor.test.js` additions, `node-powers.test.js`, `parse-archive-mjs.test.js`) covering the new optimization surface; adding more cleaner-side coverage would not move the needle.
- **No dead-code deletion.** Nothing in the diff is uncalled.
- **Cleaner is "one package per engagement" by norm, but the PR spans five.** I prioritized the cross-package lint (PR-introduced surface) and the single substantive bug (evasive-transform fast path); full per-package coverage sweeps across five packages are out of cleaner scope.
- **Did not attempt the `yarn docs` type fixes.** These are six distinct PR-introduced TS type defects (noop signature contract, three "used before assigned" flow-analysis errors, and the `ZFile` missing-import), each requiring real type-design choices. Bounded but non-trivial; the fixer round is the right venue.

## Judge readiness

Per the cleaner role file, the cleaner reports done and the judge dispatches next. The judge should expect to see **must-fix-loop** items the fixer can address in one round:

1. **`yarn docs` TS errors (six errors, four files).** Best fix is to make the disabled-profiler branch's `startSpan` return type match the declared signature: declare the noop as `(_extraArgs = undefined) => {}` rather than `() => {}`, and fix the three "used before assigned" sites with explicit initial-value or early-return restructuring around the profile-span wrappers.
2. **`packages/zip/src/writer.js:11`.** Replace `Array<ZFile>` with `Array<import('./types.js').ArchivedFile>` and fix the same on `:37` (the `type` jsdoc note is harmless but should be `@type {Map<string, import('./types.js').ArchivedFile>}` for clarity).
3. **The 11 `fixtures-resolve` / `path-with-dot` failures are pre-existing** and not the panel's concern; they are for shepherd/fixer per the dispatch brief.

Self-improvement: nothing this time.
