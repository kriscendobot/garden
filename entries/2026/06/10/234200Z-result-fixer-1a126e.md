---
ts: 2026-06-10T23:42:00Z
kind: result
role: fixer
project: endo
repo: endojs/endo-but-for-bots
worktree: dispatches/fixer--1a126e/project
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/379
  - https://github.com/endojs/endo-but-for-bots/pull/379#issuecomment-4675471286
  - https://github.com/endojs/endo-but-for-bots/pull/379#issuecomment-4675746604
  - https://github.com/kriskowal/garden/blob/journal/entries/2026/06/10/232800Z-dispatch-fixer-1a126e.md
  - https://github.com/kriskowal/garden/blob/journal/entries/2026/06/10/232410Z-result-fixer-a8a6ac.md
---

Fixer dispatch 1a126e addressed kriskowal's follow-up directive (issue comment 4675471286, 2026-06-10T22:58:19Z): consider whether SES module-instance notifiers can be created at construction time instead of link time (responding to naugtur's design ask at endojs/endo#3276 discussion r3323524839), and add a test demonstrating the cyclic-export failure mode with a named reexport instead of a star reexport.

## What landed

Two append commits on branch `fix/issue-59-star-export-cycle`:

- `c817b9fe6`: `docs(ses): document construction-time-notifiers consideration (issue #59 follow-up)`. Adds `packages/ses/designs/construction-time-notifiers.md` (420 lines). Standalone analysis of the construction-time-notifiers redesign with recommendation to land as a follow-up PR.
- `0c46da953`: `test(ses): named-reexport variant of cyclic-export failure mode (issue #59 follow-up)`. Adds one test to `packages/ses/test/import-gauntlet.test.js` (55 lines). Marked `test.failing` per the prior fixer's discipline; pins Node.js parity as desired outcome.

Pre-dispatch tip `30664c3c2`; post-dispatch tip `0c46da953`.

## Phase 1 outcome: construction-time-notifiers redesign

**Disposition**: feasible-and-documented, **deferred** to follow-up PR.

The analysis is durable code-tree documentation rather than a PR-body fold. The 420-line design document covers:

- Present four-phase lifecycle (load, instantiate, construct, link). The line between instantiate and link is "almost, but not quite" hard enough; `makeModuleInstance` returns an instance with notifiers/exportsProxy/execute but the wiring of reexport notifiers is a side effect of execute (the `imports(updateRecord)` closure).
- What is and is not available at construction time. Own bindings' shape (fixed and live) is known from `__fixedExportMap__` and `__liveExportMap__`. Renamed-reexport names are known from `__reexportMap__`. Star reexport names require walking the upstream's `moduleSource.exports`, also known at construction time but a graph traversal.
- Two-pass redesign sketch. Pass 1 (construct + name-claim) inside `instantiate` allocates own-binding state AND creates forwarder stubs for every reexport notifier; pass 2 (wire) resolves stubs against upstream notifiers (every instance is constructed by then so every own notifier exists). `wireUpExportNotifier`'s deferred-resolver branch becomes dead code.
- Precompiled ModuleSource calling convention. No schema change required. `imports(updateRecord)` becomes wire-only (registers the functor's updaters on upstream notifiers it already located in pass 1); the functor's call shape is unchanged.
- TDZ-gap relationship. The redesign does NOT by itself close the SES-against-Node cross-module TDZ divergence the matrix pins. The exported-getter's contract (return last propagated value; default `undefined`) is unchanged. Closing that gap requires a separate change to consult the upstream's own-binding getter, which the redesign enables but does not require.
- naugtur's shared-primitive arm. The document sketches `makeBindingNotifier` (own-binding shape) and confirms `makeNotifierWithResolver` covers the forwarder shape. Both `makeModuleInstance` and `makeVirtualModuleInstance` would consume the same primitives in the redesign.

Recommendation: land the redesign as a follow-up PR rather than fold the refactor into the regression-fix PR. Touches two large surfaces, shifts the instantiate/link line, benefits from being reviewed against the parity baseline this PR establishes.

## Phase 2 outcome: named-reexport variant test

**Failure mode reproduces in the named-reexport shape.** The new test (`cyclic named reexport with renaming reexport, renamer imported first, const binding observes ReferenceError during temporal dead zone`) mirrors the existing renamer-first + const star-reexport `.failing` cell but replaces `export * from './export-renamer.js'` with `export { y } from './export-renamer.js'` in the upstream module.

Node.js raises `ReferenceError` for `const y = 42` in this case; SES returns `undefined`. Identical SES-vs-Node divergence to the star case. Result confirms the gap lives with the binding form, not with the reexport form.

Verified out-of-band against Node native ESM across the same const/let/var matrix and both import orders (six cells); the named-reexport variant produces identical output to the star case for every cell.

## Test result

`corepack yarn workspace ses test`: 508 pass + 5 known failures + 2 skipped (was 508 + 4 + 2 pre-dispatch; the new named-reexport `.failing` adds one).

## Pre-push gate

`pre-push-gates --summary .` reports clean for the new diff after addressing two findings on first run:

- `no-pull-citations` initially flagged the design doc citing PR URLs. Reworded to reference the comments by source path (the inline at `module-instance.js:367`) rather than `github.com/.../pull/.../discussion_*` URLs. (The reply comment carries the PR URLs; only the in-tree design document needs them stripped.)
- `sentence-per-line-md` flagged multi-sentence lines in prose and numbered-list items. Reflowed to sentence-per-line throughout; numbered lists converted to bulleted lists where the awk probe's exception applies.

Two pre-existing probe failures inherited from master at base SHA `f1a7dfb60` (the prior fixer's documented baseline): `no-inline-import-jsdoc` on `packages/evasive-transform/src/index.js`, `security-md-hash-uniform` divergent SECURITY.md across `immutable-arraybuffer`, `bytes`, `hex`, `panic`. Not introduced by either commit.

Auto-fix stage touched `packages/evasive-transform/src/index.js` and `packages/ses/src/compartment.js` (same pattern the prior fixer noted); both reverted before commit so the diff stays scoped.

## PR-side actions

- Top-level reply posted at https://github.com/endojs/endo-but-for-bots/pull/379#issuecomment-4675746604. Cites both addressing commits, summarizes the construction-time-notifiers outcome (feasible-and-documented, deferred-to-follow-up), and confirms the named-reexport failure mode reproduces.
- Re-request review from kriskowal via `gh api repos/endojs/endo-but-for-bots/pulls/379/requested_reviewers --input -` (JSON-body shape). PR's `requested_reviewers` now lists kriskowal.

## Deliverable

PR #379 head `0c46da953` (was `30664c3c2`). Two commits added: `c817b9fe6` (design doc, 420 lines) + `0c46da953` (one `.failing` test, 55 lines). The named-reexport variant pins the same SES-against-Node TDZ divergence as the star variant; the design document analyzes the construction-time-notifiers redesign and recommends a follow-up PR for the refactor.

Self-improvement: the design document's `1. Foo` numbered-list items tripped the `sentence-per-line-md` probe because the awk pattern flags `[.!?]\s+[A-Z]` and only exempts `- ` / `* ` / `+ ` bullet starts (not the `N. ` numbered-item start). The probe is correct to flag the multi-sentence case but currently catches all numbered lists as a side effect. Worth a one-line addition to the probe's awk exception (`if ($0 ~ /^[[:space:]]*[0-9]+\.[[:space:]]/) next`) to align with the `-*+` exception. Routing as a `message` entry from a separate dispatch (not blocking this one).
