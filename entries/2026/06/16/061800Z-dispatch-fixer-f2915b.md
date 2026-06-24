---
ts: 2026-06-16T06:18:00Z
kind: dispatch
role: steward
host: endolinbot
repo: kriscendobot/agoric-sdk
project: agoric-sdk
to: fixer
dispatch_root: /home/kris/dispatches/fixer--f2915b
prs:
  - repo: kriscendobot/agoric-sdk
    pr: 5
    role: target
refs:
  - https://github.com/kriscendobot/agoric-sdk/pull/5
---

# dispatch: fixer — OODA cycle 4 on PR #5 (lint-primary final + test cascade)

OODA cycle 4 observe on PR #5 head `10cc23bc10` shows:

**Major win this cycle**: test-fast-usdc-deploy BOTH PASS (Float*Array endow + dual-AVA fix + d8a32b absorb resolved Class B in CI).

**Remaining failures (27 total)**:

| Class | Job(s) | Notes |
|---|---|---|
| A | test-dapp (node-new) | expected |
| C | lint-primary | 1 error: `packages/fast-usdc-deploy/src/utils/deploy-config.js:4` missing `@endo/common` dep (fixer a849e6 deferred this as "Class B" but it's actually a simple missing-dep) |
| C | lint-rest | TBD; investigate |
| C | dependency-graph | TBD; investigate |
| C/cascade | test-cosmic-swingset (both), test-inter-protocol (both), test-portfolio-contract (both), test-quick (both), test-quick2 (both), test-solo (both), test-swingset (xs/node-old/node-new matrix, 11 cells) | Likely cascading from lint-primary's fail-fast (workspace-wide-test depends on workspace-wide-lint pass) OR real test failures from the absorb. |

## State at dispatch time

- **PR** `kriscendobot/agoric-sdk#5`, DRAFT, head `10cc23bc10`.

## Task

In your `project/` worktree at `10cc23bc10`:

1. **Fix lint-primary's 1 remaining error**:
   - `packages/fast-usdc-deploy/src/utils/deploy-config.js:4`: add `@endo/common` to that package's `package.json` dependencies. Reference upstream Agoric#12734's package.json for the version to match.
2. **Investigate lint-rest**: `gh run view <run-id> --log-failed` for the lint-rest job. Apply targeted fix.
3. **Investigate dependency-graph**: `gh run view --log-failed`. Likely a yarn.lock / package.json mismatch from the absorb; check if a `yarn install` regenerates the lock correctly.
4. **Investigate ONE test failure** (e.g., test-swingset (node-old, 0, 5)) to determine if test-* failures are cascade (fail-fast cancellation) vs real:
   - If real: identify the signature, fix it.
   - If cascade: note it and expect they'll clear on next CI cycle after lint-primary clears.
5. Run pre-push-gates.
6. Commit per logical group.
7. Push to `mirror/12527-endo-sync-refresh` (append only).
8. Post a top-level comment on PR #5 at-mentioning @kriskowal:
   - Cycle 4 classification summary.
   - Per-fix SHA mapping.
   - Note Class B (fast-usdc-deploy) PASSED — major win.
   - If test cascade, note expectation that it'll clear next cycle.

## Authorizations

- Append-push.
- Top-level comment.
- Do NOT revert Float*Array endow, dual-AVA fix, d8a32b absorb net, or any prior fixer's substance.
- Do NOT touch upstream Agoric/agoric-sdk.

## Out of scope

- Do NOT pursue test-dapp Class A.

## Deliverable

A `result` entry under `journal/entries/2026/06/16/` naming:

- Pre/post head SHAs.
- Per-fix SHA mapping.
- Test-cascade verdict (real vs cascade).
- pre-push-gates result.
- PR #5 comment URL.
- A `Self-improvement: ...` line.
- **Recommended next stage**: `next: ooda-observation` when CI settles, OR `next: liaison` if cascade + cycle 5 should be limited.

End your turn with a concise summary back to the orchestrator.
