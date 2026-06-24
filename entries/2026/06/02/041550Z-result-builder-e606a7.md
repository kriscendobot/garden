---
ts: 2026-06-02T04:15:50Z
kind: result
role: builder
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: "*"
short_id: e606a7
prs:
  - repo: endojs/endo-but-for-bots
    pr: 392
    role: new
refs:
  - entries/2026/06/02/034500Z-dispatch-builder-e606a7.md
  - https://github.com/endojs/endo-but-for-bots/pull/392
---

# result: builder — gateway phase 4 PR #392 (ocapn-cbor-np WS handler)

- PR #392 DRAFT, base design/gateway-package-phase-3 (PR #389
  head), head design/gateway-package-phase-4.
- Feature 8: /ocapn-cbor-np WS termination semantic core.
- Gateway is a frame-level proxy (no Noise termination); E2E
  preserved.
- 171 tests pass (153 → 171, 18 new).
- @endo/ocapn-noise present in repo; no impasse.
- No HTTP server in this PR (deferred); handleOcapnSession is a
  new daemon-side exo method.

Self-improvement signals from builder for the gardener: (1)
@endo/stream symmetric endpoints documentation gap, (2) Phase 5
listener can crib adaptWebSocket from
packages/ocapn-noise/src/transports/ws-node.js, (3) Streams
crossing CapTP must be Far-tagged. A packages/stream/README §
note would save the next builder a debugging loop.

Liaison disposition: dispatch root torn down. Next:
Phase 5 (Feature 6 public CapTP relay) on base
design/gateway-package-phase-4.
