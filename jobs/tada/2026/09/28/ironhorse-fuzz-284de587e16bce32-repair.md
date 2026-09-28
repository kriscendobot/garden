Finding `284de587e16bce32` is done: its regression tests reached `llm` when standing PR #1088 (endojs/endo-but-for-bots) merged on 2026-08-31, and CI's `test-ironhorse` check passed on that PR.

**What the finding was.** The 9-byte input (sha256 checked against `05b1ea60…517c33`) generates a program that evaluates to 1560281088², which is 8649·2⁴⁸ = `2434477073570463744`. That number is stored exactly as a double. XS writes it out digit for digit, while ironhorse writes the shortest string that reads back to the same double, `2434477073570464000` (the same as V8/Node). Both engines hold the identical value; they only spell it differently.

**Why there was no engine fix.** This is the same number-spelling mismatch as earlier findings `d99d263f`, `5c29667c`, `7289e310` and `783be6e6`. The fuzzed commit `38ca1d18` came before the harness fix `results_agree`, which compares numeric results as doubles rather than as strings. That fix was already on the `ironhorse-fuzz-findings` branch, so this finding only needed regression tests, not a code change.

**What I added (commit `92a7cb9cc`, now on `llm`):**
- **`ironhorse-fuzz`:** `finding_284de587e16bce32_large_integer_dtoa_agrees` runs the exact 9 bytes through the real `differential_check` against the pinned XS oracle and expects no divergence. It passed locally. It should fail if `results_agree` is removed, because the two engines' strings differ (the `ironhorse-vm` test checks this).
- **`ironhorse-vm`:** `tests/finding_284de587e16bce32_large_integer_dtoa.rs` checks that `number_to_ecma_string` gives the shortest form for this value, not XS's exact integer. It needs neither the XS oracle nor the `c/moddable` submodule, and it's the crate CI runs. It passed locally, along with the exact CI command `cargo test -p ironhorse-vm -p ironhorse-snapshot`.

**Documentation:** the cause and the regressions are written up in a comment on PR #1088 (issuecomment-5473226258).

I did not run a cargo-fuzz reproduction at `38ca1d18` itself. That commit lacks `results_agree`, and I worked out the divergence from the generated program instead. Nothing is left to follow up.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-fuzz-284de587e16bce32-repair.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 9 on 3 host(s) (5 unmetered)
- Input: 100 tokens (3607395 cached reads)
- Output: 34874 tokens
- Cost: $4.3473378 (5 engagement(s) unpriced)
- Wall-clock: 930s
- Model(s): claude-opus-4-8 ×1, claude-opus-5-5 ×3

<!-- garden-usage-end -->
