---
role: builder
tier: mentor
---
<!-- garden-promoted-from-plan: gate=deferred priority=normal at=2026-09-16T15:04:08Z cleared=none -->

---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# builder: implement the Ironhorse computron benchmark-baseline regime (steps 2–8)

Successor to `ironhorse-computron-benchmark-baseline-build`, which completed the
plan's **step 1 (audit)** and handed off the remaining implementation. Plan:
`designs/ironhorse-computron-benchmark-baseline.md` (draft PR endojs/endo-but-for-bots#1283,
against `llm`). Source directive: PR #1282 review comment
https://github.com/endojs/endo-but-for-bots/pull/1282#issuecomment-5692322970

## GATE — do not start until BOTH hold
1. The maintainer has answered the design's `## Open questions` (a message was sent
   to the liaison from the predecessor job; the answers set the seed roster and the
   gate tolerance bands — the *substance* of the committed baseline artifact).
2. Design PR #1283 is reviewed/approved (or the maintainer directs building on the
   design's recommended defaults regardless). Building a measured, provenance-tracked
   baseline against an unconfirmed roster/bands, as a PR competing with the still-open
   design PR, is throwaway churn — the predecessor deliberately did not do it.

Also note: the plan's gate-3 (steps 4 & 8) requires wall-clock median measurement on
a **controlled host**. The garden's linuxkit container cannot produce representative
medians for the committed `computron-baseline.json` provenance; step 5/8 must run on a
host suitable for benchmark measurement (release build, host-controlled), as the
existing `benches/run.py` / `scaling_bench` roster already requires.

## Step-1 audit (DONE by predecessor — carry into the build PR body)

Loads left with NO surviving own-cost constraint after PR #1282 (the gap this regime
must fill; verified against the `chore/ironhorse-demolish-xs-computron-parity-myth`
head state and the 53-entry golden corpus `ironhorse-vm/tests/fixtures/computrons.tsv`):

1. **async-generator `await` metering** (`ironhorse-262/tests/await_in_try.rs`): the
   former −20 start-reject pin and the −38/−26/−1/+3 reject-matrix are now advisory
   telemetry (`if !computrons_agree { eprintln!(... advisory ...) }`), no
   `assert_eq!(computrons, N)`. The golden corpus pins only one unrelated async-gen
   shape (`async function* g(){yield 1} g().next()` = 56 computrons); the try/await/
   reject shapes are unconstrained.
2. **suspend-in-try metering** (`ironhorse-262/tests/suspend_in_try_metering.rs`):
   throw-across-yield, throw-across-await, cross-frame rebased handler, post-resume
   no-surcharge — all `assert_result_exact` (result only), computron drift advisory;
   no matching golden-corpus entry despite the file header's golden-vector claim.
3. **promise-combinator meter** (`ironhorse-262/tests/promise_combinator_capability_result_parity.rs`):
   per-boundary metering across the combinator — results gated, computron drift advisory,
   no own-cost pin.
4. **regexp match-meter** (`ironhorse-regexp/tests/parity.rs`, `ironhorse-fuzz/src/regexp.rs`):
   XS-equality relaxed to advisory. PARTIALLY retained: `ironhorse-regexp/tests/work_limits.rs`
   still pins `match_meter_raw == 100 * XS_REGEXP_METERING` (linear-in-subject-length) and
   the `finding_*_regexp_meter_overflow.rs` pin overflow/`compile_meter_raw` determinism —
   but representative match loads (subject length × pattern shape) are otherwise
   unconstrained on cost range.

Kept-constrained (NOT in the gap): `error_messages_calls.rs` own pin
(`ironhorse_computrons == 14`), the ~15 interp frozen-cost pins, `ironhorse_meter_bounds.rs`,
the `ironhorse-meter-5-raw-N` raw pins, the 53-entry golden corpus, and `--repeat`
determinism.

## Remaining steps (design § Phased execution, 2–8)

2. Define the baseline record format `rust/engine/benches/computron-baseline.json`
   (load id, `f(n)` growth basis, fitted coefficient/intercept, per-size exact
   computrons/meter_raw, confirming wall-clock medians, tolerance bands,
   COST_TABLE_VERSION + provenance) and the growth-class band table.
3. Build the `computron_baseline` harness: gate 1 (exact pins at ladder sizes,
   deterministic PR lane, extending `golden_computrons.rs`/`computrons.tsv`), gate 2
   (per-doubling class bands + off-ladder `C_model(n) ± ε`, deterministic PR lane),
   and a `--write-baseline` recorder.
4. Build gate 3 as a nightly wall-clock benchmark step (time-class == computron-class;
   global computrons/second fidelity band) wired into the `benchmarks` job in
   `.github/workflows/ironhorse-full-test262.yml`.
5. Seed the roster (§ polynomial built-ins: named-property insertion o['k'+i]=i
   [quadratic], string indexing/iteration [linear], Map/Set bulk insert [linear],
   for..in [linear], regexp match, async-gen await/suspend) plus every load from the
   step-1 audit; record baselines via `--write-baseline` on a controlled host; commit.
6. Wire gates 1–2 into the ordinary Rust test lane (`ci.yml`); keep gate 3 nightly.
7. Reconcile #1282: repoint the `computrons_agree` metering-claim rule in
   `designs/ironhorse-known-defects.md` at the benchmark baseline + raw meter; rebase
   #1282 onto the landed regime (or coordinate merge order per design § fate — land the
   regime first, then #1282 rebases so no coverage-gap window exists); add a note to
   #1282's body referencing this work.
8. Run the full nightly benchmark lane locally (release, host-controlled) and record
   measured medians + growth-class confirmations as evidence in the PR.

Open the PR through the gardening flow (ensure-pr.sh) against `llm`. If steps 2–8 are
themselves large, orchestrate ordered sub-builds rather than piling loose jobs.

<!-- garden-transient-elapsed: kind=exit0 through=0 values=92 -->
<!-- garden-reap-now -->
---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-09-16T15:04:26Z
