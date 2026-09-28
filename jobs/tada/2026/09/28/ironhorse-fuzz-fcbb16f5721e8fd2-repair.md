Finding `fcbb16f5721e8fd2` needed no port fix. The engine was already right: XS writes this large integer in a longer decimal form, and the harness had flagged the difference in spelling. I added a permanent regression test for it and documented it on the standing PR. I did not run the PR's gauntlet or wait for CI.

- **Reproduced at `38ca1d18`:** I decoded the 6-byte input and its sha256 matched. At that SHA it crashes with `result: oracle="521573131844845570" ironhorse="521573131844845600"`. The generated program works out to `17 * 914358272 * 33554432`, which is the number 521573131844845568.
- **Diagnosis:** both strings parse to that same number. Ironhorse prints the shortest decimal that parses back to it, which is what ECMA-262 requires; Node prints the same `521573131844845600`. XS prints a longer, non-shortest form. This is the large-integer number-formatting class seen in earlier findings.
- **Why the standing branch is already clean:** at tip `c01688e627`, `cargo +nightly-2026-08-15 fuzz run differential_source <input> -- -runs=1` exits 0. The harness's `results_agree` compares Number results by their underlying float value, so different spellings of the same number no longer count as a divergence. No engine code changed.
- **Regression tests (commit `8740f7a35f`, pushed to `kriscendobot:ironhorse-fuzz-findings`):**
  - `rust/engine/ironhorse-vm/tests/finding_fcbb16f5721e8fd2_large_integer_dtoa.rs` replays the exact input without needing the `c/moddable` submodule. It checks that the program completes, that ironhorse prints the shortest form, and that the XS form is the same number.
  - `rust/engine/ironhorse-fuzz/tests/finding_fcbb16f5721e8fd2_large_integer_dtoa.rs` checks that the exact input produces the same result in ironhorse and XS.
  - The input bytes are stored at `ironhorse-vm/tests/fixtures/finding-fcbb16f5721e8fd2.input.bin`.
  - Both tests pass locally.
- **Standing PR:** `ensure-pr.sh` found the existing draft endojs/endo-but-for-bots#1298 and opened nothing new; its head is now `8740f7a35f`. I posted a comment on it covering the case, the diagnosis, the fix and the tests: https://github.com/endojs/endo-but-for-bots/pull/1298#issuecomment-5864095375

**Follow-ups:**
- **Gauntlet for #1298 is stuck:** its panel round 2 (`endojs-endo-but-for-bots-pr1298-gauntlet-panel-2`) is parked in `jobs/plan/`, marked doomed after its retries ran out (`requeue-exhausted`, classified deterministic). I didn't post a duplicate gauntlet. A maintainer needs to decide whether to promote or restage it.
- **CI:** it hasn't run yet on the new head. The change only adds tests.

## Panel-head freshness

Disposition: **review required**. The last completed panel reviewed `558a9b7d`; this job presented `8740f7a35f3d9d3f15e1d861dd92540e699406cb`. The old panel verdict does not cover the current head. No gauntlet was staged; the maintainer received a deduplicated stale-review action.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-fuzz-fcbb16f5721e8fd2-repair.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 11 on 3 host(s) (7 unmetered)
- Input: 58 tokens (1831169 cached reads)
- Output: 12279 tokens
- Cost: $1.1819658 (7 engagement(s) unpriced)
- Wall-clock: 1385s
- Model(s): claude-opus-4-8 ×1, claude-opus-5-5 ×3

<!-- garden-usage-end -->
