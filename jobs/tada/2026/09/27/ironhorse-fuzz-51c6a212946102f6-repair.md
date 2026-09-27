Finding `51c6a212946102f6` (`differential_regexp`) is now covered by regression tests on the standing PR endojs/endo-but-for-bots#1298. It needed no engine fix: the bug was in the XS comparison oracle, and it's already fixed on the branch.

**What I found**
- The prior attempt had committed nothing for this finding, so I started over. I decoded the input from the journal and its sha256 matched `a7224c7f…cc02f6`.
- **At the recorded SHA `38ca1d18`** (with `nightly-2026-08-15`) it reproduces: `match meter ironhorse=4658495488 pin=363528192`. The pattern is a deeply nested quantified-group regexp with the `s` flag, run on `"aaaaaaaa"` from offset 0.
- **Cause:** the two meter values differ by exactly 2³². The Rust port reports the correct 64-bit meter; the XS oracle cut it to 32 bits. This is the same class as the earlier meter-overflow findings. The existing widening commit c8497fd88b (from finding `5d122a6fc10babd9`) fixes it, and the input passes `cargo fuzz run … -runs=1` at the branch tip.

**What changed** (commit `4a2b092583`, pushed to `ironhorse-fuzz-findings`)
- **New test file** `rust/engine/ironhorse-vm/tests/finding_51c6a212946102f6_regexp_meter_overflow.rs`: it doesn't need the `c/moddable` submodule. It replays the exact 31-byte input from a committed fixture and pins the pattern, flags, subject, all 16 capture offsets, and the full meter `4_658_495_488`. It also asserts the meter is not the value cut to 32 bits. It passes.
- **New test** in `ironhorse-fuzz/src/regexp.rs`: `finding_51c6a212946102f6_regexp_meter_overflow_agrees` checks that the port and the XS oracle agree on this input. All 32 `finding_` tests in that crate pass.
- **PR:** `ensure-pr.sh` found the existing standing PR #1298 (still a draft), so nothing new was opened. I posted a comment documenting the case, its cause and the fix (issuecomment-5854865133).

**Gauntlet and CI**
- The gauntlet for #1298 is already on the board (`endojs-endo-but-for-bots-pr1298-gauntlet`, with its clean step running), so I didn't post another.
- Two later findings have since been stacked on my commit; the PR head is now `1219e436`.
- Only a few CI checks run while the PR is a draft: none failed, one passed and two were skipped. The full test run hasn't happened yet; it will come with the gauntlet.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-fuzz-51c6a212946102f6-repair.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 5 on 3 host(s) (3 unmetered)
- Input: 48 tokens (1561282 cached reads)
- Output: 11353 tokens
- Cost: $1.1140284 (3 engagement(s) unpriced)
- Wall-clock: 1114s
- Model(s): claude-opus-5-5 ×2

<!-- garden-usage-end -->
