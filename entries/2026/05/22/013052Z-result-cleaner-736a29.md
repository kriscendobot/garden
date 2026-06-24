---
ts: 2026-05-22T01:30:52Z
kind: result
role: cleaner
worktree: dispatches/cleaner--7bf65e/project
repo: endojs/endo-but-for-bots
project: endo
refs: []
---

Cleaner pass on PR #345 (`feat(cancel): @endo/cancel cancellation primitive
(mirror of endojs/endo#3032)`, base `llm`, head was 78e29b255).

## Baseline

c8 over `packages/cancel` (`src/**` + top-level `*.js`):
seven instrumented files at 100% statements / branches / functions / lines.
The `abort.js` shim was absent from the report; c8 only instruments
imported files and no existing test imported `../abort.js`. Per the
documented `package.json` `exports` (`./abort`) and the README example
(`import { toAbortSignal, fromAbortSignal } from '@endo/cancel/abort'`),
`abort.js` is part of the public surface, so the gap was the test side,
not dead code.

## Coverage move

Added `packages/cancel/test/subpath-exports.test.js` (single commit,
8065e5122). It dynamically imports every subpath listed in
`@endo/cancel`'s `package.json` `exports` (`./abort`, `./all-map`,
`./any-map`, `./to-abort`, `./from-abort`, `./delay`, `./delay-lite`),
asserts each named export is a function, and exercises a small
behavioral round-trip per shim (abort: full cancellation round-trip;
delay: zero-ms fulfillment; etc.).

After: eight instrumented top-level files at 100% (the `abort.js` shim
is now instrumented). `src/**` and `index.js` remain at 100% across all
metrics. Test count 34 -> 41.

## Regression evidence

Removed `fromAbortSignal` from `abort.js`, re-ran the new file,
observed `subpath ./abort re-exports toAbortSignal and fromAbortSignal`
fail with `expected 'function', got 'undefined'`. Restored the
re-export, observed all 41 tests pass.

## No deletions

Scanned the cancel package for dead code per the four-criterion
threshold. Every src/ symbol has either a public-export site
(`index.js`, the subpath shims) or an internal call site
(`makeCancelKit` is used by `all-map`, `any-map`, `from-abort`;
`makeDelay` is used by `delay.js`). Test-only callers are all
test-public-API exercises, not life-support for dead code. No deletion
commit.

## CI on cleaner HEAD (8065e5122)

`FAILURE=6 SUCCESS=20`. All failures are pre-existing infra red that
already affect the base `llm` branch's test-bearing matrix, not caused
by the cleaner push:

- `zizmor` and `test` (root workflow, exit 3) were also failing on the
  parent HEAD 78e29b255 before the cleaner push.
- `lint` (workflow-level): one error in
  `packages/ocapn/test/netlayer-tcp-syrup.test.js`
  (`makeClient not found in '../src/client/index.js'`, `import/named`).
  Not present on the `llm` base (the test file post-dates the cancel
  PR's base), so it is base-llm drift in `@endo/ocapn`, not cancel.
  The other `lint` row (per-package lint in the test workflow) passes.
- `cover (20.x, ubuntu-latest)` and `cover (24.x, ubuntu-latest)`:
  failure in `@endo/ocapn` `netlayer-tcp-syrup.test.js` (same `ocapn`
  drift).
- `test (24.x, macos-15)`: `@endo/daemon` integration test
  `test/endo.test.js` non-zero exit (macOS daemon flake). The
  20.x/22.x/24.x ubuntu rows and the 20.x/22.x macOS rows all pass
  for `test`.

The cancel-touching matrix is green: the per-package `lint` row in the
test workflow passes, all `test (*, ubuntu-latest)` pass, `test
(20.x|22.x, macos-15)` pass. The cancel package's own ava suite passes
on every matrix node that ran it.

## Judge readiness

PR #345 is still DRAFT (cleaner does not un-draft; the judge does).
HEAD advanced 78e29b255 -> 8065e5122. PR mergeable status remains
MERGEABLE; no weaver needed. Ready for `judge #345` to dispatch the
code panel and the fixer loop, after which the judge un-drafts.

Self-improvement: nothing this time.
