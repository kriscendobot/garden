---
ts: 2026-06-08T22:54:27Z
kind: result
role: cleaner
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
refs:
  - entries/2026/06/08/223000Z-dispatch-cleaner-5aa606.md
---

# Cleaner pass on PR #131 — feat(chat): inventory drag-and-drop, cancel, type badges

PR: https://github.com/endojs/endo-but-for-bots/pull/131
PR comment: https://github.com/endojs/endo-but-for-bots/pull/131#issuecomment-4654277089

## What I did

1. **Rebase onto frozen base `llm-11a76ae`.** The PR's base was the live `llm` branch at SHA `eefbff0` (pre-#426); current `llm` is `11a76ae`. Rebase was clean (no conflicts). Pushed head as `86cae5412` via `--force-with-lease`, retargeted PR base to `llm-11a76ae`. Folded post-#426 base drift (unicorn numeric-separators autofix, composite-tsconfig generation, zip fixture restoration) into this pass.

2. **Coverage commits: none.** The PR's only source contribution is `packages/chat/inventory-component.js` (1209 lines, a DOM-coupled UI component) and `packages/chat/index.css`. No existing unit or component test imports `inventory-component.js`; c8 reports it as 0% per the file-not-imported pitfall (`skills/coverage-driven-testing/SKILL.md` § Pitfalls). Adding meaningful coverage would require a mock-powers DI scaffold of the shape `test/component/spaces-gutter-home.test.js` carries (hundreds of lines for a simpler component). That is its own assayer dispatch rather than a cleaner pass per the skill's "elaborate mock is a signal that the code under test has the wrong shape, not that you need a more elaborate test" guidance.

3. **Dead-code deletions: none.** Surveyed all top-level decls in `inventory-component.js`: `CONVERSABLE_TYPES`, `NON_EXPANDABLE_TYPES`, `HUB_TYPES`, `makeStaticNameIterator`, `makeStaticTreePowers`, and the exported `inventoryComponent` are all live callers in-file or in `chat.js`.

4. **Prettier / lint polish.**
   - Prettier clean on both touched files.
   - 5 net-new ESLint warnings in `inventory-component.js` (4x `@jessie.js/safe-await-separator`, 1x `jsdoc/reject-any-type`, 1x `jsdoc/require-param-type`). Project-pervasive shape (218 warnings across the chat package); not error-class, not CI-gating.
   - 18 net-new TS errors in `inventory-component.js` (DragEvent.dataTransfer / MouseEvent.clientX/Y narrowing on `addEventListener` arrow handlers; pattern matches the package's existing 207 baseline TS errors of the same shape). Root `yarn lint` does not run `tsc`, so neither baseline nor net-new errors gate CI. Fixing them properly requires touching the `$parent` typing contract (out of cleaner scope; not in this PR's mandate).

## Post-cleaner CI state

All 22 CI checks pass on the rebased head `86cae5412`. Confirmed via `gh pr checks 131`:
browser-tests, build, build-wasm, check-action-pins, cover (22.x / 24.x), familiar-bundle, lint, sandbox-drivers, test (22.x / 24.x on ubuntu / macos), test-async-hooks (22), test-hermes, test-ocapn-python, test-xs, test262 (22.x / 24.x), viable-release (22.x / 24.x), zizmor.

PR is `MERGEABLE` / `mergeStateStatus: UNSTABLE` (the "unstable" annotation here is the normal post-rebase-pre-CI-converge state; with all 22 checks now passing it will read CLEAN on next poll).

## State note

PR #131 is **not in draft** (already `isDraft: false`). The dispatch chain framing of "judge dispatches next for panel-review stage" still applies, since the PR has no reviews (`reviews: []`) and no maintainer review decision yet — the gamut's first panel round can still run before this enters the maintainer's queue.

## Out of scope / next-step recommendations

- Comprehensive component test for `inventory-component.js` warrants a dedicated assayer dispatch with an `inventoryComponent`-shaped mock-powers scaffold (mock `lookup` / `reverseLookup` / `followNameChanges` / `storeIdentifier` / `move` / `copy`, plus a `dataTransfer` shim on happy-dom's DragEvent). Recommended as a separate work item, not as a blocker on this PR's panel review.
- The package-wide 207 baseline TS errors plus the 18 added by this PR represent a project-level type-narrowing debt on UI component DOM handlers. A package-wide pass to introduce a `$parent` typing contract is its own larger fix, not a cleaner-scope action.

Self-improvement: nothing this time. The dispatch brief was clear on the rebase + retarget authorization and the cleaner scope; the genuine difficulty (no test infrastructure for a UI component) is correctly handled by surfacing it in the report rather than papering over it with a smoke test that would not be load-bearing per `skills/regression-evidence/SKILL.md`.
