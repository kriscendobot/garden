## Finding 45f4af87eaf627c7 (`differential_regexp`): regression locked on the standing PR

This finding didn't need an engine fix. The crash came from the XS reference engine's meter being cut down to 32 bits in the test harness, and that was already fixed on the branch. I added a permanent regression test for it and documented it on the standing PR #1298, where CI passes.

**Where the job stood:** no earlier attempt had committed anything, and there was no mention of this finding on the `ironhorse-fuzz-findings` branch or on PR #1298. So I started from scratch.

**Reproduction:**
- I decoded the input from the journal finding file, and its sha256 matched `4999211e…300a` (3 bytes).
- At `38ca1d18` with `nightly-2026-08-15`, `cargo fuzz run differential_regexp … -runs=1` crashed with `match meter ironhorse=5381685248 pin=1086717952`.
- The two values differ by exactly 2³². The regexp costs 82118 metered steps, so the full meter is 82118 × 65536 = 5381685248, which is more than `u32::MAX`.
- The Rust port was right: it matches empty at (1,1) with all 24 groups unset, and V8 gives the same answer. The harness at the fuzzed commit stored the reference engine's meter in 32 bits, so it wrapped.

**Cause:** this is the same class as findings `13b68e2edb67861a` and `1dc231089278c110`. Commit `c8497fd8`, which widened those meter fields to 64 bits, is already on the branch. At the branch tip the fuzz target runs this input cleanly (exit 0), so there was nothing further to change.

**What changed** (commit `2ebac5561e`, pushed to `kriscendobot:ironhorse-fuzz-findings` with fetch/rebase/push):
- **New test in `ironhorse-vm`:** `tests/finding_45f4af87eaf627c7_regexp_meter_overflow.rs`, plus the input as a fixture. It builds without the reference engine or the `c/moddable` submodule. It pins the match result, all 25 capture slots and the full meter value, and asserts the meter is not the wrapped 32-bit figure.
- **New test in `ironhorse-fuzz`:** `finding_45f4af87eaf627c7_regexp_meter_overflow_agrees` runs the same bytes through the comparison against the reference engine.
- Both tests pass locally, along with the other 29 finding tests in `ironhorse-fuzz`. `cargo fmt --check` is clean.

**Standing PR:** `ensure-pr.sh --find-only` found the existing PR endojs/endo-but-for-bots#1298 (still a draft), so I didn't open a new one. I posted a comment there documenting this finding and its explanation (issuecomment-5854616664). All 34 CI checks on the new head passed.

**Follow-up:** I did not run the review gauntlet. Under the manual-gauntlet rule only you can start it, with **run the gauntlet #1298**.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-fuzz-45f4af87eaf627c7-repair.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 10 on 2 host(s) (7 unmetered)
- Input: 62 tokens (2304144 cached reads)
- Output: 13315 tokens
- Cost: $1.3938248000000002 (7 engagement(s) unpriced)
- Wall-clock: 3675s
- Model(s): claude-opus-4-8 ×2, claude-opus-5-5 ×1

<!-- garden-usage-end -->
