---
ts: 2026-06-10T23:24:10Z
kind: result
role: fixer
project: endo
repo: endojs/endo-but-for-bots
worktree: dispatches/fixer--a8a6ac/project
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/379
---

Fixer dispatch a8a6ac addressed kriskowal's CHANGES_REQUESTED review on PR #379 (2026-06-10T22:54:02Z): add tests that vary the cyclic star-export fixture by import order in `main.js` (renamer-first vs star-reexporter-first) and binding form (`const`, `let`, `var`), and attempt to observe the renamer's `y` during the linked-but-not-bound cycle window.

## What landed

Single test-only commit at 30664c3c2 on branch `fix/issue-59-star-export-cycle`, appended to `packages/ses/test/import-gauntlet.test.js`. The 6 new tests are placed adjacent to the existing two `cyclic star export with renaming reexport` cases. No source change.

## Test design

The star-reexporter holds the observation: `import * as r from './export-renamer.js'` plus a top-of-body `(() => { try { return { kind: 'value', value: r.y }; } catch (e) { return { kind: 'error', name: e.name }; } })()` captured as `export const probe`. main.js reads `s.probe` after the cycle resolves.

The renamer-first orderings put the star-reexporter's body on the call stack while the renamer is still evaluating, so the cross-module read of `r.y` lands while the renamer's binding has been linked but not yet initialized. The star-reexporter-first orderings invert the depth-first traversal so the renamer's body completes first.

## Matrix outcomes

| import order | binding | Node.js | SES | test status |
|---|---|---|---|---|
| renamer-first | `const` | ReferenceError (TDZ) | `undefined` | `test.failing` |
| renamer-first | `let` | ReferenceError (TDZ) | `undefined` | `test.failing` |
| renamer-first | `var` | `undefined` | `undefined` | passing |
| star-reexporter-first | `const` | `42` | `42` | passing |
| star-reexporter-first | `let` | `42` | `42` | passing |
| star-reexporter-first | `var` | `42` | `42` | passing |

Node.js outcomes verified out-of-band against a minimal native-ESM fixture.

## Divergence pinned

Two cells diverge: SES's current module-instance machinery does not enforce the temporal dead zone for cross-module reads through a namespace import during a cycle. `r.y` returns `undefined` rather than raising ReferenceError for `const` and `let` in the renamer-first orderings. The matrix pins the ECMA-262 Node.js reference behavior as the desired outcome via `test.failing`, surfacing the gap for the maintainer to either accept (note-and-close) or close (with a follow-up source change in `packages/ses/src/module-instance.js`). The four converging cells assert SES's current behavior directly because it already matches Node.js for those cells.

## Test titles

Each title spells the binding keyword and `ReferenceError` per the spec (`skills/test-title-spec-spelling/SKILL.md`). Format:

- `cyclic star export with renaming reexport, renamer imported first, const binding observes ReferenceError during temporal dead zone`
- `cyclic star export with renaming reexport, renamer imported first, let binding observes ReferenceError during temporal dead zone`
- `cyclic star export with renaming reexport, renamer imported first, var binding observes undefined while hoisted but unassigned`
- `cyclic star export with renaming reexport, star reexporter imported first, const binding observes the assigned value`
- `cyclic star export with renaming reexport, star reexporter imported first, let binding observes the assigned value`
- `cyclic star export with renaming reexport, star reexporter imported first, var binding observes the assigned value`

## Pre-push gate

`skills/pre-push-gates/pre-push-gates.sh --summary .` reports clean for the diff under review. Two probe failures (`no-inline-import-jsdoc` on `packages/evasive-transform/src/index.js`, `security-md-hash-uniform` divergent SECURITY.md across `immutable-arraybuffer`, `bytes`, `hex`, `panic`) exist on master at base SHA `f1a7dfb60` and are not introduced by this commit. Auto-fix stage touched two unrelated files (`packages/evasive-transform/src/index.js`, `packages/ses/src/compartment.js`); both were reverted before the commit so the diff stays test-only.

## CI

All 15 non-browser checks pass on 30664c3c2. `browser-tests` was still running playwright at the time of re-request. The prior commit `f1a7dfb60` had `browser-tests` cancelled and earned the CHANGES_REQUESTED review nonetheless, so this surface is not load-bearing for the maintainer's review decision. The test-only diff cannot affect browser-runtime behavior.

## PR-side actions

- Top-level summary posted at `https://github.com/endojs/endo-but-for-bots/pull/379#issuecomment-4675538798` (matrix table; SES-vs-Node divergence framed for a decide-now-or-defer call).
- Re-request review from kriskowal via `gh api repos/endojs/endo-but-for-bots/pulls/379/requested_reviewers --input -` (JSON-body shape). The PR's `requested_reviewers` now lists kriskowal.

## Deliverable

PR #379 head 30664c3c2; 6 new tests in `packages/ses/test/import-gauntlet.test.js`; 4 passing + 2 `test.failing` pinned to Node.js parity as the desired outcome.

Self-improvement: nothing this time. The `test.failing` discipline for SES-vs-Node cross-module-TDZ divergence is already in the project's idiom (line 375 of `import-gauntlet.test.js` uses the same shape); this commit applies that idiom to the new matrix.
