---
ts: 2026-06-17T21:29:41Z
kind: result
role: builder
worktree: dispatches/builder--d583f9/project
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
refs:
  - entries/2026/06/17/211300Z-dispatch-builder-d583f9.md
---

## WIP substance

The `kriskowal-iroh-heartbeat` branch carried one commit (`WIP iroh heartbeat`, 2a15545f0) on top of origin/llm. The commit was substantively complete:

- `packages/daemon/src/networks/iroh-heartbeat.js`: 168 lines, full `makeIrohHeartbeat(connection)` module with QUIC datagram heartbeat (30s interval), keep-alive watchdog (60s, lazy-armed on first inbound datagram), idempotent `stop()`, and a `harden()`'d return value.
- `packages/daemon/src/networks/iroh.js`: integration into `serveStream` with `tearDown` plumbing (capTp.close + connection.close) and `heartbeat.stop()` on connection close.
- `packages/daemon/test/iroh-heartbeat.test.js`: 7 tests covering interval emission, inbound-driven re-arming, the silence-presumes-dead window, the never-heartbeated-peer (lazy-arming) case, idempotent stop, datagram-unsupported fallback, and send-error logging. Each test uses short intervals (tens of ms) so the suite runs in well under a second.
- `packages/daemon/designs/iroh-network-design.md`: 35 lines added documenting the keep-alive and liveness behavior in the existing design.

## Decision: finalize

Substantively complete; needed only polish (prettier on the test file), a changeset, the conventional commit message rewrite, and PR opening. No code build-out required.

## Commits and head

- `2b50d646b feat(daemon): iroh QUIC datagram heartbeat and keep-alive watchdog` (WIP commit amended with the prettier fix and a proper conventional-commit message; author preserved as Kris Kowal since the substance is his)
- `f24c54713 chore(changeset): iroh QUIC heartbeat and keep-alive watchdog`

New head: `f24c54713` on `kriskowal-iroh-heartbeat`. Force-pushed with lease anchored on the prior `2a15545f0`.

## PR

#453: https://github.com/endojs/endo-but-for-bots/pull/453

- DRAFT
- Base: `llm-9a3b5e9` (frozen-base snapshot of `llm` at PR-open)
- Head: `kriskowal-iroh-heartbeat`
- Title: `feat(daemon): iroh QUIC datagram heartbeat and keep-alive watchdog`
- Body: filled per the upstream PR template (Description, Security, Scaling, Documentation, Testing, Compatibility, Upgrade sections plus an Out-of-scope note). No checklists, no file callouts, no methodology leak.
- Top-level comment @-mentioning @kriskowal: https://github.com/endojs/endo-but-for-bots/pull/453#issuecomment-4735719033

## Test results

`npx corepack yarn workspace @endo/daemon exec ava test/iroh-heartbeat.test.js test/iroh-address.test.js test/iroh-network.test.js test/iroh-stream-adapter.test.js`:

```
26 tests passed
1 test skipped (iroh-network real-node round-trip; sandbox limitation pre-existing)
```

All 7 new iroh-heartbeat tests pass. Existing iroh suite unchanged.

## Regression evidence

Verified two tests are load-bearing by saboteur runs:

1. Replacing the `setTimeout` body in `touch()` with a no-op (so the watchdog never fires) causes `presumes the peer dead after the keep-alive window of silence` to fail with `expected 1, got 0`.
2. Removing the `setInterval` + initial `sendBeat()` (so no beats are emitted) causes `emits heartbeat datagrams on the interval` and `a failing sendDatagram is caught and reported` to fail.

Source was restored after each saboteur run; suite is green.

## Pre-push-gates result

Mixed: the new files (`iroh-heartbeat.js`, the test, the design addendum, the iroh.js integration) all pass lint, prettier, typecheck, and the deterministic probes. The gate also surfaced pre-existing project-wide failures unrelated to this PR (sentence-per-line-md in pre-existing design content; filename-no-stutter in `packages/fae/`; no-inline-import-jsdoc in `packages/9p-server/`; missing `packages/endo/SECURITY.md`). The auto-fix phase touched 24 unrelated files (Prettier/lint drift across the tree); those auto-fixes were discarded and only the iroh-heartbeat test prettier fix was kept in the PR.

The pre-existing pre-push-gates failures are project-wide hygiene issues that are out of scope for this PR.

## Recommended next stage

`next: cleaner` for gamut stage 1.

Self-improvement: nothing this time.
