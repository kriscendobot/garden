---
ts: 2026-06-16T04:38:00Z
kind: dispatch
role: steward
host: endolinbot
repo: kriscendobot/agoric-sdk
project: agoric-sdk
to: fixer
dispatch_root: /home/kris/dispatches/fixer--a849e6
prs:
  - repo: kriscendobot/agoric-sdk
    pr: 5
    role: target
refs:
  - https://github.com/kriscendobot/agoric-sdk/pull/5
  - https://github.com/kriskowal/garden/blob/journal/entries/2026/06/16/033800Z-dispatch-fixer-3723ee.md
---

# dispatch: fixer — Class C/D residue on PR #5 after partial regression-fix (OODA cycle 3)

**OODA cycle 3 observe** on PR #5 head `509f34b0d0` shows 13 NEW lint-primary errors (different signature from cycle 2's n-readlines + vats imports which fixer 3723ee fixed). Partial progress — fixer 3723ee uncovered a new layer of absorb-fallout that needs another sweep.

## Current lint-primary errors (13)

All from the d8a32b absorb that took upstream's package.json's dep list but didn't take corresponding source-file refactors:

1. `packages/fast-usdc-contract/src/exos/status-manager.ts:21:24` — `'TypedPattern' is defined but never used` (`@typescript-eslint/no-unused-vars`)
2. `packages/fast-usdc-deploy/src/utils/deploy-config.js:4:1` — `'@endo/common' should be listed in the project's dependencies`
3. `packages/governance/src/contractGovernance/governParam.js:55:3` — floating promise (`@typescript-eslint/no-floating-promises`)
4. `packages/internal/src/lib-chainStorage.js:48:1` — `Use an @import directive instead of an inline import() inside @typedef` (`@agoric/no-typedef-import`)
5. `packages/orchestration/docs/types.md:1:0` — `Parsing error: Invalid character`
6. `packages/orchestration/src/exos/icq-connection-kit.js:5:16` — `'VowShape' is defined but never used`
7. `packages/orchestration/tools/contract-tests.ts:31:1` — `'@endo/common' should be listed in the project's dependencies`
8. `packages/solo/src/main.js:3:1` — `'minimist' should be listed in the project's dependencies`

(13 total errors; some files have multiple errors collapsed above.)

## State at dispatch time

- **PR** `kriscendobot/agoric-sdk#5`, DRAFT, head `509f34b0d0`.
- **Class A** (test-dapp): expected, skip.
- **Class B** (test-fast-usdc-deploy): preserved as B until Float*Array endow + bundle-deser stabilization land in CI.
- **Class C/D**: 13 lint errors above + 8+ test cascades.

## Task

In your `project/` worktree at `509f34b0d0`:

1. For each lint error, classify:
   - **Missing dep** (3 cases: `@endo/common` in fast-usdc-deploy/contract-tests, `minimist` in solo): add the dep to the package.json. Reference upstream #12734's package.json edits to see what version they use; match.
   - **Unused import** (2 cases: TypedPattern in status-manager.ts, VowShape in icq-connection-kit.js): drop the import.
   - **Floating promise** (governParam.js): add `void` operator or `.catch`.
   - **Inline typedef-import** (lib-chainStorage.js): convert to `@import` directive.
   - **Parsing error in markdown** (orchestration/docs/types.md): determine cause (probably a stray binary char or BOM); fix.
2. Run `corepack yarn lint:primary` to confirm clean.
3. Run pre-push-gates.
4. Commit per logical group (per-package preferred).
5. Push to `mirror/12527-endo-sync-refresh` (append only).
6. Post a top-level comment on PR #5 at-mentioning @kriskowal:
   - Per-error resolution mapping.
   - Commit SHAs.
   - Note that this completes the absorb cleanup sweep.

## Authorizations

- Append-push.
- Top-level comment.
- Do NOT revert Float*Array endow, dual-AVA fix, or d8a32b's net absorb.
- Do NOT touch upstream Agoric/agoric-sdk.

## Out of scope

- Do NOT pursue Class B (fast-usdc-deploy) — separate maintainer concern.
- Do NOT pursue Class A (test-dapp).

## Deliverable

A `result` entry under `journal/entries/2026/06/16/` naming:

- Pre/post head SHAs.
- Per-error fix mapping.
- Commit SHAs.
- pre-push-gates result.
- PR #5 comment URL.
- A `Self-improvement: ...` line.
- **Recommended next stage**: `next: ooda-observation` when CI settles.

End your turn with a concise summary back to the orchestrator.
