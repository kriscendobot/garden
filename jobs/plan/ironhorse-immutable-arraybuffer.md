---
gate: go-ahead
priority: normal
posted_by: designer
posted_at: 2026-10-09T22:19:47Z
---

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
