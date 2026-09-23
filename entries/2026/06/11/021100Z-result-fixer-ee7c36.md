---
ts: 2026-06-11T02:11:00Z
kind: result
role: fixer
project: endo
repo: endojs/endo-but-for-bots
worktree: dispatches/fixer--ee7c36/project
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/379
  - https://github.com/endojs/endo-but-for-bots/pull/379#pullrequestreview-4473004836
  - https://github.com/endojs/endo-but-for-bots/pull/379#issuecomment-4676551685
  - https://github.com/kriskowal/garden/blob/journal/entries/2026/06/11/014500Z-dispatch-fixer-ee7c36.md
  - https://github.com/kriskowal/garden/blob/journal/entries/2026/06/10/234200Z-result-fixer-1a126e.md
  - https://github.com/kriskowal/garden/blob/journal/entries/2026/06/10/232410Z-result-fixer-a8a6ac.md
---

Fixer dispatch ee7c36 addressed kriskowal's CHANGES_REQUESTED review (`4473004836`, 2026-06-11T01:43:29Z) on PR #379: fix the SES module-instance TDZ-enforcement defects pinned by the prior fixers' three `.failing` cells (2 star-reexport + 1 named-reexport), with separate commits per issue.

## What landed

Two append commits on branch `fix/issue-59-star-export-cycle`:

- `94c88465d`: `fix(ses): enforce TDZ for cross-module namespace reads during cycle (star reexport)`. Three source files plus the design doc plus star-reexport test conversions: `packages/ses/src/module-instance.js` (eager `defineProperty(exportsTarget, ...)` for own fixed and live exports + TDZ tracking and eager defineProperty in `wireUpExportNotifier`), `packages/module-source/src/transform-analyze.js` (preamble reorder: hoistedDecls before imports call), `packages/module-source/test/fixtures/format-preserved.txt` (updated expected output), `packages/ses/designs/construction-time-notifiers.md` (updated to reflect actual landed fix vs original redesign sketch), `packages/ses/test/import-gauntlet.test.js` (two `.failing` → `test` conversions for renamer-first × const and renamer-first × let star-reexport cells).
- `53d8662a7`: `fix(ses): enforce TDZ for cross-module named-reexport reads during cycle`. Test-only conversion of the named-reexport `.failing` cell to passing. The source fix in commit 1 already covered the named-reexport path because both star-reexport and `__reexportMap__`-driven named reexport flow through the same `wireUpExportNotifier`.

Pre-dispatch tip `0c46da953`; post-dispatch tip `53d8662a7`.

## Diagnosis: where the TDZ enforcement gap actually lived

The construction-time-notifiers design doc (written by fixer `1a126e`) identified the symptom as "the exported getter installed by `wireUpExportNotifier` simply returns the last value the upstream notifier propagated, which starts as `undefined`." That description was partly correct but missed the structural mechanism. The actual gap had two layers:

1. **The cross-module read goes through the raw `exportsTarget`, not the `exportsProxy`.** The `'*'` notifier propagates `exportsTarget` directly (line 354 of `module-instance.js`: `const notifyStar = update => { update(exportsTarget); }`). The downstream's namespace binding `r` is therefore the plain object created by `deferExports()`, not the active-checking proxy.
2. **`exportsTarget` had no property defined for the binding** until the late `arrayForEach(arraySort, defineProperty)` pass at the end of `imports()` (line 485-487). A missing property reads as `undefined` rather than throwing, so during the linked-but-not-yet-bound window (when the downstream module's body runs nested inside the upstream's `imports()` walk via `instance.execute()`), the cross-module read silently returned `undefined`.

For the `var` cell that previously passed (renamer-first × var → undefined), the existing SES code returned `undefined` *for the wrong reason*: the property was simply absent, not because the upstream's binding was hoisted-to-undefined. After my fix lands the property eagerly with a TDZ-aware getter, that getter would throw `ReferenceError` for `var` too unless the upstream's TDZ was actually cleared before the downstream observed. The fix to `transform-analyze.js` (reorder preamble: hoistedDecls before imports call) ensures the upstream's `var y` is `liveVar.y(undefined)`-initialized before any nested `instance.execute()` happens, so the var TDZ is cleared in time and the var cell continues to read `undefined` for the right reason.

## The three targeted source-side fixes

### packages/ses/src/module-instance.js

- For each own fixed export (in the `fixedExportMap` loop), `defineProperty(exportsTarget, fixedExportName, exportsProps[fixedExportName])` immediately after setting `exportsProps[fixedExportName]`. The descriptor uses the same TDZ-aware `fixedGetNotify.get`.
- For each own live export (in the `liveExportMap` loop), same pattern with `liveGetNotify.get`.
- In `wireUpExportNotifier`: track `tdz` locally; the exported getter throws `ReferenceError` until the upstream's notifier chain calls `update(newValue)` which sets `tdz = false`. Eagerly `defineProperty(exportsTarget, exportName, exportsProps[exportName])` after setting `exportsProps[exportName]`. This path serves both star reexports (called from the candidateAll walk) and named reexports (called from the `__reexportMap__` iteration).

The late `arrayForEach(arraySort(keys(exportsProps)), k => defineProperty(exportsTarget, k, exportsProps[k]))` pass at the end of `imports()` is left in place. Each call redefines the same accessor descriptor (same getter function, same flags), which is a no-op redefinition under ECMA-262 `ValidateAndApplyPropertyDescriptor` rules. Sorted enumeration order is preserved.

### packages/module-source/src/transform-analyze.js

Reorder the preamble so hoistedDecls runs before the `HIDDEN_IMPORTS([...])` call. This is one swap of two `preamble +=` blocks (about 12 lines moved). The reorder matches the ECMA-262 model: `Module.Link` calls `InitializeEnvironment`, which creates and initializes function and var bindings (function declarations to their function objects; var declarations to undefined) before `Module.Evaluate` walks dependencies. Without this reorder, upstream `var y` would still be in the SES live-binding TDZ when downstream's body runs nested inside the upstream's `imports()`.

### packages/module-source/test/fixtures/format-preserved.txt

The format-preserved test in module-source asserts the exact text output of the compiled preamble for a single fixture. The expected output now reflects the new order (`HIDDEN_ONCE.createBinop(...)` before `HIDDEN_IMPORTS([])` for that fixture, which has a function declaration). One-line text update.

## Test result

`corepack yarn workspace ses test`: 511 pass + 2 known failures + 2 skipped. Pre-dispatch baseline was 508 + 5 + 2; the 3 previously-`.failing` cells now pass (510 + 2 + 2; the 11th additional pass is the new `test()` form being recognized as a passing test rather than a known failure).

`corepack yarn workspace @endo/module-source test`: 53 tests passed (was 53 + 1 fail on `preserve-format` until the fixture update).

`corepack yarn workspace @endo/compartment-mapper test`: 930 tests passed + 6 known failures. No regressions.

`corepack yarn workspace @endo/bundle-source test`: 39 tests passed + 3 known failures. No regressions.

## Pre-push gate

`pre-push-gates --summary .` reports clean for the diff under review after addressing one finding on first run:

- `sentence-per-line-md` flagged numbered-list items in the design doc that joined two sentences per line. Reflowed to bulleted lists with sentence-per-line.

Two pre-existing probe failures inherited from master at base SHA `f1a7dfb60` (same as the prior fixer's documented baseline): `no-inline-import-jsdoc` on `packages/evasive-transform/src/index.js`, `security-md-hash-uniform` divergent SECURITY.md across `immutable-arraybuffer`, `bytes`, `hex`, `panic`. Not introduced by either commit.

Auto-fix stage touched `packages/evasive-transform/src/index.js` and `packages/ses/src/compartment.js` (the same pattern the prior fixers noted); both reverted before commit so the diff stays scoped.

## PR-side actions

- Top-level reply posted at https://github.com/endojs/endo-but-for-bots/pull/379#issuecomment-4676551685. Cites both addressing commits, summarizes the root cause and the three targeted fixes, confirms test status with no regressions.
- Re-request review from kriskowal via `gh api repos/endojs/endo-but-for-bots/pulls/379/requested_reviewers --input -` (JSON-body shape). PR's `requested_reviewers` now lists kriskowal.

## Deliverable

PR #379 head `53d8662a7` (was `0c46da953`). Two source-side commits added: `94c88465d` (the core TDZ enforcement fix for the star-reexport variant including source changes to `module-instance.js`, `transform-analyze.js`, `format-preserved.txt`, design doc update, and 2 test conversions) + `53d8662a7` (the named-reexport test conversion). All three previously-`.failing` cells now pass without the `.failing` modifier; no regressions in any tested package.

Self-improvement: the `wireUpExportNotifier`-as-source-of-truth framing in the prior fixer's design doc led me to spend significant effort understanding the notifier graph before realizing the actual problem was that `exportsTarget` had no property defined at the moment cross-module reads happened. Future investigations of "namespace returns undefined unexpectedly" findings would benefit from a probe step that simply observes whether `exportsTarget[name]` is defined at the moment of the failing read, separate from any reasoning about the getter's semantics. Worth a brief addition to a debugging checklist for the module-instance machinery; routing as a small note rather than a structural lesson because the gap is specific to this one machinery.
