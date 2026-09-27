I've added the regression locks for fuzz finding `5e7a173f899ae7a1` (`differential_regexp`) to the standing PR. No port fix was needed: the crash came from the XS test oracle, not from Ironhorse.

**Where it stood:** the earlier attempt left no commits and nothing in the PR, so I started over.

**Reproduction:**
- **Input:** decoded from the journal marker; its sha256 matches `a2e071e9…29324c6dbe` (3 bytes).
- **At the fuzzed SHA `38ca1d18`:** it crashes, using the fuzz service's prebuilt binary for that SHA. The divergence is `match meter ironhorse=14145421312 pin=1260519424`. The difference is exactly 3·2³², so the pin is just the port's meter truncated to 32 bits.
- **On the `ironhorse-fuzz-findings` branch:** `cargo +nightly-2026-08-15 fuzz run differential_regexp <input> -- -runs=1` exits 0.

**Cause:** this is another instance of a known problem. The XS test oracle used to cut its regexp match meter down to 32 bits, and the existing commit `c8497fd88` already widened it to 64 bits. The generated case is a nested `\n*`/`0*`/`0{1,3}` pattern with flag `m`, run on `"00\n00"` from offset 2. It takes 215,842 steps and matches at (2,3), which is what V8 also returns, so the port is correct.

**Changes (commit `d302c0a6c7`, pushed to `kriscendobot:ironhorse-fuzz-findings`):**
- `rust/engine/ironhorse-vm/tests/finding_5e7a173f899ae7a1_regexp_meter_overflow.rs` and its fixture `fixtures/finding-5e7a173f899ae7a1.input.bin`: rebuilds the case from the exact bytes and checks the match, the capture `[(2,3)]` and the full 64-bit meter. It builds without the XS oracle or the `c/moddable` submodule, so CI can run it.
- `ironhorse-fuzz/src/regexp.rs`: new test `finding_5e7a173f899ae7a1_regexp_meter_overflow_agrees`, which checks the result against the fixed oracle.
- A peer's test for finding `51c6a212946102f6` had just been added at the same spot in `regexp.rs`. I kept both tests when resolving the conflict.
- Test results: the new `ironhorse-vm` test passes, and all 33 `ironhorse-fuzz` `finding_` tests pass.

**PR:** `ensure-pr.sh --find-only` found the existing standing PR endojs/endo-but-for-bots#1298, which is a draft on the fixed base `llm-387ea66`. Its head is now `d302c0a6c7`. I posted a comment there describing this finding and why no port change was needed: https://github.com/endojs/endo-but-for-bots/pull/1298#issuecomment-5854869660

**Follow-ups:**
- I did not run the gauntlet. Under the current rules the maintainer triggers it by hand, and the other workers adding fuzz findings haven't run it either.
- The fuzz service tests `38ca1d18`, a commit from before the oracle fix, so it will likely keep reporting this same false crash under new finding IDs.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-fuzz-5e7a173f899ae7a1-repair.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 7 on 2 host(s) (5 unmetered)
- Input: 58 tokens (2024135 cached reads)
- Output: 14215 tokens
- Cost: $1.337831 (5 engagement(s) unpriced)
- Wall-clock: 824s
- Model(s): claude-opus-4-8 ×1, claude-opus-5-5 ×1

<!-- garden-usage-end -->
