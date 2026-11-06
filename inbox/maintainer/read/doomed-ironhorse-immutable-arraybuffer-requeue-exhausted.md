from_host: endolin-garden-ece02cb4
from: reaper:endolin-garden-ece02cb4
sent_at: 2026-11-05T17:44:04Z
doom_base: ironhorse-immutable-arraybuffer
doom_signature: requeue-exhausted
notice_count: 1
first_seen: 2026-11-05T17:44:04Z
last_seen: 2026-11-05T17:44:04Z
---
SPLIT-ELIGIBLE job PARKED in jobs/plan/ (held, gate=go-ahead) after its sole backed-off retry also exited non-productively on endolin-garden-ece02cb4.
The reaper stopped retrying it; split it into claim-sized stages or surface it as indivisible.
The work is preserved at jobs/plan/ironhorse-immutable-arraybuffer; it stays HELD until a human promotes it
(promote-plan.sh ironhorse-immutable-arraybuffer) or removes it, so nothing is lost.
Original job base: ironhorse-immutable-arraybuffer

--- original job body ---
---
role: builder
tier: mentor
posted_at: 2026-10-09T22:19:47Z
---
<!-- garden-promoted-from-plan: gate=go-ahead priority=normal at=2026-11-05T17:07:01Z cleared=none -->

---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# IronHorse: implement Immutable ArrayBuffer and enable it in the oracle

Repo: endojs/endo-but-for-bots, base `llm` (frozen `llm-<sha>` snapshot per skills/frozen-base-branch). Design: designs/ironhorse-moddable-10-0-0-port-plan.md on branch design/ironhorse-moddable-10-0-0-port-plan (endojs/endo-but-for-bots; design PR from job moddable-10-0-0-ironhorse-port-plan-20261009). Read the design first; its classification table and § Oracle and ratchet impact are normative for this child. Open a DRAFT PR via ensure-pr.sh; completion stages the gauntlet.

If you genuinely finish but do not achieve the gated outcome below, end your report with the exact lines `<<<GARDEN-ORCHESTRATION-FAILED>>>` then `<<<GARDEN-JOB-COMPLETE>>>`.

Implement the Immutable ArrayBuffer proposal (tc39/proposal-immutable-arraybuffer): read-only buffer state, `ArrayBuffer.prototype.immutable`, `transferToImmutable`, `sliceToImmutable`; mutable checks on every write path (TypedArray set/fill/copyWithin/reverse/sort, DataView set*, Atomics, slice/species destinations, TypedArray.from/of custom ctor results, setFromHex/Base64 if present); persistence in snapshots. In the SAME PR flip `mxImmutableArrayBuffers` to 1 in `xs-oracle/build.rs` so the ~50 immutable shared-skip cases become Covered, not Divergent. Cross-check with the hardened262 immutable-arraybuffer view matrix.
Gated outcome: immutable-arraybuffer test262 cases covered with zero new divergences; floor growth only. Size M–L.
