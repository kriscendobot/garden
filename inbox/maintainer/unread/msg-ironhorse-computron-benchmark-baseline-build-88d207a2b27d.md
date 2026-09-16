from_host: oros-studio-garden-ce242c49
from: gardener:ironhorse-computron-benchmark-baseline-build
reply_to: ironhorse-computron-benchmark-baseline-build
msg_key: msg-ironhorse-computron-benchmark-baseline-build-88d207a2b27d
notice_count: 1
first_seen: 2026-09-16T05:40:01Z
last_seen: 2026-09-16T05:40:09Z
sent_at: 2026-09-16T05:40:09Z
---
Re: "make a plan and execute that plan" — Ironhorse computron benchmark-baseline regime (design PR endojs/endo-but-for-bots#1283, source: PR endojs/endo-but-for-bots#1282 review comment).

The plan (job `ironhorse-computron-benchmark-baseline-design`) landed as **draft** PR endojs/endo-but-for-bots#1283 with an `## Open questions` section, and it explicitly states the build's implementation specifics are gated on your answers to those questions. As the builder I completed the plan's unblocked step 1 (the audit) and am **holding the rest** rather than committing a measured, provenance-tracked baseline against unconfirmed parameters. Two reasons I did not just build on the defaults:

1. **The open questions define the substance that gets committed** — the seed roster (which loads to baseline) and the tolerance bands (the actual gate values). Getting these wrong means re-measuring a provenance-tracked artifact = throwaway churn, and it would land a large new CI-gating PR competing with the still-open, unreviewed design PR.
2. **Gate 3 (the "benchmark-established" heart) needs wall-clock measurement on a controlled host.** The garden's container can't produce representative medians; that step must run on a benchmark-suitable host regardless.

**Step-1 audit result — loads endojs/endo-but-for-bots#1282 left with NO surviving own-cost constraint (the gap the regime must fill):**
- async-generator `await` metering (`await_in_try.rs`): former −20 start-reject pin + reject-matrix → advisory only.
- suspend-in-try metering (`suspend_in_try_metering.rs`): throw-across-yield/await, cross-frame rebased handler, post-resume → advisory only.
- promise-combinator meter (`promise_combinator_capability_result_parity.rs`) → advisory only.
- regexp match-meter (`parity.rs` + fuzz) → advisory; partially retained via `work_limits.rs` (`match_meter_raw == 100·XS_REGEXP_METERING`) and the `finding_*` overflow pins, but representative match loads (subject×pattern) are otherwise unconstrained.
- Kept-constrained (not in the gap): `error_messages_calls.rs` `==14`, the ~15 interp frozen-cost pins, `ironhorse_meter_bounds.rs`, the `ironhorse-meter-5-raw-N` raw pins, the 53-entry golden corpus, `--repeat`.

**The 6 open questions — with the design's recommendations. Please confirm/adjust:**
1. Tolerance bands? Proposed: gate-1 exact (0); gate-2 off-ladder ε=±3%, per-doubling class bands ≈ linear [1.8,2.2] / quadratic [3.6,4.4] / constant [1.0,1.15]; gate-3 fidelity (computrons/sec) ±25%. → *right widths?*
2. Gate-2 (deterministic growth envelope) on **PR CI** or nightly? → design recommends **PR CI**.
3. Authoritative seed roster? → design proposes the §polynomial-built-ins list (named-property insertion [quadratic], string indexing/iteration, Map/Set bulk insert, for..in, regexp match, async-gen await/suspend) + every load from the audit above. Add/drop any?
4. COST_TABLE_VERSION bump: auto-regenerate baselines, or always manual `--write-baseline`? → design recommends **manual** (reviewability).
5. Fate of endojs/endo-but-for-bots#1282: **revise in place, land the regime first, merge together to avoid a coverage-gap window** (design recommendation) vs. supersede with a fresh combined PR?
6. Two-input (grid) baselines (regexp subject×pattern) in this build, or defer? → design recommends **defer**; ship single-input first.

Once you answer (or say "build on the recommended defaults"), the implementation is queued: successor build job `ironhorse-computron-benchmark-baseline-build-exec` is parked on the plan queue owning steps 2–8, ready to promote. Nothing is lost.
