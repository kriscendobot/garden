---
gate: go-ahead
priority: normal
role: builder
tier: mentor
token-budget: 250000
doomed: true
doom_signature: requeue-exhausted
doom_count: 1
split_eligible: true
split_reason: repeated-plain-exit
failure_classification: transient
requeue_cycles: 2
deadline_overruns: 0
elapsed_constancy_confirmations: 0
doomed_at: 2026-11-05T17:43:14Z
doomed_on: endolin-garden-ece02cb4
posted_by: reaper:endolin-garden-ece02cb4
posted_at: 2026-11-05T17:43:14Z
---

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
