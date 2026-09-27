## Finding 8ea950859db8a5f7 (`differential_regexp`): regression locked, port change not needed

This was a fault in the XS test oracle, not the Ironhorse port. The oracle truncated the regexp match meter to 32 bits. An earlier commit already on the standing branch (c8497fd88b) fixes that, so there was no engine code to change. I added two regression tests, amended the standing branch, and documented the finding on PR #1298.

**Reproduction.** I recovered the input to a file, and its sha256 matches `74718c92…3025859`. Running `cargo +nightly-2026-08-15 fuzz run differential_regexp` at `38ca1d18` panicked with `match meter ironhorse=5174853632 pin=879886336`. The two values differ by exactly 2^32.

**Cause.** The input generates a 24-group regexp heavy with backreferences, run with no flags against `" \n\n \n"` from offset 1. It matches the empty range [1,1) after 78962 metered steps, so the raw meter is 78962 × 65536 = 5174853632, which is over `u32::MAX`. At the fuzzed commit, the XS oracle stored that value in a 32-bit field and reported only the low 32 bits. The port's value was always correct. This is the same kind of fault as findings 5d122a6f, 822848c7 and 79f0475d, and c8497fd88b fixes it by widening the field to 64 bits.

**Changes (commit `df094c271c` on `kriscendobot:ironhorse-fuzz-findings`, pushed after a fetch and rebase):**
- `rust/engine/ironhorse-vm/tests/finding_8ea950859db8a5f7_regexp_meter_overflow.rs`: a test that builds without the XS oracle or submodule. It replays the exact bytes and pins the match, all 25 captures, and the full meter value, and asserts the meter is not the wrapped 32-bit value.
- `rust/engine/ironhorse-vm/tests/fixtures/finding-8ea950859db8a5f7.input.bin`: the exact 3-byte input.
- `rust/engine/ironhorse-fuzz/src/regexp.rs`: `finding_8ea950859db8a5f7_regexp_meter_overflow_agrees`, which checks that Ironhorse and the fixed XS oracle agree on this case.
- Both new tests pass at the branch head, along with all 41 `ironhorse-fuzz` `finding_*` tests. The pinned rustfmt made no further changes.

**PR.** `ensure-pr.sh` found and adopted the existing standing PR, endojs/endo-but-for-bots#1298, which is still an open draft. The finding is documented in https://github.com/endojs/endo-but-for-bots/pull/1298#issuecomment-5855110121.

**Not done:**
- I did not run the gauntlet. Under the manual-gauntlet rule, prior findings on #1298 left the PR draft for a maintainer to trigger `run the gauntlet #1298`, and I did the same.
- I did not re-run the fuzz binary itself at the current head. Instead, the new test runs the same check that binary makes (`differential_check_regexp`) against the real XS oracle, and gets `Ok(true)`.

**Follow-ups.** This input came from an old fuzz commit (`38ca1d18`) that predates the oracle fix. While the fuzz service keeps fuzzing that commit, it will keep reporting this same false match-meter mismatch. Moving its pinned project checkout to a commit that includes c8497fd88b would stop these repeat findings.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-fuzz-8ea950859db8a5f7-repair.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 4 on 2 host(s) (3 unmetered)
- Input: 60 tokens (2027698 cached reads)
- Output: 12977 tokens
- Cost: $1.2899195999999997 (3 engagement(s) unpriced)
- Wall-clock: 926s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
