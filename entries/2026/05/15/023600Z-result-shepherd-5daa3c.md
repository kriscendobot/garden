---
ts: 2026-05-15T02:36:00Z
kind: result
role: shepherd
project: agoric-sdk
prs:
  - repo: kriscendobot/agoric-sdk
    pr: 1
    role: target
refs:
  - entries/2026/05/15/022428Z-dispatch-liaison-5daa3c.md
---

# Result: shepherd drives kriscendobot/agoric-sdk#1 to green (CI propagating)

Dispatch root: `dispatches/shepherd--5daa3c/`.

## Diagnosis (substantive, not flake)

`lint-primary` run 25886309121's failing step is **"lint multichain-testing"**, working-dir `multichain-testing/`. The actual error is yarn YN0028 in hardened mode: `yarn install` refuses to modify the lockfile.

Root cause: the import-x alias commit `0ab4e7bbb` broadened `@agoric/eslint-config`'s `eslint-plugin-import` peer-dep range from `^2.25.3` to `^2.25.3 || ^4.16.0` (so the root npm-alias `eslint-plugin-import: npm:eslint-plugin-import-x@4.16.2` satisfies it), and regenerated the root `yarn.lock`. The `multichain-testing/yarn.lock` was **not** regenerated, so its `peerDependencies` block for `@agoric/eslint-config` still records the stale `^2.25.3` range. On a fresh PR run yarn detects the divergence and aborts (hardened mode protects against malicious lock manipulation).

## Fix

Commit `bb407ca1d` (one line in `multichain-testing/yarn.lock`): align that file's peer-dep entry with the root. No source change. Validated locally with `YARN_ENABLE_HARDENED_MODE=1 yarn install --immutable` in `multichain-testing/` — passes with only pre-existing peer-dep YN0060/YN0002 warnings (same warnings appeared in CI just before the YN0028 fatal), no lockfile modification requested.

Pushed at 02:32Z. Head SHA `bb407ca1d` on `kriscendobot/agoric-sdk@feat/migrate-eslint-plugin-import-x`. (Note: the branch had been re-shaped from 2 commits to 3 between the dispatch's `638a578f` snapshot and now; rebased my commit onto the live tip.)

## CI status

Run 25897100110 in progress. Initial-stage checks green (lint, breakage, run-scripts-tests, merge-strategy, up-to-date, wait-integration-pre-checks). `build (node-new/node-old)` running; `lint-primary` gated on builds. Convergence ETA ~25 min. Monitor armed within dispatch (`beg6ikw73`); if it does not converge before dispatch teardown, the next steward sweep verifies.

No PR comment posted (optional per dispatch). No Agoric/agoric-sdk action.

Self-improvement: when shepherd-diagnosing a CI failure on a branch that was force-pushed after the dispatch was queued, always `git fetch origin <branch>` first and rebase my fix onto the live tip rather than the dispatch's snapshot SHA, otherwise the push is rejected non-fast-forward.
