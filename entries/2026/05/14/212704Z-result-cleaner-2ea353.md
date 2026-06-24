---
ts: 2026-05-14T21:27:04Z
kind: result
role: cleaner
project: endo-but-for-bots
to: liaison
prs:
  - repo: endojs/endo-but-for-bots
    pr: 247
    role: target
refs:
  - entries/2026/05/14/203714Z-dispatch-liaison-2ea353.md
---

# Result: cleaner advances #247; CI converges green on cleaner HEAD

Head SHA after cleaner: `ac989794bfb097138eeb20a3d541f3984243a964`.
PR state: `OPEN`, `isDraft: true` (judge un-drafts), `mergeable: MERGEABLE`.
Branch: `feat/eventual-send-test` on `endojs/endo-but-for-bots`.

## Per-package work

### `@endo/eventual-send`

- No orphans.
  Every exported symbol is reachable from `no-shim.js` (the package main) or `utils.js`.
  `track-turns.js` and `postponed.js` are pulled in transitively by `handled-promise.js`; both are env-gated or constructor-invoked, not callable from outside.
- No source changes (out of scope for a cleaner).
- No additional tests are appropriate here.
  The 64 tests now live in the new package and cover the full public surface via the `test-endo-eventual-send` condition.

### `@endo/eventual-send-test` (new)

- 64 tests pass locally (8 ava files: `e`, `eventual-send`, `hp`, `local`, `message-breakpoints`, `proxy`, `thenable`, `types`, plus `exports.test-d.ts` for tsd).
- Coverage delta not measurable.
  c8 cannot trace into another workspace through the `test-endo-*` exports condition (same gap on the `harden-test` sibling).
  Filing a one-line note rather than a contortion test.
- One lint-fix commit: `chore(eventual-send-test): fix import order in exports.test-d.ts`.
  The builder's `git mv` from `packages/eventual-send/src/` to the new test package re-classified the type import (`./exports.js` -> `@endo/eventual-send`) from "local" to "external", which the project's `import/order` rule wants ahead of the `_get-hp.js` import.
  This was the only red on CI on the builder's head (the workflow `lint` job; the per-package lint was clean).
  Reordered the two import lines.
  No behavior change; tsd type-test still runs identically.

## Dead code deletions

None.
The four-criterion threshold for safe deletion did not fire on any export.

## CI status on cleaner HEAD

All 25 checks `SUCCESS` (run `25884746163`, +sister docs-only run): lint x2, build, test (8x matrix), browser-tests, sandbox-drivers, cover x2, test262 x2, test-xs, test-async-hooks, test-hermes, test-ocapn-python, build-wasm, familiar-bundle, check-action-pins, viable-release x2, plus the `Test project mutual dependency versions` build.

## Hand-off

PR is ready for the judge.
The judge runs the twelve-seat code panel (path globs touch `packages/**`, not `designs/**`), and un-drafts after the panel-fixer loop terminates per the new flow.

Self-improvement: nothing this time.
The lint-fix was a small variant of the recurring "renamed file changes its import classification" pattern that `rename-discipline` already covers; the cleaner happened to be the one to catch it because it was the active role at CI-watch time.
