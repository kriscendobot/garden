I found the job already finished: my earlier session committed and pushed the work, documented it on the pull request, and the review gauntlet on that PR is already running. I made no further changes in this pass.

**What happened:**
- The finding reproduced at the recorded project SHA `38ca1d18`: the fuzzer exited 77 with `match meter ironhorse=5530451968 pin=1235484672`.
- **Cause:** the Ironhorse engine port was right. The XS comparison oracle cut the 64-bit regexp match meter down to 32 bits (`5530451968 mod 2^32 = 1235484672`), so the fuzzer saw a false mismatch.
- **Fix:** commit `c8497fd88b`, already on the standing branch, widens the oracle's meter to 64 bits. No engine change was needed.

**What changed:** commit `1b2faf3f75` ("test(ironhorse): regression-lock regexp meter overflow (fuzz e2a75557f762cd9c)") is on `kriscendobot:ironhorse-fuzz-findings`. Other finding commits have since landed on top of it; the branch head is now `20da8f94bf`. The commit adds:
- The exact 6-byte input (sha256 checked) and the 349-byte regexp it generates, as test fixtures under `rust/engine/ironhorse-vm/tests/fixtures/`.
- A test in `ironhorse-vm` that needs no submodule: `tests/finding_e2a75557f762cd9c_regexp_meter_overflow.rs`. It pins that the input still does not match and that the meter reads `5_530_451_968` at full width.
- A matching test in `ironhorse-fuzz/src/regexp.rs` that checks the port and the widened XS oracle agree.

**Checks:**
- These passed: `fmt --check`, both finding tests, the `fuzz run differential_regexp … -runs=1` replay, and the pre-push probes.
- Putting the old 32-bit cut back makes the matching oracle test fail with the recorded divergence, so it catches the bug.
- The full `cargo test -p ironhorse-vm` fails on `acosh(MAX)` in `math_determinism`, and strict Clippy reports five warnings. Both are outside this change and predate it.

**Pull request:** the standing PR https://github.com/endojs/endo-but-for-bots/pull/1298 (draft, open) documents this finding in comment https://github.com/endojs/endo-but-for-bots/pull/1298#issuecomment-5864350935: input, reproduction, cause, fix, and evidence. The gauntlet is running on the job board: `endojs-endo-but-for-bots-pr1298-gauntlet` is in `gauntlet/`, and its fix-loop job `…-gauntlet-fix-2` is in progress. That comment still lists CI as pending on head `1b2faf3f75`.

**Follow-ups:**
- CI result not checked: I did not re-check CI on the current head (`20da8f94bf`); the running gauntlet covers it.
- Inbox not drained: I couldn't read my inbox this pass because the journal clone timed out.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-fuzz-e2a75557f762cd9c-repair.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 6 on 2 host(s) (3 unmetered)
- Input: 20 tokens (553734 cached reads)
- Output: 3514 tokens
- Cost: $0.6070108000000001 (3 engagement(s) unpriced)
- Wall-clock: 3610s
- Model(s): claude-opus-4-8 ×1, claude-opus-5-5 ×2

<!-- garden-usage-end -->
