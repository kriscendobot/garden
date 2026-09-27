Finding 6be90176ff07c648 turned out to be a bug in the XS comparison oracle, not in the Ironhorse port. The oracle fix is already on the standing branch, so I added regression tests only, pushed them, and documented the finding on the standing PR.

**Reproduction.** I recovered the 9-byte input from the durable artifact and its sha256 matched `241b6de8…fdd4aa12`. At the recorded SHA `38ca1d18` it fails on the first run: `regexp differential divergence vs XS pin … match meter ironhorse=9965535232 pin=1375600640`.

**Cause.** The two meter values differ by exactly 2^33. The regex takes 152062 metered steps, and 152062 × 65536 = 9965535232, which is more than a 32-bit value can hold. At that SHA the XS oracle copied its 64-bit meter into a 32-bit field and truncated it. Ironhorse's value is correct, and the result itself agrees with V8: no match, `null`. Earlier findings in this class were fixed by commit c8497fd88, which widened the oracle's meter fields to 64 bits (finding `5d122a6fc10babd9`). Changing the port would be wrong.

**What changed** (commit `c9a3dcbf0e` on `kriscendobot:ironhorse-fuzz-findings`, pushed after fetching and rebasing onto the latest branch):
- `rust/engine/ironhorse-vm/tests/finding_6be90176ff07c648_regexp_meter_overflow.rs` plus the exact input as a fixture. This test builds without the XS oracle or the `c/moddable` submodule. It regenerates the regex from the input bytes and checks the flag `m`, the subject `"\n  ab\n"`, the non-match, all 15 capture slots and the full meter value, which must not be truncated to 32 bits.
- `rust/engine/ironhorse-fuzz/src/regexp.rs`: a new test, `finding_6be90176ff07c648_regexp_meter_overflow_agrees`, that compares Ironhorse against the widened oracle.
- The new ironhorse-vm test passes. With the submodule linked in temporarily, all 23 `ironhorse-fuzz` regexp tests pass, including the new one. The pinned `rustfmt +1.88.0 --check` is clean on both files.

**PR.** `ensure-pr.sh --find-only` found the existing standing PR, endojs/endo-but-for-bots#1298. I posted a comment there covering this finding, its cause and the solution: https://github.com/endojs/endo-but-for-bots/pull/1298#issuecomment-5855003069

**Gauntlet.** I did not start a gauntlet. One is already running on #1298 (`endojs-endo-but-for-bots-pr1298-gauntlet`, panel stage, iteration 1), and a second would duplicate it. That run's panel started before my commit landed, so its later iterations need to pick up the new head `c9a3dcbf0e`.

**Follow-ups:** none. The job inbox couldn't be checked because the journal clone was offline when I tried.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-fuzz-6be90176ff07c648-repair.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 4 on 2 host(s) (3 unmetered)
- Input: 46 tokens (1441447 cached reads)
- Output: 11153 tokens
- Cost: $1.0660934000000002 (3 engagement(s) unpriced)
- Wall-clock: 557s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
