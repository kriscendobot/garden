---
role: builder
tier: mentor
arc: minion-town-mcp-ocapn
---
<!-- garden-promoted-from-plan: gate=deferred priority=normal at=2026-10-16T18:44:14Z cleared=none -->

---
arc: minion-town-mcp-ocapn
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Build job for endojs/endo-but-for-bots: continue `designs/ocapn-noise-session-reconnect.md` (on `llm`) after its Phase 1 slice, the draft PR opened by job `endo-but-for-bots-ocapn-noise-session-reconnect-build` (head branch `build/ocapn-noise-session-reconnect-heartbeat`; find it by the `<!-- garden-job: endo-but-for-bots-ocapn-noise-session-reconnect-build -->` marker). That slice landed `op:ping`/`op:pong` in every codec plus opt-in heartbeat liveness in `packages/ocapn-noise/src/network.js`.

This job owns the remaining work, one draft PR per phase or a stack, each with the pr-formation phase-and-evidence ledger:
- Phase 2: session-level outbound queue and epoch counter on one transport instance, with the simulated-stall fault injector the design names.
- Phase 3: transparent reconnect with Rekey (fresh Noise IK on a new transport instance).
- Phase 4: reconnect with Resume (RESUME/RESUME-ACK, nonce continuity). Gated on Open question C1 and the cryptographic review (design PR #1475 `design/ocapn-noise-cryptographic-review` is open): do not build Phase 4 until the maintainer settles C1.
- Phase 5: crossed-hellos tiebreaker on reconnect.
- The heartbeat capability bit from § Upgrade Considerations, after which heartbeats can default on, and daemon wiring (`packages/daemon/src/networks/ocapn.js`) that enables heartbeats.
When every phase has evidence, update the Phase 1 PR's ledger to `deliverable`.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-16T18:50:09Z
