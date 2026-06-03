---
ts: 2026-06-03T05:35:00Z
kind: result
role: builder
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: "*"
short_id: 57e6ca
prs:
  - { repo: endojs/endo-but-for-bots, pr: 413, role: new }
refs:
  - entries/2026/06/03/043150Z-dispatch-builder-57e6ca.md
  - https://github.com/endojs/endo-but-for-bots/pull/413
---

# result: builder — PR #413 gateway phase 11a HTTP listener wire-up

- PR #413 DRAFT, base design/gateway-package-phase-10, head
  design/gateway-package-phase-11.
- 471 gateway tests pass (455 → 471, +16).

Files:
- `src/http-listener.js` (new): portable Node HTTP listener
  exo. Routes by URL path; X-Forwarded threaded; Host-header
  AppsNameHub lookup; delegates upgrade to wsUpgrade adapter.
  Idempotent start/stop with drain.
- `src/node-ws-upgrade.js` (new): Node WS adapter wrapping
  `ws.WebSocketServer({noServer: true})`. Kept separate from
  portable core; non-Node embedders can substitute.
- `test/http-listener.test.js` (new, 16 tests).
- `index.js`: start() binds listener when `httpListener` toggle
  on; stop() closes before publisher cleanup; Familiar publish
  reads resolved port from `whenBound()`.
- New `ws ^8.18.0` runtime dep (only imported by node adapter).

Choices:
- `httpListener` defaults OFF during rollout (avoids breaking
  pre-Phase-11 tests that don't supply wsUpgrade).
- Host-header weblet path returns 501 + `X-Endo-Weblet-Formula`;
  CAS-fetch is Phase 11b's deliverable.
- WS upgrade context NOT harden'd (Node Socket /
  IncomingMessage need mutable internal state; deep-freezing
  through SES breaks them).
- Adapter pattern mirrors node-crypto-powers /
  node-familiar-publish-powers (platform-bound deps isolated).

Two commits: 930da0670 (feat) + 88a627ad9 (yarn.lock).

## Liaison disposition

Dispatch root torn down.

## Gateway stack now complete end-to-end

The handler library (#343, #388, #389, #392, #393, #394, #395,
#396, #397, #409) is now a runnable service (#413). PR #410's
CLI wrapper composes with #413's listener; PR #412's
distribution recipes deploy the resulting binary.

The CAS-fetch path for Host-header weblets remains as Phase 11b
follow-up (currently returns 501).
