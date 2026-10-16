---
arc: minion-town-mcp-ocapn
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Build job for endojs/endo-but-for-bots: continue `designs/ocapn-noise-session-reconnect.md` (on `llm`) after Phases 1–2.

Stack so far (in-repo branches, all draft):
- Phase 1 (#1476, head `build/ocapn-noise-session-reconnect-heartbeat`, base `llm-61cd656`): `op:ping`/`op:pong` in every codec + opt-in heartbeat liveness in `packages/ocapn-noise/src/network.js`.
- Phase 2 (head `build/ocapn-noise-session-queue`, base = the Phase 1 head; find it by the `<!-- garden-job: endo-but-for-bots-ocapn-noise-session-reconnect-phases-2-5 -->` marker): session-level outbound plaintext queue (frames encrypted at hand-off, so it can outlive a transport instance), heartbeat coalescing, write-stall-as-loss after SESSION_TIMEOUT, and the simulated-stall fault injector `packages/ocapn-noise/test/_stall-injector.js`.

This job owns the remaining work, one draft PR per phase stacked on the Phase 2 head, each with the pr-formation phase-and-evidence ledger:
- Phase 3: transparent reconnect with Rekey (fresh Noise IK on a new transport instance; advance the session epoch; replay the Phase 2 queue on the new instance; on session-timeout, reconnect instead of failing until SESSION_HARD_TIMEOUT, then settle the queue per § 5 terminal semantics).
- Phase 4: reconnect with Resume (RESUME/RESUME-ACK, nonce continuity). Gated on Open question C1 and the cryptographic review (design PR #1475 `design/ocapn-noise-cryptographic-review`): do NOT build Phase 4 until the maintainer settles C1; mark it `deferred` in the ledger with that reason.
- Phase 5: crossed-hellos tiebreaker on reconnect (designator comparison per § 3; fault injector forcing simultaneous loss).
- The heartbeat capability bit from § Upgrade Considerations, after which heartbeats can default on, and daemon wiring (`packages/daemon/src/networks/ocapn.js`) that enables heartbeats.
When every phase has evidence (or a maintainer-settled deferral), update the Phase 1 PR #1476 ledger (and the Phase 2 PR's) to `deliverable`.
