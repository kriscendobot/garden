All deliverables are complete. Final verification state: the engine workspace compiles clean and formatted, and with the XS oracle built from the `c/moddable` pin the suites pass locally — ironhorse-262 lib (150), all 28 ironhorse-262 integration suites, ironhorse-vm (278), ironhorse-fuzz (56), ironhorse-regexp `--features parity` (6).

## Completion report — ironhorse-demolish-xs-computron-parity-myth

**Delivered: endojs/endo-but-for-bots#1282** (`chore/ironhorse-demolish-xs-computron-parity-myth` → `llm`, ready for review), 37 files, +655/−508.

**What I did:**

- **Deleted the load-bearing beam.** `DualRun::is_bit_exact()` and the lib-level `Summary`/`met_bar` parity machinery in `ironhorse-262/src/lib.rs` are removed outright (they had zero consumers outside their own unit tests — `observables_agree()` already carried every real verdict). A tombstone comment at `observables_agree` and a new doctrine-pinning test (`observable_agreement_ignores_computron_drift`) make reintroduction a deliberate act, not a drift.
- **Demoted the two remaining live hard XS-meter gates** my sweep found beyond the job's map: the ironhorse-regexp parity suite's `match_meter_raw` equality (in CI) and the fuzz regexp differential's meter check — both now advisory, with result parity (matched/captures) still hard. Also deleted the `await_in_try.rs` XS-delta pins (−20 and the −38/−26/−1/+3 matrix), reworked `promise_combinator_meter_parity.rs` into a result-parity test, dropped the oracle-count assert in `error_messages_calls.rs`, and made `corpus-to-262` stop requiring computron agreement and stop emitting the `ironhorse-meter-exact` tag.
- **Deliberately kept, untouched:** all own-meter determinism gates (`--repeat`, golden vectors, frozen own-cost pins, `ironhorse-meter-5-raw-N` raw pins), and `rust/endo/tests/ironhorse_meter_bounds.rs` in full — on triage every assertion there is XS-free internal consistency, not myth. The ~15 interp pins were relabeled (frozen own costs, XS as provenance), not weakened.
- **Docs:** sharpened `ironhorse-engine.md` § Metering ("non-goal, not a deferred goal") and fenced the historical stage-2 parity records with an unmissable superseded banner; **retired F074 and F164 explicitly (rejected, with reasons)** plus the async-generator calibration item in the snapshot-store-seam design; added the metering-objective statement to `rust/engine/README.md`; fenced the CHANGELOG archive; stamped dated resolutions onto the architecture review's F4/F130 so their "make parity the bar" option can't be implemented from the page; corrected baseline and test262-runner READMEs.
- **Regrowth mechanism (stated in the PR):** the bit-exact-named harness API set the ambient success criterion; historical text read as doctrine, open work orders (F074/F164/async-gen/baseline invariant #3) instructed parity, the tag name on 1,444 files re-taught it, and the oracle's computron pair invited "difference = bug". Each cut at the root.
- **Gates:** no test262 verdict changes (one skip-label rename to match the runner's existing label). On the ~51 meter-exact failures: the oracle-equality class is retired definitionally; any that were stale own-raw pins remain real and need a deliberate pin refresh — stated honestly in the PR rather than implied fixed.

**Follow-ups (reported, not done):** regenerate the test262 ironhorse tree to drop the 1,444 inert `ironhorse-meter-exact` tags; consider renaming `--gate-meter-exact`; no implementation site chases XS counts at a cost to CPU-time fidelity (one borderline shape-choice noted). One environmental note: `expectation_shards` fails on this host only because /tmp is noexec (passes with exec TMPDIR) — pre-existing, unrelated.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-demolish-xs-computron-parity-myth.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 342 tokens (38742491 cached reads)
- Output: 115513 tokens
- Cost: $53.337748249999976
- Wall-clock: 1488s
- Model(s): claude-fable-5 ×1

<!-- garden-usage-end -->
