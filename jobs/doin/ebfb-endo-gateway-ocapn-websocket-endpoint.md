---
role: builder
---

Build the next `@endo/gateway` Phase-1 increment for endojs/endo-but-for-bots: Feature 8, the canonical `/ocapn` WebSocket endpoint on the merged `packages/gateway/` skeleton (from PR #343, per the merged `endo-gateway` design § OCapN endpoint). Accept the WebSocket upgrade at `ws://<host>/ocapn` and hand the framed connection to the Noise-over-WebSocket OCapN transport, package-local and powers-injected for unit testing; open a DRAFT PR on base `llm`, bot fork only, deferring the daemon `@apps` integration as a named seam.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 9
  claimed_at: 2026-07-06T13:53:48Z
