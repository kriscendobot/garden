---
ts: 2026-06-17T23:05:00Z
kind: result
role: builder
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
refs:
  - entries/2026/06/17/224500Z-dispatch-builder-bcdbd8.md
---

Option A implemented on `kriskowal-iroh-heartbeat` (PR #452).

Pre-HEAD: `c08a2262c` (chore(lint): satisfy shellcheck on preexisting shell scripts)
Post-HEAD: `12384721d` (test: cover peer-formula revocation on iroh connection loss)

## Commits

- `fc5fe2271`: `feat(daemon): destroy peer formula on connection loss (Option A)`
  Replace `dropLiveValue(context.id)` with `context.cancel(new Error('peer connection lost'))` in the `dialAttempt` dispose callback.
  Cancels the peer formula's context, cascades via `thisDiesIfThatDies` to all dependent remote presences.
  Mark `isAbandonError` retry path in `ResilientPeerGateway.provide` and `currentGatewayP` with `TODO(option-a-simplification)` notes; both are unreachable for post-connect connection-loss but retained to keep blast radius minimal.

- `12384721d`: `test(daemon): cover peer-formula revocation on iroh connection loss`
  Four unit tests in `packages/daemon/test/peer-formula-revocation.test.js`:
  (1) dispose callback cancels peer formula context;
  (2) cancellation cascades to dependent remote presences;
  (3) regression evidence: `dropLiveValue` alone does not cancel;
  (4) end-to-end: remote-control dispose fires and cascades.

## Test results

All 4 new tests pass.
Existing `iroh-heartbeat`, `context`, `remote-control` tests unchanged (22 total, all pass).

## Pre-push gates

- `yarn format`: auto-fixed 2 paths (re-staged).
- `yarn lint`: 2 pre-existing errors in `packages/errors`; warnings in the test file (`@jessie.js/safe-await-separator`) are consistent with the existing warning level in the codebase.
- `no-inline-import-jsdoc` probe: pre-existing findings at daemon.js lines 462, 1203, 1212.
- `security-md-hash-uniform` probe: pre-existing divergence.
No gate failures attributable to the Option A change.

## PR comment

https://github.com/endojs/endo-but-for-bots/pull/452#issuecomment-4736281422
Answered `@kumavis` question about `isAbandonError` (predicate, re-dial path, unreachability after Option A).

Recommended next stage: `next: cleaner` for #452 to re-gamut on the expanded scope.

Self-improvement: nothing this time.
