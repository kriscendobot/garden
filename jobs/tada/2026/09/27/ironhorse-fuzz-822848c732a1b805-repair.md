## Finding `822848c732a1b805` (`differential_regexp`): regression-locked, no port fix needed

**Reproduced.** The recorded input matched its sha256 (`97e615f4…3d082be`, 20 bytes). I ran the service's prebuilt base-SHA fuzz binary with `-runs=1` on it and it panicked with `match meter ironhorse=4976410624 pin=681443328`. Those two values differ by exactly 2^32.

**The port is correct; the XS oracle was wrong.** The generated case is a backreference-heavy alternation, flag `m`, run against `"  bbb"` at offset 2. It does not match, and V8 also returns `null`. It takes 75934 metered steps, so the full meter is 75934 × 65536 = 4976410624, which is more than `u32::MAX`. At the recorded base, the XS oracle cut its 64-bit meter down to 32 bits. This is the same kind of bug as finding `5d122a6fc10babd9`, and the fix already on the standing branch (the oracle-widening commit c8497fd88) covers it. I did not change any engine code.

**What changed** (commit `ecf5d81252`, pushed to `kriscendobot:ironhorse-fuzz-findings` with a fetch/rebase/push loop):
- **Test fixture:** `rust/engine/ironhorse-vm/tests/fixtures/finding-822848c732a1b805.input.bin`, the exact input bytes.
- **Standalone test:** `rust/engine/ironhorse-vm/tests/finding_822848c732a1b805_regexp_meter_overflow.rs`. It rebuilds the case from the fixture without needing the XS submodule, and checks the no-match result, all 8 captures unset, and the full meter value of 4976410624 (not the cut-down one).
- **Differential test:** `ironhorse-fuzz/src/regexp.rs` gains `finding_822848c732a1b805_regexp_meter_overflow_agrees`. It checks that the port and the fixed XS oracle now agree (`Ok(false)`).
- **Verification:** both tests pass locally, and rustfmt (pinned nightly) reports no changes. I built with the pinned `c/moddable` submodule linked in temporarily, then restored the empty directory before committing.

**Standing PR:** `ensure-pr.sh --find-only` found the existing endojs/endo-but-for-bots#1298 (base `llm-387ea66`), so no new PR was opened. I wrote up this finding and its explanation in a PR comment: https://github.com/endojs/endo-but-for-bots/pull/1298#issuecomment-5855035049

**Follow-ups:**
- **CI not confirmed:** another worker pushed on top of my commit right away (`976d4e005a`, finding 79f0475dd0440b2d; my commit is still in the branch history). When I stopped, CI for that new tip was still running, so I have no CI result for this change.
- **Gauntlet not run:** I did not post a gauntlet for #1298. Under the manual-gauntlet rule it has to be started by the maintainer with "run the gauntlet #1298".
- **Inbox not checked:** my inbox could not be read because the journal clone timed out.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-fuzz-822848c732a1b805-repair.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 5 on 2 host(s) (4 unmetered)
- Input: 42 tokens (1281482 cached reads)
- Output: 10376 tokens
- Cost: $0.9632244 (4 engagement(s) unpriced)
- Wall-clock: 1135s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
